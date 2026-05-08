import 'package:quran_reels/features/surah/domain/entities/surah.dart';

class SurahModel {
  final int id;
  final String nameArabic;
  final String nameTransliteration;
  final String nameTranslation;
  final int ayahCount;
  final String revelationType;
  final int revelationOrder;

  const SurahModel({
    required this.id,
    required this.nameArabic,
    required this.nameTransliteration,
    required this.nameTranslation,
    required this.ayahCount,
    required this.revelationType,
    required this.revelationOrder,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['number'] as int,
      nameArabic: json['name'] as String,
      nameTransliteration: json['englishName'] as String? ?? '',
      nameTranslation: json['englishNameTranslation'] as String? ?? '',
      ayahCount: json['numberOfAyahs'] as int,
      revelationType: json['revelationType'] as String? ?? 'Meccan',
      revelationOrder: json['revelationOrder'] as int? ?? 0,
    );
  }

  Surah toDomain() {
    return Surah(
      id: id,
      nameArabic: nameArabic,
      nameTransliteration: nameTransliteration,
      nameTranslation: nameTranslation,
      ayahCount: ayahCount,
      revelationType: revelationType,
      revelationOrder: revelationOrder,
    );
  }
}