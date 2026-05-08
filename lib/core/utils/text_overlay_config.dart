class TextOverlayConfig {
  final double x;
  final double y;
  final double maxWidth;
  final double fontSize;
  final String fontColor;
  final String fontFamily;
  final String textAlign;

  const TextOverlayConfig({
    required this.x,
    required this.y,
    required this.maxWidth,
    required this.fontSize,
    this.fontColor = '#FFFFFF',
    this.fontFamily = 'ScheherazadeNew',
    this.textAlign = 'center',
  });

  factory TextOverlayConfig.fromJson(Map<String, dynamic> json) {
    return TextOverlayConfig(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      maxWidth: (json['maxWidth'] as num).toDouble(),
      fontSize: (json['fontSize'] as num).toDouble(),
      fontColor: json['fontColor'] as String? ?? '#FFFFFF',
      fontFamily: json['fontFamily'] as String? ?? 'ScheherazadeNew',
      textAlign: json['textAlign'] as String? ?? 'center',
    );
  }
}