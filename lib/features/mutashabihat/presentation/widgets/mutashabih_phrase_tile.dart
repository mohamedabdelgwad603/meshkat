import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_summary_model.dart';

// Row of the browse list: the phrase, its counts and first place, opening all its ayahs when tapped.
class MutashabihPhraseTile extends StatelessWidget {
  final MutashabihPhraseSummaryModel phrase;

  // Creates the row for the given phrase.
  const MutashabihPhraseTile({super.key, required this.phrase});

  // Builds the card with the phrase in the mushaf font.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final firstAt = TextManager.surahAyahRef.tr(
      context: context,
      args: [phrase.displayFirstSurah(isArabic), localizedDigits(context, phrase.firstAyah)],
    );
    return Material(
      color: ColorsManager.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: const BorderSide(color: ColorsManager.greyLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.pushNamed(PageName.mutashabihPhrase, arguments: MutashabihPhraseArgs(phraseId: phrase.id)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 10.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomText(
                      text: phrase.text,
                      translate: false,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                      style: getRegularStyle(
                        context: context,
                        fontSize: 19.sp,
                        height: 1.8,
                        color: ColorsManager.onSurface,
                        fontFamily: FontManager.quran,
                      ),
                    ),
                    verticalSpace(2.h),
                    CustomText(
                      text: TextManager.mutashabihatStats,
                      args: [localizedDigits(context, phrase.ayahCount), localizedDigits(context, phrase.surahCount)],
                      style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.secondryDark),
                    ),
                    CustomText(
                      text: TextManager.mutashabihatFirstAt,
                      args: [firstAt],
                      maxLines: 1,
                      style: getRegularStyle(context: context, fontSize: 11.sp, color: ColorsManager.grey),
                    ),
                  ],
                ),
              ),
              horizontalSpace(6.w),
              Icon(Icons.chevron_right_rounded, size: 20.r, color: ColorsManager.grey),
            ],
          ),
        ),
      ),
    );
  }
}
