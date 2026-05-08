import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/shared/providers/wizard_provider.dart';
import 'package:quran_reels/shared/providers/connectivity_provider.dart';
import 'package:quran_reels/features/reel/domain/entities/reel_config.dart';
import 'package:quran_reels/core/constants/app_constants.dart';
import 'package:quran_reels/core/theme/app_theme.dart';
import 'package:quran_reels/features/surah/presentation/screens/surah_selection_screen.dart';
import 'package:quran_reels/features/surah/presentation/screens/ayah_selection_screen.dart';
import 'package:quran_reels/features/reciter/presentation/screens/reciter_selection_screen.dart';
import 'package:quran_reels/features/template/presentation/screens/template_selection_screen.dart';
import 'package:quran_reels/features/reel/presentation/screens/preview_screen.dart';
import 'package:quran_reels/features/reel/presentation/screens/generation_screen.dart';
import 'package:quran_reels/features/reel/presentation/screens/export_screen.dart';

class WizardScreen extends ConsumerWidget {
  const WizardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(wizardProvider);
    final isOnline = ref.watch(initialConnectivityProvider).valueOrNull ?? true;

    return PopScope(
      canPop: wizardState.currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && wizardState.currentStep > 0) {
          ref.read(wizardProvider.notifier).back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle(wizardState.currentStep)),
          leading: wizardState.currentStep > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => ref.read(wizardProvider.notifier).back(),
                )
              : null,
        ),
        body: Column(
          children: [
            if (!isOnline)
              Container(
                width: double.infinity,
                color: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No internet connection. Audio preview and generation require internet.',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: IndexedStack(
                index: wizardState.currentStep,
                children: const [
                  SurahSelectionScreen(),
                  AyahSelectionScreen(),
                  ReciterSelectionScreen(),
                  TemplateSelectionScreen(),
                  PreviewScreen(),
                  GenerationScreen(),
                  ExportScreen(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildStepIndicator(context, ref, wizardState),
      ),
    );
  }

  String _getTitle(int step) {
    switch (step) {
      case AppConstants.wizardStepSurah: return 'Select Surah';
      case AppConstants.wizardStepAyah: return 'Select Ayah';
      case AppConstants.wizardStepReciter: return 'Select Reciter';
      case AppConstants.wizardStepTemplate: return 'Select Template';
      case AppConstants.wizardStepPreview: return 'Preview';
      case AppConstants.wizardStepGenerate: return 'Generating';
      case AppConstants.wizardStepExport: return 'Export';
      default: return 'Quran Reels';
    }
  }

  Widget _buildStepIndicator(BuildContext context, WidgetRef ref, ReelConfig state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(AppConstants.totalWizardSteps, (index) {
          final isActive = index == state.currentStep;
          final isCompleted = index < state.currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.primaryColor
                    : isActive
                        ? AppTheme.accentColor
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}