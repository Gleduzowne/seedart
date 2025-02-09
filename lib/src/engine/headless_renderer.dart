import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HeadlessRenderer {
  final int width;
  final int height;
  final RenderView renderView;
  final PipelineOwner pipelineOwner;

  HeadlessRenderer({
    required this.width,
    required this.height,
  })  : pipelineOwner = PipelineOwner(),
        renderView = RenderView(
          configuration: ViewConfiguration(
            size: Size(width.toDouble(), height.toDouble()),
            devicePixelRatio: 1.0,
          ),
          window: WidgetsBinding.instance.window,
        ) {
    pipelineOwner.rootNode = renderView;
  }

  void render(Widget scene) {
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    final RenderObjectToWidgetElement<RenderBox> element =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: renderView,
      child: scene,
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(element);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();
  }
}
