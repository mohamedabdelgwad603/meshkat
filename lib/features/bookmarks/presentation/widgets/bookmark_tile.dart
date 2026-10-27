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
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';

// Card for one saved ayah that opens the reader and can be removed.
class BookmarkTile extends StatelessWidget {
  final BookmarkModel bookmark;

  // Creates the card for the given bookmark.
  const BookmarkTile({super.key, required this.bookmark});

  // Builds the card with the ayah text and reference.
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
        onTap: () => context.pushNamed(
          PageName.reader,
          arguments: ReaderArgs(surahNumber: bookmark.surahNumber, initialAyah: bookmark.ayahNumber),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 4.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.bookmark_rounded, size: 18.r, color: ColorsManager.secondry),
                  horizontalSpace(6.w),
                  Expanded(
                    child: CustomText(
                      text: TextManager.surahAyahRef,
                      args: [
                        isArabic ? bookmark.surahName : bookmark.surahEnglishName,
                        localizedDigits(context, bookmark.ayahNumber),
                      ],
                      style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.secondryDark),
                    ),
                  ),
                  RoundIconButton(
                    icon: Icons.close_rounded,
                    semanticLabel: TextManager.removeBookmark,
                    iconColor: ColorsManager.grey,
                    size: 40,
                    iconSize: 18,
                    onPressed: () => BookmarksCubit.get(context).toggle(bookmark),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: CustomText(
                  text: bookmark.text,
                  translate: false,
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                  style: getRegularStyle(
                    context: context,
                    fontSize: 20.sp,
                    height: 2,
                    fontFamily: FontManager.quran,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
