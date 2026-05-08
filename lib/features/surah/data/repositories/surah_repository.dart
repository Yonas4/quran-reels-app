import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran_reels/features/surah/domain/entities/surah.dart';
import 'package:quran_reels/features/surah/domain/entities/ayah.dart';
import 'package:quran_reels/features/surah/data/models/surah_model.dart';
import 'package:quran_reels/features/surah/data/models/ayah_model.dart';

class SurahRepository {
  List<Surah>? _surahs;
  Map<int, List<Ayah>>? _ayahsBySurah;

  Future<List<Surah>> getAllSurahs() async {
    if (_surahs != null) return _surahs!;
    final data = await _loadQuranData();
    _surahs = data.map((s) => SurahModel.fromJson(s).toDomain()).toList();
    return _surahs!;
  }

  Future<Surah> getSurahById(int surahId) async {
    final surahs = await getAllSurahs();
    return surahs.firstWhere(
      (s) => s.id == surahId,
      orElse: () => throw StateError('Surah $surahId not found'),
    );
  }

  Future<List<Ayah>> getAyahsBySurah(int surahId) async {
    if (_ayahsBySurah != null && _ayahsBySurah!.containsKey(surahId)) {
      return _ayahsBySurah![surahId]!;
    }
    final data = await _loadQuranData();
    final surahData = data.firstWhere(
      (s) => s['number'] == surahId,
      orElse: () => throw StateError('Surah $surahId not found'),
    );
    final ayahs = (surahData['ayahs'] as List)
        .map((a) => AyahModel.fromJson(a as Map<String, dynamic>, surahIdOverride: surahId).toDomain())
        .toList();
    _ayahsBySurah ??= {};
    _ayahsBySurah![surahId] = ayahs;
    return ayahs;
  }

  Future<Ayah> getAyahById(int ayahId) async {
    final data = await _loadQuranData();
    for (final surahData in data) {
      final surahId = surahData['number'] as int;
      for (final ayahData in surahData['ayahs'] as List) {
        if (ayahData['number'] == ayahId) {
          return AyahModel.fromJson(ayahData as Map<String, dynamic>, surahIdOverride: surahId).toDomain();
        }
      }
    }
    throw StateError('Ayah $ayahId not found');
  }

  Future<List<Map<String, dynamic>>> _loadQuranData() async {
    final jsonString = await rootBundle.loadString('assets/data/quran_uthmani.json');
    return (json.decode(jsonString) as List).cast<Map<String, dynamic>>();
  }
}