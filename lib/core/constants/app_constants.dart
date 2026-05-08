class AppConstants {
  static const String appName = 'Quran Reels';

  static const double videoWidth = 1080.0;
  static const double videoHeight = 1920.0;
  static const int videoFps = 30;
  static const int videoCrf = 18;
  static const String videoCodec = 'libx264';
  static const String audioCodec = 'aac';
  static const int audioBitrate = 192000;
  static const int audioSampleRate = 44100;
  static const int audioChannels = 2;
  static const String videoPreset = 'medium';
  static const String pixelFormat = 'yuv420p';
  static const double videoAspectRatio = 9 / 16;

  static const String defaultFontFamily = 'ScheherazadeNew';
  static const String defaultFontColor = '#FFFFFF';
  static const double defaultFontSize = 48.0;
  static const double defaultTextX = 0.5;
  static const double defaultTextY = 0.5;
  static const double defaultMaxWidth = 0.85;
  static const String defaultTextAlign = 'center';

  static const int surahCount = 114;
  static const int totalAyahCount = 6236;

  static const int wizardStepSurah = 0;
  static const int wizardStepAyah = 1;
  static const int wizardStepReciter = 2;
  static const int wizardStepTemplate = 3;
  static const int wizardStepPreview = 4;
  static const int wizardStepGenerate = 5;
  static const int wizardStepExport = 6;
  static const int totalWizardSteps = 7;

  static const Duration videoGenerationTimeout = Duration(seconds: 120);
  static const Duration audioPreviewTimeout = Duration(seconds: 30);
}