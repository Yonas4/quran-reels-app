import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/features/surah/domain/entities/surah.dart';
import 'package:quran_reels/features/surah/domain/entities/ayah.dart';
import 'package:quran_reels/features/reciter/domain/entities/reciter.dart';
import 'package:quran_reels/features/template/domain/entities/template.dart';
import 'package:quran_reels/features/reel/domain/entities/reel_config.dart';
import 'package:quran_reels/core/constants/app_constants.dart';

class WizardNotifier extends StateNotifier<ReelConfig> {
  WizardNotifier() : super(const ReelConfig());

  void selectSurah(Surah surah) {
    state = state.copyWith(selectedSurah: surah);
  }

  void selectAyah(Ayah ayah) {
    state = state.copyWith(selectedAyah: ayah);
  }

  void selectReciter(Reciter reciter) {
    state = state.copyWith(selectedReciter: reciter);
  }

  void selectTemplate(Template template) {
    state = state.copyWith(selectedTemplate: template);
  }

  void next() {
    if (state.currentStep < AppConstants.totalWizardSteps - 1 && state.canProceed) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void back() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setGenerating(bool isGenerating) {
    state = state.copyWith(isGenerating: isGenerating);
  }

  void setGenerationProgress(double progress) {
    state = state.copyWith(generationProgress: progress);
  }

  void setGeneratedVideoPath(String path) {
    state = state.copyWith(generatedVideoPath: path);
  }

  void reset() {
    state = const ReelConfig();
  }

  void resetSelections() {
    state = const ReelConfig();
  }
}

final wizardProvider = StateNotifierProvider<WizardNotifier, ReelConfig>((ref) {
  return WizardNotifier();
});