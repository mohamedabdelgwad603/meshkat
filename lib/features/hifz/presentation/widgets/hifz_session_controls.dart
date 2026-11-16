import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_state.dart';
import 'package:mishkat/features/player/presentation/widgets/play_pause_button.dart';

// Restart, previous ayah, play or pause and next ayah buttons.
class HifzSessionControls extends StatelessWidget {
  final HifzSessionData data;

  // Creates the controls for the given session data.
  const HifzSessionControls({super.key, required this.data});

  // Builds the row of buttons, disabling next on the last ayah.
  @override
  Widget build(BuildContext context) {
    final cubit = HifzSessionCubit.get(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RoundIconButton(
          icon: Icons.replay_rounded,
          semanticLabel: TextManager.hifzRestart,
          iconColor: ColorsManager.mutedOnDark,
          onPressed: cubit.restart,
        ),
        RoundIconButton(
          icon: Icons.skip_previous_rounded,
          semanticLabel: TextManager.hifzPrevious,
          iconColor: ColorsManager.white,
          size: 52,
          iconSize: 30,
          onPressed: cubit.previous,
        ),
        PlayPauseButton(isPlaying: data.isPlaying, isBuffering: data.isBuffering, onPressed: cubit.togglePlay),
        RoundIconButton(
          icon: Icons.skip_next_rounded,
          semanticLabel: TextManager.hifzNext,
          iconColor: data.isLastAyah ? ColorsManager.darkLight : ColorsManager.white,
          size: 52,
          iconSize: 30,
          onPressed: data.isLastAyah ? null : cubit.next,
        ),
        SizedBox(width: 44.r),
      ],
    );
  }
}
