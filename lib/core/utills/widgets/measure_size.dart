import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Reports its child's size after layout whenever that size changes.
class MeasureSize extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onChange;

  // Creates the widget around the child to measure.
  const MeasureSize({super.key, required this.onChange, required Widget super.child});

  // Creates the render object that watches the child's size.
  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);

  // Passes a new callback to the existing render object.
  @override
  void updateRenderObject(BuildContext context, MeasureSizeRenderObject renderObject) =>
      renderObject.onChange = onChange;
}

// Render box that calls back after a frame when the child's size differs from the last one reported.
class MeasureSizeRenderObject extends RenderProxyBox {
  ValueChanged<Size> onChange;
  Size? _lastSize;

  // Creates the render object with the callback.
  MeasureSizeRenderObject(this.onChange);

  // Lays out the child and reports its size once it changes.
  @override
  void performLayout() {
    super.performLayout();
    final size = child?.size ?? Size.zero;
    if (size == _lastSize) return;
    _lastSize = size;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(size));
  }
}
