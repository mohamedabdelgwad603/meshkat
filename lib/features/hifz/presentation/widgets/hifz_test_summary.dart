import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_state.dart';

// Bottom bar with the running score and a button to start the test over.
class HifzTestSummary extends StatelessWidget {
  final HifzTestData data;

  // Creates the bar for the given test data.
  const HifzTestSummary({super.key, required this.data});

  // Builds the score, its progress bar and the restart button.
  @override
  Widget build(BuildContext context) {
    final total = data.session.ayahs.length;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
      decoration: BoxDecoration(
        color: ColorsManager.surface,
        boxShadow: [BoxShadow(color: ColorsManager.shadow, blurRadius: 20.r, offset: Offset(0, -6.h))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: TextManager.hifzScore,
                  args: [localizedDigits(context, data.memorizedCount), localizedDigits(context, total)],
                  style: getBoldStyle(context: context, fontSize: 15.sp, color: ColorsManager.primary),
                ),
                verticalSpace(6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : data.memorizedCount / total,
                    minHeight: 6.h,
                    color: ColorsManager.green,
                    backgroundColor: ColorsManager.track,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(12.w),
          OutlinedButton.icon(
            onPressed: data.ratedCount == 0 ? null : HifzTestCubit.get(context).restart,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(0, 44.h),
              shape: const StadiumBorder(),
              side: const BorderSide(color: ColorsManager.primary),
            ),
            icon: Icon(Icons.replay_rounded, size: 18.r, color: ColorsManager.primary),
            label: CustomText(
              text: TextManager.hifzTestAgain,
              style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.primary),
            ),
          ),
        ],
      ),
    );
  }
}
