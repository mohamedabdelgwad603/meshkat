import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_state.dart';

// Dark green card with the explained ayah, its reference and a listen button.
class TafsirAyahCard extends StatelessWidget {
  // Creates the card.
  const TafsirAyahCard({super.key});

  // Builds the card from the tafsir state.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return BlocBuilder<TafsirCubit, TafsirState>(
      buildWhen: (a, b) => b is TafsirSuccess,
      builder: (context, state) {
        final success = state is TafsirSuccess ? state : null;
        final ayah = success?.ayah ?? AyahModel.dummy();
        final surahName = success == null ? '' : (isArabic ? success.surah.shortName : success.surah.englishName);
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: ColorsManager.primary, borderRadius: BorderRadius.circular(24.r)),
          child: Stack(
            children: [
              PositionedDirectional(
                end: -50.w,
                bottom: -60.h,
                child: IslamicStar(size: 160.r, color: ColorsManager.secondry, strokeWidth: 0.8, withRings: true, opacity: 0.2),
              ),
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomText(
                      text: ayah.text,
                      translate: false,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: getRegularStyle(
                        context: context,
                        fontSize: 25.sp,
                        height: 2.1,
                        color: ColorsManager.white,
                        fontFamily: FontManager.quran,
                      ),
                    ),
                    verticalSpace(10.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: TextManager.surahAyah,
                            args: [surahName, localizedDigits(context, ayah.numberInSurah)],
                            style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.secondry),
                          ),
                        ),
                        RoundIconButton(
                          icon: Icons.play_arrow_rounded,
                          semanticLabel: TextManager.listenAction,
                          backgroundColor: ColorsManager.secondry,
                          iconColor: ColorsManager.primary,
                          onPressed: success == null
                              ? null
                              : () => context.pushNamed(
                                    PageName.player,
                                    arguments: PlayerArgs(
                                      surahNumber: success.surah.number,
                                      startAyah: success.ayahNumber,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
