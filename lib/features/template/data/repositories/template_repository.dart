import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran_reels/features/template/domain/entities/template.dart';
import 'package:quran_reels/features/template/data/models/template_model.dart';

class TemplateRepository {
  List<Template>? _templates;

  Future<List<Template>> getAllTemplates() async {
    if (_templates != null) return _templates!;
    final jsonString = await rootBundle.loadString('assets/data/template_config.json');
    final data = json.decode(jsonString) as List;
    _templates = data.map((t) => TemplateModel.fromJson(t as Map<String, dynamic>).toDomain()).toList();
    return _templates!;
  }

  Future<Template> getTemplateById(String templateId) async {
    final templates = await getAllTemplates();
    return templates.firstWhere(
      (t) => t.id == templateId,
      orElse: () => throw StateError('Template $templateId not found'),
    );
  }
}