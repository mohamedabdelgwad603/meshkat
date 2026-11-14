import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/reflections/data/models/reflection_model.dart';
import 'package:mishkat/features/reflections/data/requests_params/save_reflection_params.dart';
import 'package:mishkat/features/reflections/presentation/widgets/reflection_ayah_quote.dart';
import 'package:mishkat/features/reflections/presentation/widgets/reflection_editor_sheet.dart';

// Card for one reflection that opens the editor and can jump to the ayah in the mushaf.
class ReflectionTile extends StatelessWidget {
  final ReflectionModel reflection;

  // Creates the card for the given reflection.
  const ReflectionTile({super.key, required this.reflection});

  // Builds the ayah quote, the note and the edit date.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Material(
      color: ColorsManager.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: const BorderSide(color: ColorsManager.greyLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showReflectionEditor(context, _target),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReflectionAyahQuote(
                surahName: isArabic ? reflection.surahName : reflection.surahEnglishName,
                ayahNumber: reflection.ayahNumber,
                ayahText: reflection.ayahText,
              ),
              verticalSpace(12.h),
              CustomText(
                text: reflection.note,
                translate: false,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(context: context, fontSize: 14.sp, height: 1.7),
              ),
              verticalSpace(6.h),
              Row(
                children: [
                  Icon(Icons.edit_note_rounded, size: 16.r, color: ColorsManager.grey),
                  horizontalSpace(4.w),
                  Expanded(
                    child: CustomText(
                      text: TextManager.editedOn,
                      args: [DateFormat.yMMMd(context.locale.toString()).format(reflection.updatedAt)],
                      style: getRegularStyle(context: context, fontSize: 11.sp, color: ColorsManager.grey),
                    ),
                  ),
                  RoundIconButton(
                    icon: Icons.menu_book_rounded,
                    semanticLabel: TextManager.openInMushaf,
                    iconColor: ColorsManager.primary,
                    backgroundColor: ColorsManager.primaryLight,
                    size: 36,
                    iconSize: 18,
                    onPressed: () => context.pushNamed(
                      PageName.reader,
                      arguments: ReaderArgs(surahNumber: reflection.surahNumber, initialAyah: reflection.ayahNumber),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Returns the editor target for this reflection's ayah.
  SaveReflectionParams get _target => SaveReflectionParams(
        surahNumber: reflection.surahNumber,
        surahName: reflection.surahName,
        surahEnglishName: reflection.surahEnglishName,
        ayahNumber: reflection.ayahNumber,
        ayahText: reflection.ayahText,
        note: reflection.note,
      );
}
