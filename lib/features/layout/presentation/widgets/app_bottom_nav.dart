import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:mishkat/features/layout/presentation/widgets/app_bottom_nav_item.dart';

// Five-item bottom bar: four tabs plus "Listen", which opens the full-screen player.
class AppBottomNav extends StatelessWidget {
  final int currentTab;

  // Creates the bar for the given selected tab.
  const AppBottomNav({super.key, required this.currentTab});

  // Builds the bar with its top border and safe-area padding.
  @override
  Widget build(BuildContext context) {
    final cubit = LayoutCubit.get(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: ColorsManager.surface,
        border: Border(top: BorderSide(color: ColorsManager.greyLight)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 8.h),
          child: Row(
            children: [
              AppBottomNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: TextManager.navHome,
                isActive: currentTab == LayoutCubit.homeTab,
                onTap: () => cubit.changeTab(LayoutCubit.homeTab),
              ),
              AppBottomNavItem(
                icon: Icons.menu_book_outlined,
                activeIcon: Icons.menu_book_rounded,
                label: TextManager.navMushaf,
                isActive: currentTab == LayoutCubit.mushafTab,
                onTap: () => cubit.changeTab(LayoutCubit.mushafTab),
              ),
              AppBottomNavItem(
                icon: Icons.headphones_outlined,
                activeIcon: Icons.headphones_rounded,
                label: TextManager.navListen,
                isActive: false,
                onTap: () => context.pushNamed(PageName.player),
              ),
              AppBottomNavItem(
                icon: Icons.bookmark_border_rounded,
                activeIcon: Icons.bookmark_rounded,
                label: TextManager.navSaved,
                isActive: currentTab == LayoutCubit.savedTab,
                onTap: () => cubit.changeTab(LayoutCubit.savedTab),
              ),
              AppBottomNavItem(
                icon: Icons.tune_rounded,
                activeIcon: Icons.tune_rounded,
                label: TextManager.navSettings,
                isActive: currentTab == LayoutCubit.settingsTab,
                onTap: () => cubit.changeTab(LayoutCubit.settingsTab),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
