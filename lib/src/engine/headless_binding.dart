import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class HeadlessFlutterBinding {
  static void ensureInitialized() {}
}

class _HeadlessFlutterBindingImpl extends BindingBase
    with
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        SemanticsBinding,
        GestureBinding,
        RendererBinding
    implements HeadlessFlutterBinding {
  _HeadlessFlutterBindingImpl._() {
    // Initialize services that don't require a window
    initInstances();
    // Disable unnecessary services
    ServicesBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(null, null);
  }

  @override
  void handleDrawFrame() {}
}

extension on BinaryMessenger {
  void setMockMessageHandler(param0, param1) {}
}
