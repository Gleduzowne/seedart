import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class FrameCapture {
  static Future<ui.Image> captureFrame(RenderObject renderObject) async {
    final layer = renderObject.debugLayer as OffsetLayer?;
    if (layer == null) {
      throw Exception('Unable to capture frame: No layer found');
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    layer.paint(canvas);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      renderObject.paintBounds.width.ceil(),
      renderObject.paintBounds.height.ceil(),
    );

    return image;
  }

  static Future<List<int>> imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List() ?? [];
  }
}
