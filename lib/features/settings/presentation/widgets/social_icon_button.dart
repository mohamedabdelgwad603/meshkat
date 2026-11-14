import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Round brand-colored button with a social media logo and its name below.
class SocialIconButton extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final Gradient background;
  final VoidCallback onTap;

  // Creates the button.
  const SocialIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.onTap,
  });

  // Builds the logo circle and the label.
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: background,
                  boxShadow: [
                    BoxShadow(
                      color: background.colors.last.withValues(alpha: 0.3),
                      blurRadius: 8.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: FaIcon(icon, size: 18.r, color: ColorsManager.white),
              ),
              verticalSpace(6.h),
              CustomText(
                text: label,
                style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.darkLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
