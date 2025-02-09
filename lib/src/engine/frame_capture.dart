import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class FrameCapture {
  static Future<ui.Image> captureFrame(RenderObject renderObject) async {
    final layer = renderObject.debugLayer as OffsetLayer?;
    if (layer == null) {
      throw Exception('Unable to capture frame: No layer found');
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final image = await layer.toImage(renderObject.paintBounds);

    return image;
  }

  static Future<List<int>> imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List() ?? [];
  }
}
