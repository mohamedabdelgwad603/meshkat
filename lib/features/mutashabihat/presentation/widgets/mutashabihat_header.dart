import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_ayah_model.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabih_ayah_text.dart';

// The opened ayah with all its similar words shaded and a short explanation.
class MutashabihatHeader extends StatelessWidget {
  final MutashabihAyahModel ayah;

  // Creates the header for the given ayah.
  const MutashabihatHeader({super.key, required this.ayah});

  // Builds the reference, the ayah and the explanation.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: ColorsManager.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ColorsManager.secondry, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: TextManager.surahAyahRef,
            args: [ayah.displaySurah(isArabic), localizedDigits(context, ayah.ayahNumber)],
            style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.secondryDark),
          ),
          verticalSpace(6.h),
          MutashabihAyahText(ayah: ayah, fontSize: 22),
          verticalSpace(8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 16.r, color: ColorsManager.grey),
              horizontalSpace(6.w),
              Expanded(
                child: CustomText(
                  text: TextManager.mutashabihatIntro,
                  style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey, height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
