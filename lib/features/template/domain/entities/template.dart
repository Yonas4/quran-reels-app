import 'package:quran_reels/core/utils/text_overlay_config.dart';

class Template {
  final String id;
  final String name;
  final String backgroundAssetPath;
  final TextOverlayConfig textPosition;
  final String description;

  const Template({
    required this.id,
    required this.name,
    required this.backgroundAssetPath,
    required this.textPosition,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Template && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}