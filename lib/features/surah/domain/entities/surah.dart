class Surah {
  final int id;
  final String nameArabic;
  final String nameTransliteration;
  final String nameTranslation;
  final int ayahCount;
  final String revelationType;
  final int revelationOrder;

  const Surah({
    required this.id,
    required this.nameArabic,
    required this.nameTransliteration,
    required this.nameTranslation,
    required this.ayahCount,
    required this.revelationType,
    required this.revelationOrder,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Surah && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}