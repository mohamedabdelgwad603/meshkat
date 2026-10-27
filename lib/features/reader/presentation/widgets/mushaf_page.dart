import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';
import 'package:mishkat/features/reader/presentation/widgets/basmala_line.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_text.dart';
import 'package:mishkat/features/reader/presentation/widgets/surah_banner.dart';

// One mushaf page: banner and basmala on the surah's first page, the ayahs and the page number.
class MushafPage extends StatelessWidget {
  final SurahTextModel surah;
  final List<AyahModel> ayahs;
  final bool isFirstPage;
  final int? selectedAyah;
  final double? bottomPadding;
  final ValueChanged<int> onAyahTap;

  // Creates the page.
  const MushafPage({
    super.key,
    required this.surah,
    required this.ayahs,
    required this.isFirstPage,
    required this.onAyahTap,
    this.selectedAyah,
    this.bottomPadding,
  });

  // Builds the scrollable page content.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(22.w, 8.h, 22.w, bottomPadding ?? 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isFirstPage) ...[
            SurahBanner(surah: surah),
            verticalSpace(14.h),
            if (surah.showsBasmala) ...[
              const BasmalaLine(),
              verticalSpace(6.h),
            ],
          ],
          MushafText(ayahs: ayahs, selectedAyah: selectedAyah, onAyahTap: onAyahTap),
          verticalSpace(18.h),
          Center(
            child: CustomText(
              text: localizedDigits(context, ayahs.first.page),
              translate: false,
              style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
            ),
          ),
        ],
      ),
    );
  }
}
