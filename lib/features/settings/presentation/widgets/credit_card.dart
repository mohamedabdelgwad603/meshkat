import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_card.dart';

// Card with a source title and its attribution text.
class CreditCard extends StatelessWidget {
  final String title;
  final String body;

  // Creates the card from two translation keys.
  const CreditCard({super.key, required this.title, required this.body});

  // Builds the title and body.
  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            style: getBoldStyle(context: context, fontSize: 15.sp, color: ColorsManager.secondryDark),
          ),
          verticalSpace(6.h),
          CustomText(
            text: body,
            style: getRegularStyle(context: context, fontSize: 14.sp, height: 1.8, color: ColorsManager.darkLight),
          ),
        ],
      ),
    );
  }
}
