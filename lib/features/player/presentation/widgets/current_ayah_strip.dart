import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';
import 'package:mishkat/features/player/presentation/cubit/player_state.dart';

// Translucent strip showing the ayah being recited and its position.
class CurrentAyahStrip extends StatelessWidget {
  // Creates the strip.
  const CurrentAyahStrip({super.key});

  // Builds the strip from the current ayah index.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      buildWhen: (a, b) =>
          b is PlayerSuccess && (a is! PlayerSuccess || a.data.currentIndex != b.data.currentIndex || a.data.surah != b.data.surah),
      builder: (context, state) {
        final data = state is PlayerSuccess ? state.data : PlayerData.dummy();
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: 150.h),
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          decoration: BoxDecoration(
            color: ColorsManager.whiteOverlay,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: ColorsManager.whiteBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: CustomText(
                      key: ValueKey(data.currentIndex),
                      text: data.currentAyah.text,
                      translate: false,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: getRegularStyle(
                        context: context,
                        fontSize: 21.sp,
                        height: 2,
                        color: ColorsManager.white,
                        fontFamily: FontManager.quran,
                      ),
                    ),
                  ),
                ),
              ),
              CustomText(
                text: TextManager.ayahOf,
                args: [localizedDigits(context, data.currentIndex + 1), localizedDigits(context, data.totalAyahs)],
                style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.mutedOnDark),
              ),
            ],
          ),
        );
      },
    );
  }
}
