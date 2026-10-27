import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/surahs/presentation/cubit/surahs_cubit.dart';

// Search box that filters surahs by name or number as the user types.
class SurahsSearchField extends StatelessWidget {
  final FocusNode focusNode;

  // Creates the search field.
  const SurahsSearchField({super.key, required this.focusNode});

  // Builds the rounded text field.
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: ColorsManager.greyLight),
    );
    return TextField(
      focusNode: focusNode,
      onChanged: SurahsCubit.get(context).search,
      textInputAction: TextInputAction.search,
      style: getRegularStyle(context: context, fontSize: 15.sp),
      decoration: InputDecoration(
        hintText: TextManager.searchSurahHint.tr(context: context),
        hintStyle: getRegularStyle(context: context, fontSize: 15.sp, color: ColorsManager.grey),
        prefixIcon: Icon(Icons.search_rounded, size: 20.r, color: ColorsManager.grey),
        filled: true,
        fillColor: ColorsManager.surface,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: const BorderSide(color: ColorsManager.secondry, width: 1.4)),
      ),
    );
  }
}
