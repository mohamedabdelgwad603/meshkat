import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Segmented control switching between surahs, juz and bookmarks.
class SurahsTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const List<String> _labels = [TextManager.tabSurahs, TextManager.tabJuz, TextManager.tabBookmarks];

  // Creates the switcher.
  const SurahsTabSwitcher({super.key, required this.selectedIndex, required this.onChanged});

  // Builds the three segments on a sand-colored track.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(color: ColorsManager.track, borderRadius: BorderRadius.circular(16.r)),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Expanded(
              child: Semantics(
                selected: i == selectedIndex,
                button: true,
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selectedIndex ? ColorsManager.primary : ColorsManager.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: CustomText(
                      text: _labels[i],
                      style: i == selectedIndex
                          ? getSemiBoldStyle(context: context, color: ColorsManager.white)
                          : getMediumStyle(context: context, color: ColorsManager.darkLight),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
