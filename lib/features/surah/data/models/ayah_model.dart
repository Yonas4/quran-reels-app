import 'package:quran_reels/features/surah/domain/entities/ayah.dart';

class AyahModel {
  final int id;
  final int surahId;
  final int numberInSurah;
  final String textUthmani;
  final int juz;
  final int page;

  const AyahModel({
    required this.id,
    required this.surahId,
    required this.numberInSurah,
    required this.textUthmani,
    required this.juz,
    required this.page,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json, {int? surahIdOverride}) {
    return AyahModel(
      id: json['number'] as int,
      surahId: surahIdOverride ?? json['surahId'] as int? ?? 0,
      numberInSurah: json['numberInSurah'] as int,
      textUthmani: json['text'] as String,
      juz: json['juz'] as int? ?? 1,
      page: json['page'] as int? ?? 1,
    );
  }

  Ayah toDomain() {
    return Ayah(
      id: id,
      surahId: surahId,
      numberInSurah: numberInSurah,
      textUthmani: textUthmani,
      juz: juz,
      page: page,
    );
  }
}