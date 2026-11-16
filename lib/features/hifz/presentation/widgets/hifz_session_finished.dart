import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_cubit.dart';

// End of the session: congratulations, a button to test yourself and one to repeat the session.
class HifzSessionFinished extends StatelessWidget {
  final HifzSessionParams params;

  // Creates the view for the finished range.
  const HifzSessionFinished({super.key, required this.params});

  // Builds the badge, the message and the two actions.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 88.r,
                height: 88.r,
                decoration: const BoxDecoration(color: ColorsManager.secondry, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded, size: 48.r, color: ColorsManager.primary),
              ),
            ),
            verticalSpace(20.h),
            CustomText(
              text: TextManager.hifzFinishedTitle,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                context: context,
                fontSize: 22.sp,
                color: ColorsManager.white,
                fontFamily: FontManager.heading,
              ),
            ),
            verticalSpace(8.h),
            CustomText(
              text: TextManager.hifzFinishedBody,
              textAlign: TextAlign.center,
              style: getRegularStyle(context: context, fontSize: 14.sp, color: ColorsManager.mutedOnDark, height: 1.6),
            ),
            verticalSpace(28.h),
            FilledButton(
              onPressed: () => context.pushReplacementNamed(PageName.hifzTest, arguments: params),
              style: FilledButton.styleFrom(
                backgroundColor: ColorsManager.secondry,
                minimumSize: Size(0, 52.h),
                shape: const StadiumBorder(),
              ),
              child: CustomText(
                text: TextManager.hifzTest,
                style: getBoldStyle(context: context, fontSize: 15.sp, color: ColorsManager.primary),
              ),
            ),
            verticalSpace(8.h),
            TextButton(
              onPressed: HifzSessionCubit.get(context).restart,
              style: TextButton.styleFrom(minimumSize: Size(0, 48.h), shape: const StadiumBorder()),
              child: CustomText(
                text: TextManager.hifzRestart,
                style: getSemiBoldStyle(context: context, color: ColorsManager.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
