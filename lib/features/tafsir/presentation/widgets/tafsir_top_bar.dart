import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/share_text.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_state.dart';

// Tafsir top bar: back, title and share.
class TafsirTopBar extends StatelessWidget {
  // Creates the top bar.
  const TafsirTopBar({super.key});

  // Builds the bar.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      child: Row(
        children: [
          RoundIconButton(
            icon: Icons.arrow_back_rounded,
            semanticLabel: TextManager.backAction,
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: CustomText(
              text: TextManager.tafsirTitle,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                context: context,
                fontSize: 22.sp,
                color: ColorsManager.primary,
                fontFamily: FontManager.heading,
              ),
            ),
          ),
          Builder(
            builder: (buttonContext) => RoundIconButton(
              icon: Icons.share_outlined,
              semanticLabel: TextManager.shareAction,
              onPressed: () => _share(buttonContext),
            ),
          ),
        ],
      ),
    );
  }

  // Shares the ayah, its reference and the loaded tafsir text.
  void _share(BuildContext context) {
    final state = TafsirCubit.get(context).state;
    if (state is! TafsirSuccess || state.tafsir == null) return;
    final isArabic = context.locale.languageCode == 'ar';
    final reference = TextManager.surahAyah.tr(args: [
      isArabic ? state.surah.shortName : state.surah.englishName,
      state.ayahNumber.toString(),
    ]);
    final book = state.selectedEditionModel?.name ?? '';
    shareText(context, '﴿${state.ayah.text}﴾\n$reference\n\n$book:\n${state.tafsir!.text}');
  }
}
