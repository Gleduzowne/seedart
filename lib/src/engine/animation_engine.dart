import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import './headless_renderer.dart';
import './frame_capture.dart';

class AnimationEngine {
  final HeadlessRenderer renderer;
  final int fps;
  final String outputPath;

  AnimationEngine({
    required int width,
    required int height,
    this.fps = 30,
    required this.outputPath,
  }) : renderer = HeadlessRenderer(width: width, height: height);

  Future<void> renderAnimation({
    required Widget scene,
    required Duration duration,
  }) async {
    final int totalFrames = (duration.inMilliseconds / 1000 * fps).ceil();
    final String framesDir = path.join(path.dirname(outputPath), 'frames');
    
    // Create frames directory if it doesn't exist
    await Directory(framesDir).create(recursive: true);

    // Render each frame
    for (int i = 0; i < totalFrames; i++) {
      final double t = i / totalFrames;

      // Update animation state
      renderer.render(scene);

      // Capture frame
      final image = await FrameCapture.captureFrame(renderer.renderView);
      final bytes = await FrameCapture.imageToBytes(image);

      // Convert bytes to image and save
      final frameImage = img.decodePng(bytes);
      if (frameImage != null) {
        final frameFile = path.join(framesDir, 'frame_$i.png');
        File(frameFile).writeAsBytesSync(img.encodePng(frameImage));
      }

      // Report progress
      if (i % 10 == 0) {
        stdout.write('\rRendering frame $i/$totalFrames');
      }
    }
    stdout.write('\rRendering complete! $totalFrames frames generated.\n');

    // Use system FFmpeg to combine frames
    final result = await Process.run('ffmpeg', [
      '-y',  // Overwrite output file if it exists
      '-framerate',
      fps.toString(),
      '-i',
      path.join(framesDir, 'frame_%d.png'),
      '-c:v',
      'libx264',
      '-pix_fmt',
      'yuv420p',
      outputPath
    ]);

    if (result.exitCode != 0) {
      throw Exception('Failed to create video: ${result.stderr}');
    }

    // Cleanup frames directory
    await Directory(framesDir).delete(recursive: true);
  }
}
