import 'package:quran_reels/features/reel/domain/entities/reel_config.dart';

class GeneratedReel {
  final String id;
  final ReelConfig config;
  final String videoFilePath;
  final DateTime createdAt;
  final int fileSizeBytes;

  const GeneratedReel({
    required this.id,
    required this.config,
    required this.videoFilePath,
    required this.createdAt,
    required this.fileSizeBytes,
  });
}