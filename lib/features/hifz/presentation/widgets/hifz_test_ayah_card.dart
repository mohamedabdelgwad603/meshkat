import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/star_number_badge.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_state.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_hidden_word.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_test_actions.dart';

// One ayah of the test: shown words, blanks for hidden ones, its rating and the reveal or rate buttons.
class HifzTestAyahCard extends StatelessWidget {
  final int index;
  final HifzTestData data;

  // Creates the card for the ayah at the given index.
  const HifzTestAyahCard({super.key, required this.index, required this.data});

  // Builds the card with a border colored by the rating.
  @override
  Widget build(BuildContext context) {
    final ayah = data.session.ayahs[index];
    final words = ayah.words;
    final revealed = data.revealedWords[index];
    final result = data.results[ayah.ayahNumber];
    final borderColor = result == null ? ColorsManager.greyLight : (result ? ColorsManager.green : ColorsManager.red);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
      decoration: BoxDecoration(
        color: ColorsManager.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: result == null ? 1 : 1.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              StarNumberBadge(number: ayah.ayahNumber, size: 34),
              const Spacer(),
              if (result != null) _buildResultTag(context, result),
            ],
          ),
          verticalSpace(8.h),
          Wrap(
            textDirection: TextDirection.rtl,
            spacing: 6.w,
            runSpacing: 2.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (var i = 0; i < words.length; i++)
                i < revealed
                    ? CustomText(
                        text: words[i],
                        translate: false,
                        textDirection: TextDirection.rtl,
                        style: getRegularStyle(
                          context: context,
                          fontSize: 22.sp,
                          height: 1.9,
                          color: ColorsManager.onSurface,
                          fontFamily: FontManager.quran,
                        ),
                      )
                    : HifzHiddenWord(word: words[i]),
            ],
          ),
          verticalSpace(8.h),
          HifzTestActions(
            isFullyRevealed: data.isFullyRevealed(index),
            isRated: result != null,
            cubit: HifzTestCubit.get(context),
            index: index,
          ),
        ],
      ),
    );
  }

  // Builds the small tag showing whether the ayah was memorized or needs review.
  Widget _buildResultTag(BuildContext context, bool memorized) {
    final color = memorized ? ColorsManager.green : ColorsManager.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: memorized ? ColorsManager.primaryLight : ColorsManager.redLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(memorized ? Icons.check_circle_rounded : Icons.refresh_rounded, size: 14.r, color: color),
          horizontalSpace(4.w),
          CustomText(
            text: memorized ? TextManager.hifzMemorized : TextManager.hifzNeedsReview,
            style: getSemiBoldStyle(context: context, fontSize: 12.sp, color: color),
          ),
        ],
      ),
    );
  }
}
