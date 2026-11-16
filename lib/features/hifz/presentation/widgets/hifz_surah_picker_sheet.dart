import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/star_number_badge.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Opens a searchable list of surahs and returns the one the user picks.
Future<MushafSurahModel?> showHifzSurahPicker(
  BuildContext context, {
  required List<MushafSurahModel> surahs,
  required int selected,
}) {
  return showModalBottomSheet<MushafSurahModel>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: ColorsManager.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28.r))),
    builder: (_) => HifzSurahPickerSheet(surahs: surahs, selected: selected),
  );
}

// Sheet with a search box and the surah list, the current surah marked.
class HifzSurahPickerSheet extends StatefulWidget {
  final List<MushafSurahModel> surahs;
  final int selected;

  // Creates the sheet.
  const HifzSurahPickerSheet({super.key, required this.surahs, required this.selected});

  // Creates the sheet state.
  @override
  State<HifzSurahPickerSheet> createState() => _HifzSurahPickerSheetState();
}

// Holds the search query.
class _HifzSurahPickerSheetState extends State<HifzSurahPickerSheet> {
  String _query = '';

  // Builds the title, the search box and the filtered list.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final surahs = _filtered();
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: ColorsManager.greyLight),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomText(
                text: TextManager.hifzChooseSurah,
                style: getBoldStyle(context: context, fontSize: 18.sp, color: ColorsManager.primary),
              ),
            ),
            verticalSpace(10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                onChanged: (value) => setState(() => _query = value.trim()),
                textInputAction: TextInputAction.search,
                style: getRegularStyle(context: context, fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: TextManager.searchSurahHint.tr(context: context),
                  hintStyle: getRegularStyle(context: context, fontSize: 15.sp, color: ColorsManager.grey),
                  prefixIcon: Icon(Icons.search_rounded, size: 20.r, color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.greyBackground,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  border: border,
                  enabledBorder: border,
                  focusedBorder:
                      border.copyWith(borderSide: const BorderSide(color: ColorsManager.secondry, width: 1.4)),
                ),
              ),
            ),
            verticalSpace(8.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
                itemCount: surahs.length,
                itemBuilder: (_, i) => _buildRow(context, surahs[i], isArabic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds one surah row with its number, name and ayah count.
  Widget _buildRow(BuildContext context, MushafSurahModel surah, bool isArabic) {
    final isSelected = surah.number == widget.selected;
    return ListTile(
      onTap: () => context.pop(surah),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      tileColor: isSelected ? ColorsManager.primaryLight : null,
      leading: StarNumberBadge(number: surah.number),
      title: CustomText(
        text: isArabic ? surah.shortName : surah.englishName,
        translate: false,
        style: getSemiBoldStyle(context: context, fontSize: 15.sp),
      ),
      subtitle: CustomText(
        text: TextManager.hifzAyahCount,
        args: [localizedDigits(context, surah.ayahCount)],
        style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
      ),
      trailing: isSelected ? Icon(Icons.check_rounded, size: 20.r, color: ColorsManager.secondry) : null,
    );
  }

  // Returns the surahs whose number or Arabic or English name matches the query.
  List<MushafSurahModel> _filtered() {
    if (_query.isEmpty) return widget.surahs;
    final query = _normalize(_query);
    return widget.surahs
        .where((s) =>
            s.number.toString() == _query ||
            _normalize(s.shortName).contains(query) ||
            s.englishName.toLowerCase().contains(query))
        .toList();
  }

  // Lowercases text and strips Arabic diacritics and alef variants so searches ignore them.
  String _normalize(String text) =>
      text.toLowerCase().replaceAll(RegExp(r'[ؐ-ًؚ-ٰٟۖ-ۭـ]'), '').replaceAll(RegExp('[أإآٱ]'), 'ا');
}
