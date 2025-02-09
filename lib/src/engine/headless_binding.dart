import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class HeadlessFlutterBinding extends BindingBase
    with
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        GestureBinding,
        RendererBinding {
  static HeadlessFlutterBinding? _instance;

  static HeadlessFlutterBinding ensureInitialized() {
    if (kIsWeb) {
      throw UnsupportedError(
          'Headless Flutter is not supported on web platforms');
    }
    return _instance ??= HeadlessFlutterBinding._();
  }

  HeadlessFlutterBinding._() {
    // Initialize services that don't require a window
    initInstances();
    // Disable unnecessary services
    ServicesBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(null, null);
  }

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  @override
  void handleBeginFrame(Duration? rawTimeStamp) {}

  @override
  void handleDrawFrame() {}
}
