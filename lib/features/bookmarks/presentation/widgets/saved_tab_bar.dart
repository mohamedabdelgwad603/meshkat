import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Pill-shaped switch between the bookmarks and the reflection notebook.
class SavedTabBar extends StatelessWidget {
  // Creates the tab bar.
  const SavedTabBar({super.key});

  // Builds the two tabs on a soft track with a sliding green pill.
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(color: ColorsManager.track, borderRadius: BorderRadius.circular(22.r)),
      child: TabBar(
        dividerColor: ColorsManager.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        splashBorderRadius: BorderRadius.circular(18.r),
        indicator: BoxDecoration(color: ColorsManager.primary, borderRadius: BorderRadius.circular(18.r)),
        labelColor: ColorsManager.white,
        unselectedLabelColor: ColorsManager.darkLight,
        labelStyle: getSemiBoldStyle(context: context, fontSize: 14.sp),
        unselectedLabelStyle: getMediumStyle(context: context, fontSize: 14.sp),
        tabs: const [
          Tab(child: _TabLabel(icon: Icons.bookmark_rounded, text: TextManager.bookmarksTab)),
          Tab(child: _TabLabel(icon: Icons.edit_note_rounded, text: TextManager.reflectionsTab)),
        ],
      ),
    );
  }
}

// Icon and translated title of one tab, colored by the tab bar.
class _TabLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  // Creates the label.
  const _TabLabel({required this.icon, required this.text});

  // Builds the icon and text in the color the tab bar provides.
  @override
  Widget build(BuildContext context) {
    final color = DefaultTextStyle.of(context).style.color;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.r, color: color),
        SizedBox(width: 6.w),
        CustomText(text: text, style: DefaultTextStyle.of(context).style),
      ],
    );
  }
}
