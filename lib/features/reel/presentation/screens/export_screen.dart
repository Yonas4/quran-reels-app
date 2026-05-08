import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/shared/providers/wizard_provider.dart';
import 'package:quran_reels/core/utils/export_service.dart';
import 'package:quran_reels/core/constants/app_exceptions.dart';
import 'package:quran_reels/core/theme/app_theme.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  final ExportService _exportService = ExportService();
  String? _successMessage;
  String? _errorMessage;
  bool _isSaving = false;
  bool _isSharing = false;

  Future<void> _saveToLocal() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final videoPath = ref.read(wizardProvider).generatedVideoPath;
      if (videoPath == null) {
        throw StateException('No video to save');
      }

      await _exportService.saveToLocal(videoPath);
      setState(() {
        _successMessage = 'Video saved successfully!';
        _isSaving = false;
      });
    } on StorageException {
      setState(() {
        _errorMessage = 'Failed to save video. Please check storage permissions and try again.';
        _isSaving = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. The video is still available for retry.';
        _isSaving = false;
      });
    }
  }

  Future<void> _shareVideo() async {
    setState(() {
      _isSharing = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final videoPath = ref.read(wizardProvider).generatedVideoPath;
      if (videoPath == null) {
        throw StateException('No video to share');
      }

      await _exportService.shareVideo(videoPath);
      setState(() {
        _successMessage = 'Video shared!';
        _isSharing = false;
      });
    } on ShareException {
      setState(() {
        _errorMessage = 'Failed to share video. The video is still available for retry.';
        _isSharing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. The video is still available for retry.';
        _isSharing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = ref.read(wizardProvider).generatedVideoPath != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: AppTheme.primaryColor),
            const SizedBox(height: 16),
            Text(
              'Video Ready!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            if (_successMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _successMessage!,
                  style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            if (hasVideo) ...[
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveToLocal,
                icon: _isSaving
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save),
                label: const Text('Save to Device'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isSharing ? null : _shareVideo,
                icon: _isSharing
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}