import 'package:quran_reels/features/reciter/domain/entities/reciter.dart';

class ReciterModel {
  final String id;
  final String name;
  final String audioBaseUrl;
  final String style;

  const ReciterModel({
    required this.id,
    required this.name,
    required this.audioBaseUrl,
    required this.style,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      audioBaseUrl: json['audioBaseUrl'] as String,
      style: json['style'] as String? ?? '',
    );
  }

  Reciter toDomain() {
    return Reciter(
      id: id,
      name: name,
      audioBaseUrl: audioBaseUrl,
      style: style,
    );
  }
}