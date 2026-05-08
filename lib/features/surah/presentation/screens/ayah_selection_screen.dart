import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/features/surah/domain/entities/ayah.dart';
import 'package:quran_reels/features/surah/data/repositories/surah_repository.dart';
import 'package:quran_reels/shared/providers/wizard_provider.dart';
import 'package:quran_reels/core/theme/app_theme.dart';

final ayahListProvider = FutureProvider.family<List<Ayah>, int>((ref, surahId) async {
  final repo = SurahRepository();
  return repo.getAyahsBySurah(surahId);
});

class AyahSelectionScreen extends ConsumerWidget {
  const AyahSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(wizardProvider);
    final selectedSurah = wizardState.selectedSurah;

    if (selectedSurah == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Ayah')),
        body: const Center(child: Text('Please select a Surah first')),
      );
    }

    final ayahsAsync = ref.watch(ayahListProvider(selectedSurah.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Ayahs - ${selectedSurah.nameArabic}'),
      ),
      body: ayahsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (ayahs) => ListView.builder(
          itemCount: ayahs.length,
          itemBuilder: (context, index) {
            final ayah = ayahs[index];
            final isSelected = wizardState.selectedAyah?.id == ayah.id;
            return ListTile(
              selected: isSelected,
              selectedTileColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              title: Text(
                ayah.textUthmani,
                style: const TextStyle(
                  fontFamily: 'ScheherazadeNew',
                  fontSize: 18,
                ),
                textDirection: TextDirection.rtl,
              ),
              subtitle: Text('Ayah ${ayah.numberInSurah} | Juz ${ayah.juz}'),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                  : null,
              onTap: () {
                ref.read(wizardProvider.notifier).selectAyah(ayah);
                ref.read(wizardProvider.notifier).next();
              },
            );
          },
        ),
      ),
    );
  }
}