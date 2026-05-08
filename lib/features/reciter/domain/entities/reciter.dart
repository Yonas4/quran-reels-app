class Reciter {
  final String id;
  final String name;
  final String audioBaseUrl;
  final String style;

  const Reciter({
    required this.id,
    required this.name,
    required this.audioBaseUrl,
    required this.style,
  });

  String getAudioUrl(int surahId, int numberInSurah) {
    return '$audioBaseUrl$surahId/$numberInSurah.mp3';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reciter && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}