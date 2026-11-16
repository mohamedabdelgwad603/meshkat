import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_setup_selector.dart';

// Shows how many ayahs of the chosen range the user marked as memorized.
class HifzProgressBanner extends StatelessWidget {
  // Creates the banner.
  const HifzProgressBanner({super.key});

  // Builds the count and a progress bar.
  @override
  Widget build(BuildContext context) {
    return HifzSetupSelector(
      builder: (context, data) {
        final done = data.memorizedInRange;
        final total = data.rangeLength;
        return Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: ColorsManager.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(color: ColorsManager.whiteOverlay, shape: BoxShape.circle),
                child: Icon(
                  done == total ? Icons.workspace_premium_rounded : Icons.auto_graph_rounded,
                  size: 22.r,
                  color: ColorsManager.secondry,
                ),
              ),
              horizontalSpace(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomText(
                      text: TextManager.hifzProgress,
                      args: [localizedDigits(context, done), localizedDigits(context, total)],
                      style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.white),
                    ),
                    verticalSpace(8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : done / total,
                        minHeight: 6.h,
                        color: ColorsManager.secondry,
                        backgroundColor: ColorsManager.primaryMiddle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
