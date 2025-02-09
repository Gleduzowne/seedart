import 'dart:io';
import 'package:flutter/widgets.dart';
import 'dart:isolate';

class AnimationScript {
  static Future<Widget> loadScript(String scriptPath,
      Map<String, dynamic> params, double animationProgress) async {
    // Load the script in an isolate to avoid blocking the main thread
    final uri = Uri.file(scriptPath);
    final isolate = await Isolate.spawnUri(
      uri,
      [animationProgress.toString()],
      params,
    );

    // Create a port to receive the widget
    final receivePort = ReceivePort();
    isolate.addOnExitListener(receivePort.sendPort);

    // Wait for the widget
    final result = await receivePort.first;
    if (result is Widget) {
      return result;
    }

    throw Exception('Script did not return a valid Widget');
  }
}
