import 'package:quran_reels/features/surah/domain/entities/surah.dart';
import 'package:quran_reels/features/surah/domain/entities/ayah.dart';
import 'package:quran_reels/features/reciter/domain/entities/reciter.dart';
import 'package:quran_reels/features/template/domain/entities/template.dart';

class ReelConfig {
  final Surah? selectedSurah;
  final Ayah? selectedAyah;
  final Reciter? selectedReciter;
  final Template? selectedTemplate;
  final int currentStep;
  final String? generatedVideoPath;
  final bool isGenerating;
  final double generationProgress;

  const ReelConfig({
    this.selectedSurah,
    this.selectedAyah,
    this.selectedReciter,
    this.selectedTemplate,
    this.currentStep = 0,
    this.generatedVideoPath,
    this.isGenerating = false,
    this.generationProgress = 0.0,
  });

  bool get canProceed {
    switch (currentStep) {
      case 0:
        return selectedSurah != null;
      case 1:
        return selectedAyah != null;
      case 2:
        return selectedReciter != null;
      case 3:
        return selectedTemplate != null;
      case 4:
        return selectedSurah != null &&
            selectedAyah != null &&
            selectedReciter != null &&
            selectedTemplate != null;
      default:
        return true;
    }
  }

  bool get isReadyForGeneration =>
      selectedSurah != null &&
      selectedAyah != null &&
      selectedReciter != null &&
      selectedTemplate != null;

  ReelConfig copyWith({
    Surah? selectedSurah,
    Ayah? selectedAyah,
    Reciter? selectedReciter,
    Template? selectedTemplate,
    int? currentStep,
    String? generatedVideoPath,
    bool? isGenerating,
    double? generationProgress,
    bool clearSelection = false,
  }) {
    return ReelConfig(
      selectedSurah: clearSelection ? null : (selectedSurah ?? this.selectedSurah),
      selectedAyah: clearSelection ? null : (selectedAyah ?? this.selectedAyah),
      selectedReciter: clearSelection ? null : (selectedReciter ?? this.selectedReciter),
      selectedTemplate: clearSelection ? null : (selectedTemplate ?? this.selectedTemplate),
      currentStep: currentStep ?? this.currentStep,
      generatedVideoPath: generatedVideoPath ?? this.generatedVideoPath,
      isGenerating: isGenerating ?? this.isGenerating,
      generationProgress: generationProgress ?? this.generationProgress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReelConfig &&
          runtimeType == other.runtimeType &&
          selectedSurah == other.selectedSurah &&
          selectedAyah == other.selectedAyah &&
          selectedReciter == other.selectedReciter &&
          selectedTemplate == other.selectedTemplate &&
          currentStep == other.currentStep &&
          isGenerating == other.isGenerating;

  @override
  int get hashCode => Object.hash(
        selectedSurah,
        selectedAyah,
        selectedReciter,
        selectedTemplate,
        currentStep,
        isGenerating,
      );
}