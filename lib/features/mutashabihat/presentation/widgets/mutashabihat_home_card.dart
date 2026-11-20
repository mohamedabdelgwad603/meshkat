import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Home card that opens the list of every similar phrase.
class MutashabihatHomeCard extends StatelessWidget {
  // Creates the card.
  const MutashabihatHomeCard({super.key});

  // Builds the icon, title, description and chevron.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Material(
        color: ColorsManager.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: ColorsManager.greyLight),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.pushNamed(PageName.mutashabihatBrowse),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration:
                      BoxDecoration(color: ColorsManager.goldOverlay, borderRadius: BorderRadius.circular(16.r)),
                  child: Icon(Icons.compare_arrows_rounded, size: 24.r, color: ColorsManager.secondryDark),
                ),
                horizontalSpace(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomText(
                        text: TextManager.mutashabihatHomeTitle,
                        style: getBoldStyle(context: context, fontSize: 15.sp, color: ColorsManager.primary),
                      ),
                      verticalSpace(2.h),
                      CustomText(
                        text: TextManager.mutashabihatHomeBody,
                        maxLines: 2,
                        style:
                            getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey, height: 1.5),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 22.r, color: ColorsManager.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
