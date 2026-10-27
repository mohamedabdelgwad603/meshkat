import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';

// Seek slider with elapsed and total time of the current ayah.
class PlayerProgress extends StatelessWidget {
  // Creates the progress control.
  const PlayerProgress({super.key});

  // Builds the slider from the live position and duration streams.
  @override
  Widget build(BuildContext context) {
    final cubit = PlayerCubit.get(context);
    return StreamBuilder<Duration?>(
      stream: cubit.durationStream,
      builder: (context, durationSnap) {
        final total = durationSnap.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: cubit.positionStream,
          builder: (context, positionSnap) {
            final position = positionSnap.data ?? Duration.zero;
            final max = total.inMilliseconds.toDouble();
            final value = position.inMilliseconds.clamp(0, total.inMilliseconds).toDouble();
            final timeStyle = getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.mutedOnDark);
            return Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3.h,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
                  ),
                  child: Slider(
                    value: max <= 0 ? 0 : value,
                    max: max <= 0 ? 1 : max,
                    activeColor: ColorsManager.secondry,
                    inactiveColor: ColorsManager.whiteBorder,
                    onChanged: max <= 0 ? null : (v) => cubit.seekTo(Duration(milliseconds: v.round())),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: localizedDigits(context, _format(position)), translate: false, style: timeStyle),
                      CustomText(text: localizedDigits(context, _format(total)), translate: false, style: timeStyle),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Formats a duration as m:ss.
  String _format(Duration d) => '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
}
