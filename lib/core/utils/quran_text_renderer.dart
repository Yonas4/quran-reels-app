import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:quran_reels/core/utils/text_overlay_config.dart';

class QuranTextRenderer {
  Future<Uint8List> renderQuranText(
    String text,
    TextOverlayConfig config, {
    int canvasWidth = 1080,
    int canvasHeight = 1920,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble()));

    final paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: _parseTextAlign(config.textAlign),
        textDirection: ui.TextDirection.rtl,
        fontSize: config.fontSize,
        fontFamily: config.fontFamily,
        maxLines: 10,
      ),
    )
      ..pushStyle(ui.TextStyle(
        color: _parseColor(config.fontColor),
      ))
      ..addText(text);

    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: canvasWidth * config.maxWidth));

    final xOffset = (canvasWidth - paragraph.minIntrinsicWidth) / 2;
    final yOffset = canvasHeight * config.y - paragraph.height / 2;

    canvas.drawParagraph(paragraph, ui.Offset(xOffset, yOffset));

    final picture = recorder.endRecording();
    final image = await picture.toImage(canvasWidth, canvasHeight);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw AppStateException('Failed to render Quran text to image');
    }

    return byteData.buffer.asUint8List();
  }

  ui.TextAlign _parseTextAlign(String align) {
    switch (align) {
      case 'center':
        return ui.TextAlign.center;
      case 'right':
        return ui.TextAlign.right;
      case 'left':
        return ui.TextAlign.left;
      default:
        return ui.TextAlign.center;
    }
  }

  ui.Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return ui.Color(int.parse('FF$hex', radix: 16));
  }
}

class AppStateException implements Exception {
  final String message;
  AppStateException(this.message);
  @override
  String toString() => 'StateException: $message';
}