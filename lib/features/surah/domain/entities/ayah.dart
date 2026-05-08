class Ayah {
  final int id;
  final int surahId;
  final int numberInSurah;
  final String textUthmani;
  final int juz;
  final int page;

  const Ayah({
    required this.id,
    required this.surahId,
    required this.numberInSurah,
    required this.textUthmani,
    required this.juz,
    required this.page,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ayah && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}