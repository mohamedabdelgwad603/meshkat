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
import 'package:mishkat/core/utills/functions/share_text.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/home/data/models/daily_ayah_model.dart';

// Cream card with the ayah of the day and listen, tafsir and share actions.
class DailyAyahCard extends StatelessWidget {
  final DailyAyahModel ayah;

  // Creates the card for the given ayah.
  const DailyAyahCard({super.key, required this.ayah});

  // Builds the ayah text, divider, reference and actions.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final surahName = isArabic ? ayah.surahName : ayah.surahEnglishName;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 12.h),
      decoration: BoxDecoration(
        color: ColorsManager.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ColorsManager.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => context.pushNamed(
              PageName.reader,
              arguments: ReaderArgs(surahNumber: ayah.surahNumber, initialAyah: ayah.ayahNumber),
            ),
            child: CustomText(
              text: ayah.text,
              translate: false,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: getRegularStyle(
                context: context,
                fontSize: 24.sp,
                height: 2.1,
                color: ColorsManager.primary,
                fontFamily: FontManager.quran,
              ),
            ),
          ),
          verticalSpace(14.h),
          const Divider(height: 1, color: ColorsManager.track),
          verticalSpace(6.h),
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: TextManager.surahAyahRef,
                  args: [surahName, localizedDigits(context, ayah.ayahNumber)],
                  style: getMediumStyle(context: context, fontSize: 13.sp, color: ColorsManager.secondryDark),
                ),
              ),
              RoundIconButton(
                icon: Icons.play_arrow_rounded,
                semanticLabel: TextManager.listenAction,
                onPressed: () => context.pushNamed(
                  PageName.player,
                  arguments: PlayerArgs(surahNumber: ayah.surahNumber, startAyah: ayah.ayahNumber),
                ),
              ),
              RoundIconButton(
                icon: Icons.article_outlined,
                semanticLabel: TextManager.tafsirAction,
                onPressed: () => context.pushNamed(
                  PageName.tafsir,
                  arguments: TafsirArgs(surahNumber: ayah.surahNumber, ayahNumber: ayah.ayahNumber),
                ),
              ),
              Builder(
                builder: (buttonContext) => RoundIconButton(
                  icon: Icons.share_outlined,
                  semanticLabel: TextManager.shareAction,
                  onPressed: () => _share(buttonContext, surahName),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Shares the ayah text with its reference.
  void _share(BuildContext context, String surahName) {
    final reference = TextManager.surahAyahRef.tr(args: [surahName, ayah.ayahNumber.toString()]);
    shareText(context, '﴿${ayah.text}﴾\n$reference');
  }
}
