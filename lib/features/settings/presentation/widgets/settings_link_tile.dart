import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Tappable row with an icon, a title, an optional value and a chevron.
class SettingsLinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final bool translateValue;
  final VoidCallback onTap;

  // Creates the row.
  const SettingsLinkTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
    this.translateValue = false,
  });

  // Builds the row.
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 44.h,
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(color: ColorsManager.primaryLight, borderRadius: BorderRadius.circular(12.r)),
              child: Icon(icon, size: 20.r, color: ColorsManager.primary),
            ),
            horizontalSpace(12.w),
            Expanded(child: CustomText(text: title, style: getSemiBoldStyle(context: context))),
            if (value != null)
              Flexible(
                child: CustomText(
                  text: value!,
                  translate: translateValue,
                  maxLines: 1,
                  style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.grey),
                ),
              ),
            horizontalSpace(6.w),
            Icon(Icons.arrow_forward_ios_rounded, size: 14.r, color: ColorsManager.mutedOnDark),
          ],
        ),
      ),
    );
  }
}
