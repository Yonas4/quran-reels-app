import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_reels/core/constants/app_exceptions.dart';

class ExportService {
  Future<String> saveToLocal(String videoFilePath) async {
    try {
      final file = File(videoFilePath);
      if (!await file.exists()) {
        throw StorageException('Video file not found');
      }

      final dir = await getApplicationDocumentsDirectory();
      final fileName = videoFilePath.split('/').last;
      final destinationPath = '${dir.path}/QuranReels/$fileName';

      final dir2 = Directory('${dir.path}/QuranReels');
      if (!await dir2.exists()) {
        await dir2.create(recursive: true);
      }

      await file.copy(destinationPath);
      return destinationPath;
    } on FileSystemException catch (e) {
      throw StorageException('Failed to save video: ${e.message}');
    }
  }

  Future<void> shareVideo(String videoFilePath) async {
    try {
      final file = File(videoFilePath);
      if (!await file.exists()) {
        throw ShareException('Video file not found');
      }

      final result = await Share.shareXFiles(
        [XFile(videoFilePath)],
        text: 'Quran Reel',
      );

      if (result.status == ShareResultStatus.unavailable) {
        throw ShareException('Share sheet not available on this device');
      }
    } catch (e) {
      if (e is ShareException) rethrow;
      throw ShareException('Failed to share video: $e');
    }
  }
}