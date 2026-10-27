import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';
import 'package:mishkat/features/player/presentation/cubit/player_state.dart';

// Square geometric artwork with the surah name in gold.
class SurahArtwork extends StatelessWidget {
  // Creates the artwork.
  const SurahArtwork({super.key});

  // Builds the artwork from the loaded surah.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return BlocBuilder<PlayerCubit, PlayerState>(
      buildWhen: (a, b) => b is PlayerSuccess && (a is! PlayerSuccess || a.data.surah != b.data.surah),
      builder: (context, state) {
        final data = state is PlayerSuccess ? state.data : PlayerData.dummy();
        final size = 250.r;
        return Container(
          width: size,
          height: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ColorsManager.primaryMiddle,
            borderRadius: BorderRadius.circular(36.r),
            border: Border.all(color: ColorsManager.goldBorder),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IslamicStar(size: size * 1.2, color: ColorsManager.secondry, strokeWidth: 0.7, withRings: true, opacity: 0.35),
              IslamicStar(size: size * 0.7, color: ColorsManager.secondry, strokeWidth: 0.6, opacity: 0.35),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: isArabic ? data.surah.shortName : data.surah.englishName,
                    translate: false,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: getBoldStyle(
                      context: context,
                      fontSize: 46.sp,
                      color: ColorsManager.secondry,
                      fontFamily: FontManager.heading,
                      height: 1.25,
                    ),
                  ),
                  CustomText(
                    text: TextManager.surahOrdinal,
                    args: [localizedDigits(context, data.surah.number), localizedDigits(context, data.totalAyahs)],
                    style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.mutedOnDark),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
