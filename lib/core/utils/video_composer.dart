import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:quran_reels/features/reel/domain/entities/reel_config.dart';
import 'package:quran_reels/core/constants/app_constants.dart';
import 'package:quran_reels/core/constants/app_exceptions.dart';
import 'package:quran_reels/core/utils/quran_text_renderer.dart';

class VideoComposer {
  Future<String> generateVideo(
    ReelConfig config, {
    required void Function(double progress) onProgress,
    required String outputPath,
  }) async {
    if (!config.isReadyForGeneration) {
      throw StateException('Cannot generate video: all selections are required');
    }

    final ayahText = config.selectedAyah!.textUthmani;
    final templatePath = config.selectedTemplate!.backgroundAssetPath;
    final reciterAudioUrl = config.selectedReciter!.getAudioUrl(
      config.selectedSurah!.id,
      config.selectedAyah!.numberInSurah,
    );

    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final String outputFilePath = '$outputPath/reel_$timestamp.mp4';
    final String textOverlayPath = '${tempDir.path}/text_overlay_$timestamp.png';
    final String audioCachePath = '${tempDir.path}/audio_$timestamp.mp3';

    try {
      onProgress(0.1);
      final audioFile = await _downloadAudio(reciterAudioUrl, audioCachePath);

      onProgress(0.3);
      final textOverlay = await QuranTextRenderer().renderQuranText(
        ayahText,
        config.selectedTemplate!.textPosition,
        canvasWidth: AppConstants.videoWidth.toInt(),
        canvasHeight: AppConstants.videoHeight.toInt(),
      );
      await File(textOverlayPath).writeAsBytes(textOverlay);

      onProgress(0.5);
      final backgroundPath = await _getAssetPath(templatePath);

      final command = '-loop 1 -framerate ${AppConstants.videoFps} '
          '-i "$backgroundPath" '
          '-i "$textOverlayPath" '
          '-i "$audioFile" '
          '-filter_complex "[0:v][1:v]overlay=0:0:format=auto" '
          '-c:v ${AppConstants.videoCodec} -preset ${AppConstants.videoPreset} '
          '-crf ${AppConstants.videoCrf} '
          '-x264-params force-cfr=1 '
          '-c:a ${AppConstants.audioCodec} -b:a ${AppConstants.audioBitrate} '
          '-ac ${AppConstants.audioChannels} -ar ${AppConstants.audioSampleRate} '
          '-pix_fmt ${AppConstants.pixelFormat} '
          '-shortest -movflags +faststart '
          '-map_metadata -1 '
          '-y "$outputFilePath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        final output = await session.getOutput();
        throw CompositionException('Video generation failed: $output');
      }

      onProgress(1.0);

      if (!File(outputFilePath).existsSync()) {
        throw CompositionException('Output file was not created');
      }

      return outputFilePath;
    } catch (e) {
      try {
        await File(textOverlayPath).delete();
        await File(audioCachePath).delete();
      } catch (_) {}
      if (e is CompositionException || e is NetworkException || e is StateException) {
        rethrow;
      }
      throw CompositionException('Video generation failed: $e');
    }
  }

  Future<String> _downloadAudio(String url, String localPath) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode != 200) {
        throw NetworkException('Failed to download audio: HTTP ${response.statusCode}');
      }

      final file = File(localPath);
      final sink = file.openWrite();
      await response.pipe(sink);
      await sink.close();
      client.close();

      return localPath;
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to download audio: $e');
    }
  }

  Future<String> _getAssetPath(String assetPath) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final tempPath = '${tempDir.path}/$fileName';

    final byteData = await rootBundle.load(assetPath);
    await File(tempPath).writeAsBytes(byteData.buffer.asUint8List());

    return tempPath;
  }
}