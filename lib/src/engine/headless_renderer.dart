import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HeadlessRenderer {
  final int width;
  final int height;
  final RenderView renderView;
  final PipelineOwner pipelineOwner;
  BuildOwner? _buildOwner;
  RenderObjectToWidgetElement<RenderBox>? _element;

  HeadlessRenderer({
    required this.width,
    required this.height,
  })  : pipelineOwner = PipelineOwner(),
        renderView = RenderView(
          configuration: ViewConfiguration(
            size: Size(width.toDouble(), height.toDouble()),
            devicePixelRatio: 1.0,
          ),
          view: ui.SingletonFlutterWindow(
            platformDispatcher: ui.PlatformDispatcher.instance,
          ),
        ) {
    _buildOwner = BuildOwner(focusManager: FocusManager());
    pipelineOwner.rootNode = renderView;
  }

  void render(Widget scene) {
    _element = RenderObjectToWidgetAdapter<RenderBox>(
      container: renderView,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: scene,
      ),
    ).attachToRenderTree(_buildOwner!);

    _buildOwner!.buildScope(_element!);
    _buildOwner!.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();
  }

  void dispose() {
    _element = null;
    _buildOwner = null;
  }
}
