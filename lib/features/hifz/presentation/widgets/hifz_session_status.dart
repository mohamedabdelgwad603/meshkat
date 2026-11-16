import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_state.dart';

// Position in the range, the current repetition and a bar of overall progress.
class HifzSessionStatus extends StatelessWidget {
  final HifzSessionData data;

  // Creates the status for the given session data.
  const HifzSessionStatus({super.key, required this.data});

  // Builds the two labels and the progress bar.
  @override
  Widget build(BuildContext context) {
    final total = data.session.ayahs.length;
    final isReview = data.stage == HifzStage.rangeReview;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(
                text: TextManager.hifzAyahOf,
                args: [localizedDigits(context, data.currentIndex + 1), localizedDigits(context, total)],
                style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.white),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isReview ? ColorsManager.secondry : ColorsManager.whiteOverlay,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                text: isReview ? TextManager.hifzReviewOf : TextManager.hifzRepetitionOf,
                args: [localizedDigits(context, data.repetition), localizedDigits(context, data.stageRepetitions)],
                style: getSemiBoldStyle(
                  context: context,
                  fontSize: 12.sp,
                  color: isReview ? ColorsManager.primary : ColorsManager.secondry,
                ),
              ),
            ),
          ],
        ),
        verticalSpace(10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 5.h,
            color: ColorsManager.secondry,
            backgroundColor: ColorsManager.primaryMiddle,
          ),
        ),
      ],
    );
  }

  // Returns the share of the whole session already played, across both stages.
  double get _progress {
    final ayahs = data.session.ayahs.length;
    final settings = data.settings;
    final hasReview = settings.rangeRepeat > 0 && ayahs > 1;
    final total = ayahs * settings.ayahRepeat + (hasReview ? ayahs * settings.rangeRepeat : 0);
    final done = data.stage == HifzStage.rangeReview
        ? ayahs * settings.ayahRepeat + (data.repetition - 1) * ayahs + data.currentIndex
        : data.currentIndex * settings.ayahRepeat + data.repetition - 1;
    return total == 0 ? 0 : (done / total).clamp(0, 1).toDouble();
  }
}
