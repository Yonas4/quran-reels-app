import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_reels/features/reciter/domain/entities/reciter.dart';
import 'package:quran_reels/features/reciter/data/repositories/reciter_repository.dart';
import 'package:quran_reels/shared/providers/wizard_provider.dart';
import 'package:quran_reels/core/theme/app_theme.dart';

final reciterListProvider = FutureProvider<List<Reciter>>((ref) async {
  final repo = ReciterRepository();
  return repo.getAllReciters();
});

class ReciterSelectionScreen extends ConsumerWidget {
  const ReciterSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(wizardProvider);
    final recitersAsync = ref.watch(reciterListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Reciter')),
      body: recitersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (reciters) => ListView.builder(
          itemCount: reciters.length,
          itemBuilder: (context, index) {
            final reciter = reciters[index];
            final isSelected = wizardState.selectedReciter?.id == reciter.id;
            return ListTile(
              selected: isSelected,
              selectedTileColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              title: Text(reciter.name),
              subtitle: Text(reciter.style),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                  : const SizedBox.shrink(),
              onTap: () {
                ref.read(wizardProvider.notifier).selectReciter(reciter);
                ref.read(wizardProvider.notifier).next();
              },
            );
          },
        ),
      ),
    );
  }
}