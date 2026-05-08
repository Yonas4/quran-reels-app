import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/shared/providers/wizard_provider.dart';
import 'package:quran_reels/shared/providers/connectivity_provider.dart';
import 'package:quran_reels/core/utils/video_composer.dart';
import 'package:quran_reels/core/constants/app_exceptions.dart';
import 'package:path_provider/path_provider.dart';

class GenerationScreen extends ConsumerStatefulWidget {
  const GenerationScreen({super.key});

  @override
  ConsumerState<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends ConsumerState<GenerationScreen> {
  String? _errorMessage;
  bool _isGenerating = false;

  Future<void> _generateVideo() async {
    final connected = await ref.read(connectivityServiceProvider).isConnected;
    if (!connected) {
      setState(() {
        _errorMessage = 'No internet connection. Video generation requires downloading reciter audio. Please check your connection and try again.';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    ref.read(wizardProvider.notifier).setGenerating(true);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final composer = VideoComposer();
      final videoPath = await composer.generateVideo(
        ref.read(wizardProvider),
        onProgress: (progress) {
          ref.read(wizardProvider.notifier).setGenerationProgress(progress);
        },
        outputPath: dir.path,
      );

      ref.read(wizardProvider.notifier).setGeneratedVideoPath(videoPath);
      ref.read(wizardProvider.notifier).next();
    } on NetworkException {
      setState(() {
        _errorMessage = 'Network error: Please check your internet connection and try again.';
      });
    } on CompositionException {
      setState(() {
        _errorMessage = 'Video generation failed. Please try again.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
      ref.read(wizardProvider.notifier).setGenerating(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(wizardProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isGenerating || wizardState.isGenerating) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Generating your Quran Reel...',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: wizardState.generationProgress,
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(height: 8),
              Text(
                '${(wizardState.generationProgress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ] else if (_errorMessage != null) ...[
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _generateVideo,
                child: const Text('Retry'),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _generateVideo,
                icon: const Icon(Icons.videocam),
                label: const Text('Start Generation'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}