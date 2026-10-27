import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';
import 'package:mishkat/features/player/presentation/cubit/player_state.dart';
import 'package:mishkat/features/player/presentation/widgets/play_pause_button.dart';

// Transport controls: loop surah, previous, play/pause, next and speed.
class PlayerControls extends StatelessWidget {
  // Creates the controls.
  const PlayerControls({super.key});

  // Builds the controls in a left-to-right media layout.
  @override
  Widget build(BuildContext context) {
    final cubit = PlayerCubit.get(context);
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        final data = state is PlayerSuccess ? state.data : PlayerData.dummy();
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundIconButton(
                icon: Icons.repeat_rounded,
                semanticLabel: TextManager.loopSurah,
                iconSize: 22,
                iconColor: data.loopSurah ? ColorsManager.secondry : ColorsManager.mutedOnDark,
                backgroundColor: data.loopSurah ? ColorsManager.goldOverlay : ColorsManager.transparent,
                onPressed: cubit.toggleLoopSurah,
              ),
              RoundIconButton(
                icon: Icons.skip_previous_rounded,
                semanticLabel: TextManager.prevAyah,
                iconColor: ColorsManager.white,
                size: 52,
                iconSize: 30,
                onPressed: cubit.previous,
              ),
              PlayPauseButton(isPlaying: data.isPlaying, isBuffering: data.isBuffering, onPressed: cubit.togglePlay),
              RoundIconButton(
                icon: Icons.skip_next_rounded,
                semanticLabel: TextManager.nextAyah,
                iconColor: ColorsManager.white,
                size: 52,
                iconSize: 30,
                onPressed: cubit.next,
              ),
              Tooltip(
                message: TextManager.speed.tr(context: context),
                child: TextButton(
                  onPressed: cubit.cycleSpeed,
                  style: TextButton.styleFrom(minimumSize: Size(44.r, 44.r), shape: const CircleBorder()),
                  child: CustomText(
                    text: '${localizedDigits(context, _formatSpeed(data.speed))}×',
                    translate: false,
                    style: getBoldStyle(context: context, fontSize: 14.sp, color: ColorsManager.secondry),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Formats the speed without trailing zeros.
  String _formatSpeed(double speed) =>
      speed == speed.roundToDouble() ? speed.toStringAsFixed(0) : speed.toString().replaceAll(RegExp(r'0+$'), '');
}
