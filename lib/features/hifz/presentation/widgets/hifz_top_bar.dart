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

// Back button with a title and optional subtitle, used at the top of the memorization screens.
class HifzTopBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool translateSubtitle;
  final bool onDark;

  // Creates the bar.
  const HifzTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.translateSubtitle = true,
    this.onDark = false,
  });

  // Builds the back button and the titles.
  @override
  Widget build(BuildContext context) {
    final foreground = onDark ? ColorsManager.white : ColorsManager.primary;
    return Row(
      children: [
        RoundIconButton(
          icon: Icons.arrow_back_rounded,
          semanticLabel: TextManager.backAction,
          iconColor: foreground,
          onPressed: () => context.pop(),
        ),
        horizontalSpace(8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: title,
                maxLines: 1,
                style:
                    getBoldStyle(context: context, fontSize: 20.sp, color: foreground, fontFamily: FontManager.heading),
              ),
              if (subtitle != null)
                CustomText(
                  text: subtitle!,
                  translate: translateSubtitle,
                  maxLines: 1,
                  style: getRegularStyle(
                    context: context,
                    fontSize: 12.sp,
                    color: onDark ? ColorsManager.mutedOnDark : ColorsManager.grey,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
