import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';
import 'package:mishkat/features/player/presentation/cubit/player_state.dart';

// Three option pills: ayah repeat count, sleep timer and surah download.
class PlayerOptionsRow extends StatelessWidget {
  // Creates the row.
  const PlayerOptionsRow({super.key});

  // Builds the three pills from the player state.
  @override
  Widget build(BuildContext context) {
    final cubit = PlayerCubit.get(context);
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        final data = state is PlayerSuccess ? state.data : PlayerData.dummy();
        return Row(
          children: [
            _OptionPill(
              label: data.repeatTimes == 1 ? TextManager.repeatOff : TextManager.repeatTimes,
              args: [localizedDigits(context, data.repeatTimes)],
              active: data.repeatTimes > 1,
              onTap: cubit.cycleRepeat,
            ),
            horizontalSpace(8.w),
            _OptionPill(
              label: data.sleepMinutes == 0 ? TextManager.sleepTimer : TextManager.sleepIn,
              args: [localizedDigits(context, data.sleepMinutes)],
              active: data.sleepMinutes > 0,
              onTap: cubit.cycleSleepTimer,
            ),
            horizontalSpace(8.w),
            _OptionPill(
              label: data.isDownloading
                  ? TextManager.downloading
                  : (data.isDownloaded ? TextManager.downloaded : TextManager.downloadSurah),
              args: [localizedDigits(context, ((data.downloadProgress ?? 0) * 100).round())],
              active: data.isDownloaded,
              progress: data.downloadProgress,
              onTap: cubit.downloadSurah,
            ),
          ],
        );
      },
    );
  }
}

// One translucent option pill, highlighted when active and filled while downloading.
class _OptionPill extends StatelessWidget {
  final String label;
  final List<String> args;
  final bool active;
  final double? progress;
  final VoidCallback onTap;

  // Creates the pill from a translation key and its arguments.
  const _OptionPill({required this.label, required this.args, required this.active, required this.onTap, this.progress});

  // Builds the pill.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: active ? ColorsManager.goldOverlay : ColorsManager.whiteOverlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(color: active ? ColorsManager.goldBorder : ColorsManager.whiteBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              if (progress != null)
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: progress!.clamp(0, 1).toDouble(),
                    child: const ColoredBox(color: ColorsManager.goldOverlay),
                  ),
                ),
              SizedBox(
                height: 44.h,
                child: Center(
                  child: CustomText(
                    text: label,
                    args: args,
                    maxLines: 1,
                    style: getMediumStyle(
                      context: context,
                      fontSize: 12.sp,
                      color: active ? ColorsManager.secondry : ColorsManager.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
