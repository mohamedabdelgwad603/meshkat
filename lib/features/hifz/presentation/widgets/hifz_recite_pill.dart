import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Pill telling the user to listen, to recite now (gently pulsing) or that the session is paused.
class HifzRecitePill extends StatefulWidget {
  final bool isRecitePause;
  final bool isPlaying;

  // Creates the pill.
  const HifzRecitePill({super.key, required this.isRecitePause, required this.isPlaying});

  // Creates the pill state.
  @override
  State<HifzRecitePill> createState() => _HifzRecitePillState();
}

// Runs the pulse only while the user is asked to recite.
class _HifzRecitePillState extends State<HifzRecitePill> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.6,
  );

  // Starts the pulse when the pill opens in recite mode.
  @override
  void initState() {
    super.initState();
    _syncPulse();
  }

  // Starts or stops the pulse when the mode changes.
  @override
  void didUpdateWidget(HifzRecitePill oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  // Releases the animation controller.
  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  // Pulses only while reciting and playing, otherwise rests at full opacity.
  void _syncPulse() {
    if (widget.isRecitePause && widget.isPlaying) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 1;
    }
  }

  // Builds the icon and the instruction.
  @override
  Widget build(BuildContext context) {
    final recite = widget.isRecitePause;
    final paused = !widget.isPlaying;
    final background = paused ? ColorsManager.track : (recite ? ColorsManager.secondry : ColorsManager.primaryLight);
    final foreground = paused ? ColorsManager.grey : ColorsManager.primary;
    final icon = paused ? Icons.pause_rounded : (recite ? Icons.mic_none_rounded : Icons.headphones_rounded);
    final label = paused ? TextManager.hifzPaused : (recite ? TextManager.hifzReciteNow : TextManager.hifzListen);
    return FadeTransition(
      opacity: _pulse,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.r, color: foreground),
            horizontalSpace(6.w),
            CustomText(text: label, style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: foreground)),
          ],
        ),
      ),
    );
  }
}
