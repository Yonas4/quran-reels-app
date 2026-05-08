import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/shared/providers/wizard_provider.dart';
import 'package:quran_reels/shared/providers/connectivity_provider.dart';
import 'package:quran_reels/features/reciter/data/services/audio_preview_service.dart';
import 'package:quran_reels/core/theme/app_theme.dart';
import 'package:quran_reels/core/constants/app_exceptions.dart';

final audioPreviewProvider = Provider<AudioPreviewService>((ref) {
  return AudioPreviewService();
});

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  final AudioPreviewService _audioService = AudioPreviewService();
  bool _isPlaying = false;
  bool _hasNetworkError = false;
  String? _errorMessage;

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    final reciter = ref.read(wizardProvider).selectedReciter;
    final surahId = ref.read(wizardProvider).selectedSurah?.id;
    final ayahNumber = ref.read(wizardProvider).selectedAyah?.numberInSurah;

    if (reciter == null || surahId == null || ayahNumber == null) return;

    final connected = await ref.read(connectivityServiceProvider).isConnected;
    if (!connected) {
      setState(() {
        _hasNetworkError = true;
        _errorMessage = 'No internet connection. Audio preview requires internet. Please check your connection and try again.';
      });
      return;
    }

    setState(() {
      _hasNetworkError = false;
      _errorMessage = null;
    });

    try {
      final audioUrl = reciter.getAudioUrl(surahId, ayahNumber);
      if (_isPlaying) {
        await _audioService.pausePreview();
        setState(() => _isPlaying = false);
      } else {
        await _audioService.playPreview(audioUrl);
        setState(() => _isPlaying = true);
      }
    } on NetworkException catch (_) {
      setState(() {
        _hasNetworkError = true;
        _isPlaying = false;
        _errorMessage = 'No internet connection. Audio preview requires internet. Please check your connection and try again.';
      });
    } catch (e) {
      setState(() {
        _hasNetworkError = true;
        _isPlaying = false;
        _errorMessage = 'Unable to play audio. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(wizardProvider);
    final selectedAyah = wizardState.selectedAyah;
    final selectedTemplate = wizardState.selectedTemplate;
    final selectedReciter = wizardState.selectedReciter;

    if (selectedAyah == null || selectedTemplate == null || selectedReciter == null) {
      return const Center(child: Text('Incomplete selections'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          SizedBox(
            width: AppTheme.previewWidth,
            height: AppTheme.previewHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      selectedTemplate.backgroundAssetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          selectedAyah.textUthmani,
                          style: TextStyle(
                            fontFamily: selectedTemplate.textPosition.fontFamily,
                            fontSize: selectedTemplate.textPosition.fontSize * 0.4,
                            color: _parseColor(selectedTemplate.textPosition.fontColor),
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Reciter: ${selectedReciter.name}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Text(
            '${wizardState.selectedSurah?.nameArabic ?? ""} : ${selectedAyah.numberInSurah}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _toggleAudio,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlaying ? 'Pause Audio' : 'Play Audio'),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: _hasNetworkError ? _toggleAudio : null,
              child: const Text('Retry'),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: wizardState.isReadyForGeneration
                ? () {
                    _audioService.stopPreview();
                    ref.read(wizardProvider.notifier).next();
                  }
                : null,
            icon: const Icon(Icons.videocam),
            label: const Text('Generate Video'),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}