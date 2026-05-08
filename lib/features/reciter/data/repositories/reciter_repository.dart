import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran_reels/features/reciter/domain/entities/reciter.dart';
import 'package:quran_reels/features/reciter/data/models/reciter_model.dart';

class ReciterRepository {
  List<Reciter>? _reciters;

  Future<List<Reciter>> getAllReciters() async {
    if (_reciters != null) return _reciters!;
    final jsonString = await rootBundle.loadString('assets/data/reciter_config.json');
    final data = json.decode(jsonString) as List;
    _reciters = data.map((r) => ReciterModel.fromJson(r as Map<String, dynamic>).toDomain()).toList();
    return _reciters!;
  }
}