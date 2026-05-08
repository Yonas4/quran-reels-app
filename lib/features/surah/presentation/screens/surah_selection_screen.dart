import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/features/surah/domain/entities/surah.dart';
import 'package:quran_reels/features/surah/data/repositories/surah_repository.dart';
import 'package:quran_reels/shared/providers/wizard_provider.dart';

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final repo = SurahRepository();
  return repo.getAllSurahs();
});

class SurahSelectionScreen extends ConsumerStatefulWidget {
  const SurahSelectionScreen({super.key});

  @override
  ConsumerState<SurahSelectionScreen> createState() => _SurahSelectionScreenState();
}

class _SurahSelectionScreenState extends ConsumerState<SurahSelectionScreen> {
  final _searchController = TextEditingController();
  List<Surah> _filteredSurahs = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSurahs(List<Surah> surahs, String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = surahs;
      } else {
        _filteredSurahs = surahs.where((s) {
          final lowerQuery = query.toLowerCase();
          return s.nameArabic.contains(query) ||
              s.nameTransliteration.toLowerCase().contains(lowerQuery) ||
              s.nameTranslation.toLowerCase().contains(lowerQuery) ||
              s.id.toString() == query;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Surah')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Surah...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (query) {
                surahsAsync.whenData((surahs) => _filterSurahs(surahs, query));
              },
            ),
          ),
          Expanded(
            child: surahsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (surahs) {
                if (_filteredSurahs.isEmpty && _searchController.text.isEmpty) {
                  _filteredSurahs = surahs;
                }
                return _filteredSurahs.isEmpty && surahs.isNotEmpty
                    ? _filteredSurahs.isEmpty
                        ? const Center(child: Text('No Surahs found'))
                        : const SizedBox.shrink()
                    : ListView.builder(
                        itemCount: _filteredSurahs.isEmpty ? surahs.length : _filteredSurahs.length,
                        itemBuilder: (context, index) {
                          final surahsList = _filteredSurahs.isEmpty ? surahs : _filteredSurahs;
                          final surah = surahsList[index];
                          return ListTile(
                            title: Text(
                              surah.nameArabic,
                              style: const TextStyle(fontFamily: 'ScheherazadeNew', fontSize: 20),
                            ),
                            subtitle: Text('${surah.id}. ${surah.nameTransliteration} - ${surah.nameTranslation}'),
                            trailing: Text('${surah.ayahCount} Ayahs'),
                            onTap: () {
                              ref.read(wizardProvider.notifier).selectSurah(surah);
                              ref.read(wizardProvider.notifier).next();
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}