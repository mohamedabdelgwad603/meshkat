import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';

// Back button and title at the top of the mutashabihat screens.
class MutashabihatTopBar extends StatelessWidget {
  final String title;

  // Creates the bar with the given title key.
  const MutashabihatTopBar({super.key, required this.title});

  // Builds the back button and the title.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 20.w, 4.h),
      child: Row(
        children: [
          RoundIconButton(
            icon: Icons.arrow_back_rounded,
            semanticLabel: TextManager.backAction,
            onPressed: () => context.pop(),
          ),
          horizontalSpace(8.w),
          Expanded(
            child: CustomText(
              text: title,
              maxLines: 1,
              style: getBoldStyle(
                context: context,
                fontSize: 20.sp,
                color: ColorsManager.primary,
                fontFamily: FontManager.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
