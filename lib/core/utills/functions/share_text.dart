import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

// Opens the system share sheet anchored to the tapped widget so it also works on iPad.
Future<void> shareText(BuildContext context, String text) {
  return SharePlus.instance.share(ShareParams(text: text, sharePositionOrigin: _originOf(context)));
}

// Returns the on-screen rect of the given widget, or a small rect at the screen center as a fallback.
Rect _originOf(BuildContext context) {
  final box = context.findRenderObject();
  if (box is RenderBox && box.hasSize && box.size != Size.zero) {
    return box.localToGlobal(Offset.zero) & box.size;
  }
  final screen = MediaQuery.sizeOf(context);
  return Rect.fromCenter(center: screen.center(Offset.zero), width: 1, height: 1);
}
