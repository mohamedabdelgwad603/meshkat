import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/app_logo.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/settings/presentation/widgets/credit_card.dart';
import 'package:mishkat/features/settings/presentation/widgets/credits_version_text.dart';

// Logo header followed by one card per content source.
class CreditsBody extends StatelessWidget {
  // Creates the body.
  const CreditsBody({super.key});

  // Builds the scrollable credits page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: RoundIconButton(
                icon: Icons.arrow_back_rounded,
                semanticLabel: TextManager.backAction,
                onPressed: () => context.pop(),
              ),
            ),
            verticalSpace(8.h),
            Center(child: AppLogo(size: 72.r)),
            verticalSpace(8.h),
            CustomText(
              text: TextManager.sourcesTitle,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                context: context,
                fontSize: 24.sp,
                color: ColorsManager.primary,
                fontFamily: FontManager.heading,
              ),
            ),
            verticalSpace(4.h),
            CustomText(
              text: TextManager.appTagline,
              textAlign: TextAlign.center,
              style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.grey),
            ),
            verticalSpace(20.h),
            const CreditCard(title: TextManager.creditsQuranTitle, body: TextManager.creditsQuranBody),
            verticalSpace(12.h),
            const CreditCard(title: TextManager.creditsTafsirTitle, body: TextManager.creditsTafsirBody),
            verticalSpace(12.h),
            const CreditCard(title: TextManager.creditsAudioTitle, body: TextManager.creditsAudioBody),
            verticalSpace(12.h),
            const CreditCard(title: TextManager.creditsFontsTitle, body: TextManager.creditsFontsBody),
            verticalSpace(20.h),
            const CreditsVersionText(),
          ],
        ),
      ),
    );
  }
}
