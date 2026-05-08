import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/features/template/domain/entities/template.dart';
import 'package:quran_reels/features/template/data/repositories/template_repository.dart';
import 'package:quran_reels/shared/providers/wizard_provider.dart';
import 'package:quran_reels/core/theme/app_theme.dart';

final templateListProvider = FutureProvider<List<Template>>((ref) async {
  final repo = TemplateRepository();
  return repo.getAllTemplates();
});

class TemplateSelectionScreen extends ConsumerWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(wizardProvider);
    final templatesAsync = ref.watch(templateListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Template')),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (templates) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 9 / 16,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            final isSelected = wizardState.selectedTemplate?.id == template.id;
            return GestureDetector(
              onTap: () {
                ref.read(wizardProvider.notifier).selectTemplate(template);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: AppTheme.primaryColor, width: 3)
                      : Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        template.backgroundAssetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.image, size: 48, color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          template.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 32),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: wizardState.selectedTemplate != null
              ? () => ref.read(wizardProvider.notifier).next()
              : null,
          child: const Text('Preview'),
        ),
      ),
    );
  }
}