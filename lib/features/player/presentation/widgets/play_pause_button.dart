import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/text_manager.dart';

// Large gold circle that toggles playback and shows a spinner while buffering.
class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPressed;

  // Creates the button.
  const PlayPauseButton({super.key, required this.isPlaying, required this.isBuffering, required this.onPressed});

  // Builds the circle with the matching icon.
  @override
  Widget build(BuildContext context) {
    final label = (isPlaying ? TextManager.pauseAction : TextManager.playAction).tr(context: context);
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: ColorsManager.secondry,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: ColorsManager.primaryMiddle,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: 76.r,
            child: Center(
              child: isBuffering && !isPlaying
                  ? SizedBox.square(
                      dimension: 28.r,
                      child: const CircularProgressIndicator(strokeWidth: 3, color: ColorsManager.primary),
                    )
                  : Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 38.r,
                      color: ColorsManager.primary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
