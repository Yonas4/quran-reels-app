import 'package:quran_reels/features/template/domain/entities/template.dart';
import 'package:quran_reels/core/utils/text_overlay_config.dart';

class TemplateModel {
  final String id;
  final String name;
  final String backgroundAssetPath;
  final TextOverlayConfig textPosition;
  final String description;

  const TemplateModel({
    required this.id,
    required this.name,
    required this.backgroundAssetPath,
    required this.textPosition,
    required this.description,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as String,
      name: json['name'] as String,
      backgroundAssetPath: json['backgroundAssetPath'] as String,
      textPosition: TextOverlayConfig.fromJson(json['textPosition'] as Map<String, dynamic>),
      description: json['description'] as String? ?? '',
    );
  }

  Template toDomain() {
    return Template(
      id: id,
      name: name,
      backgroundAssetPath: backgroundAssetPath,
      textPosition: textPosition,
      description: description,
    );
  }
}