import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';

// Shows a centered message with an optional hint and retry button for empty and error states.
class StateMessageView extends StatelessWidget {
  final String message;
  final String? hint;
  final VoidCallback? onRetry;
  final Color textColor;

  // Creates the message view.
  const StateMessageView({
    super.key,
    required this.message,
    this.hint,
    this.onRetry,
    this.textColor = ColorsManager.onSurface,
  });

  // Builds the star, the message, the hint and the retry button.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IslamicStar(size: 56.r, color: ColorsManager.secondry, strokeWidth: 1.4),
            verticalSpace(16.h),
            CustomText(
              text: message,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(context: context, fontSize: 15.sp, color: textColor),
            ),
            if (hint != null) ...[
              verticalSpace(6.h),
              CustomText(
                text: hint!,
                textAlign: TextAlign.center,
                style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.grey, height: 1.6),
              ),
            ],
            if (onRetry != null) ...[
              verticalSpace(16.h),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: ColorsManager.primary,
                  minimumSize: Size(140.w, 44.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
                ),
                child: CustomText(
                  text: TextManager.retry,
                  style: getSemiBoldStyle(context: context, color: ColorsManager.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
