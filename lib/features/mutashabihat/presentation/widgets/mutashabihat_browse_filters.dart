import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_surah_picker_sheet.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_state.dart';

// Search box, surah filter, order switch and the result count of the browse list.
class MutashabihatBrowseFilters extends StatelessWidget {
  final MutashabihBrowseData data;

  // Creates the filters for the given browse data.
  const MutashabihatBrowseFilters({super.key, required this.data});

  // Builds the search box, the filter chips and the count.
  @override
  Widget build(BuildContext context) {
    final cubit = MutashabihatBrowseCubit.get(context);
    final isArabic = context.locale.languageCode == 'ar';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: ColorsManager.greyLight),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: cubit.search,
            textInputAction: TextInputAction.search,
            style: getRegularStyle(context: context, fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: TextManager.mutashabihatSearchHint.tr(context: context),
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
          ),
          verticalSpace(10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip(
                  context,
                  label: data.surah == null
                      ? TextManager.mutashabihatAllSurahs.tr(context: context)
                      : (isArabic ? data.surah!.shortName : data.surah!.englishName),
                  icon: data.surah == null ? Icons.filter_list_rounded : Icons.close_rounded,
                  selected: data.surah != null,
                  onTap: () async {
                    if (data.surah != null) return cubit.filterBySurah(null);
                    final picked = await showHifzSurahPicker(context, surahs: data.surahs, selected: 0);
                    if (picked != null) cubit.filterBySurah(picked);
                  },
                ),
                horizontalSpace(8.w),
                _chip(
                  context,
                  label: TextManager.mutashabihatSortMushaf.tr(context: context),
                  selected: data.sort == MutashabihSort.mushaf,
                  onTap: () => cubit.setSort(MutashabihSort.mushaf),
                ),
                horizontalSpace(8.w),
                _chip(
                  context,
                  label: TextManager.mutashabihatSortRepeated.tr(context: context),
                  selected: data.sort == MutashabihSort.mostRepeated,
                  onTap: () => cubit.setSort(MutashabihSort.mostRepeated),
                ),
              ],
            ),
          ),
          verticalSpace(8.h),
          CustomText(
            text: TextManager.mutashabihatResults,
            args: [localizedDigits(context, data.visible.length)],
            style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
          ),
        ],
      ),
    );
  }

  // Builds one rounded filter chip, filled when selected.
  Widget _chip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? ColorsManager.primary : ColorsManager.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: selected ? ColorsManager.primary : ColorsManager.greyLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.r, color: selected ? ColorsManager.white : ColorsManager.darkLight),
              horizontalSpace(4.w),
            ],
            CustomText(
              text: label,
              translate: false,
              style: getSemiBoldStyle(
                context: context,
                fontSize: 13.sp,
                color: selected ? ColorsManager.white : ColorsManager.darkLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
