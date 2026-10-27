import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/bookmarks/presentation/widgets/bookmarks_list_view.dart';

// Title and list of saved ayahs.
class SavedBody extends StatelessWidget {
  // Creates the body.
  const SavedBody({super.key});

  // Builds the title and the list.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
            child: CustomText(
              text: TextManager.savedTitle,
              style: getBoldStyle(
                context: context,
                fontSize: 30.sp,
                color: ColorsManager.primary,
                fontFamily: FontManager.heading,
                height: 1.2,
              ),
            ),
          ),
          verticalSpace(8.h),
          const Expanded(child: BookmarksListView()),
        ],
      ),
    );
  }
}
