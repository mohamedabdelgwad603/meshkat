import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/star_number_badge.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_state.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_recite_pill.dart';

// Card with the current ayah in the mushaf font and what the user should do now.
class HifzSessionAyahCard extends StatelessWidget {
  final HifzSessionData data;

  // Creates the card for the given session data.
  const HifzSessionAyahCard({super.key, required this.data});

  // Builds the ayah number, the text and the listen or recite pill, fading between ayahs.
  @override
  Widget build(BuildContext context) {
    final ayah = data.session.ayahs[data.currentIndex];
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.surface,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: data.isRecitePause ? ColorsManager.secondry : ColorsManager.transparent,
          width: 2,
        ),
      ),
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      child: Column(
        children: [
          StarNumberBadge(number: ayah.ayahNumber, size: 40),
          verticalSpace(12.h),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: CustomText(
                    key: ValueKey(ayah.ayahNumber),
                    text: ayah.text,
                    translate: false,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: getRegularStyle(
                      context: context,
                      fontSize: 26.sp,
                      height: 2,
                      color: ColorsManager.onSurface,
                      fontFamily: FontManager.quran,
                    ),
                  ),
                ),
              ),
            ),
          ),
          verticalSpace(12.h),
          HifzRecitePill(isRecitePause: data.isRecitePause, isPlaying: data.isPlaying),
        ],
      ),
    );
  }
}
