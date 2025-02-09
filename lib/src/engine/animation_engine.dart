import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
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

    // Render each frame
    for (int i = 0; i < totalFrames; i++) {
      final double t = i / totalFrames;

      // Update animation state
      renderer.render(scene);

      // Capture frame
      final image = await FrameCapture.captureFrame(renderer.renderView);
      final bytes = await FrameCapture.imageToBytes(image);

      // Save frame
      final frameFile = path.join(framesDir, 'frame_$i.png');
      // TODO: Save bytes to frameFile
    }

    // Combine frames into video using ffmpeg
    await FFmpegKit.execute(
        '-framerate $fps -i $framesDir/frame_%d.png -c:v libx264 -pix_fmt yuv420p $outputPath');
  }
}
