import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mishkat/features/settings/presentation/widgets/quran_font_size_control.dart';

// Opens the reading-settings bottom sheet with the font size slider.
Future<void> showFontSizeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28.r))),
    builder: (_) => BlocProvider.value(
      value: SettingsCubit.get(context),
      child: const FontSizeSheet(),
    ),
  );
}

// Reading-settings sheet content.
class FontSizeSheet extends StatelessWidget {
  // Creates the sheet content.
  const FontSizeSheet({super.key});

  // Builds the title and the font size control.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              text: TextManager.readingSettings,
              style: getBoldStyle(context: context, fontSize: 17.sp, color: ColorsManager.primary),
            ),
            verticalSpace(12.h),
            const QuranFontSizeControl(),
          ],
        ),
      ),
    );
  }
}
