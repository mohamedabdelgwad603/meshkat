import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_details_model.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabih_occurrence_tile.dart';

// One similar phrase with its counts and the other ayahs it appears in, the first few shown until expanded.
class MutashabihPhraseCard extends StatefulWidget {
  final MutashabihPhraseDetailsModel phrase;

  // Creates the card for the given phrase.
  const MutashabihPhraseCard({super.key, required this.phrase});

  // Creates the card state.
  @override
  State<MutashabihPhraseCard> createState() => _MutashabihPhraseCardState();
}

// Remembers whether every ayah of the phrase is shown.
class _MutashabihPhraseCardState extends State<MutashabihPhraseCard> {
  static const int _collapsedCount = 3;
  bool _expanded = false;

  // Builds the phrase title, counts, the ayah list and the show-all toggle.
  @override
  Widget build(BuildContext context) {
    final phrase = widget.phrase;
    final others = phrase.otherAyahs;
    final visible = _expanded ? others : others.take(_collapsedCount).toList();
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorsManager.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(color: ColorsManager.goldOverlay, borderRadius: BorderRadius.circular(14.r)),
            child: CustomText(
              text: phrase.text,
              translate: false,
              textDirection: TextDirection.rtl,
              style: getRegularStyle(
                context: context,
                fontSize: 20.sp,
                height: 1.8,
                color: ColorsManager.secondryDark,
                fontFamily: FontManager.quran,
              ),
            ),
          ),
          verticalSpace(6.h),
          CustomText(
            text: TextManager.mutashabihatStats,
            args: [localizedDigits(context, phrase.ayahCount), localizedDigits(context, phrase.surahCount)],
            style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
          ),
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) Divider(height: 1.h, color: ColorsManager.divider),
            MutashabihOccurrenceTile(ayah: visible[i]),
          ],
          if (others.length > _collapsedCount)
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: CustomText(
                text: _expanded ? TextManager.mutashabihatShowLess : TextManager.mutashabihatShowAll,
                args: _expanded ? null : [localizedDigits(context, others.length)],
                style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.primary),
              ),
            ),
        ],
      ),
    );
  }
}
