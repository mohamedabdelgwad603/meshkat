import 'package:easy_localization/easy_localization.dart';
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
import 'package:mishkat/features/bookmarks/data/models/last_read_model.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:mishkat/features/home/presentation/widgets/primary_pill_button.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_cubit.dart';

// Card that resumes reading from the last saved position, or invites the user to start.
class ContinueReadingCard extends StatelessWidget {
  // Creates the card.
  const ContinueReadingCard({super.key});

  // Builds the card from the shared bookmarks state.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorsManager.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: ColorsManager.greyLight),
          boxShadow: [BoxShadow(color: ColorsManager.shadow, blurRadius: 32.r, offset: Offset(0, 12.h))],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: BlocBuilder<BookmarksCubit, BookmarksState>(
            builder: (context, state) {
              final lastRead = state is BookmarksSuccess ? state.lastRead : null;
              return lastRead == null ? const _StartReadingContent() : _LastReadContent(lastRead: lastRead);
            },
          ),
        ),
      ),
    );
  }
}

// Content shown when a last-read position exists.
class _LastReadContent extends StatelessWidget {
  final LastReadModel lastRead;

  // Creates the content for the given position.
  const _LastReadContent({required this.lastRead});

  // Builds the surah name, position meta, resume button and progress bar.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: TextManager.continueReading,
                    style: getSemiBoldStyle(context: context, fontSize: 12.sp, color: ColorsManager.secondryDark),
                  ),
                  verticalSpace(4.h),
                  CustomText(
                    text: TextManager.surahName,
                    args: [isArabic ? lastRead.surahName : lastRead.surahEnglishName],
                    maxLines: 1,
                    style: getBoldStyle(context: context, fontSize: 25.sp, fontFamily: FontManager.heading, height: 1.3),
                  ),
                  verticalSpace(2.h),
                  CustomText(
                    text: TextManager.lastReadMeta,
                    args: [
                      localizedDigits(context, lastRead.ayahNumber),
                      localizedDigits(context, lastRead.juz),
                      localizedDigits(context, lastRead.page),
                    ],
                    style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.grey),
                  ),
                ],
              ),
            ),
            horizontalSpace(12.w),
            PrimaryPillButton(
              label: TextManager.continueAction,
              onPressed: () => context.pushNamed(
                PageName.reader,
                arguments: ReaderArgs(surahNumber: lastRead.surahNumber, initialAyah: lastRead.ayahNumber),
              ),
            ),
          ],
        ),
        verticalSpace(14.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(3.r),
          child: LinearProgressIndicator(
            value: lastRead.progress,
            minHeight: 6.h,
            backgroundColor: ColorsManager.track,
            color: ColorsManager.secondry,
          ),
        ),
        verticalSpace(6.h),
        CustomText(
          text: TextManager.ayahProgress,
          args: [localizedDigits(context, lastRead.ayahNumber), localizedDigits(context, lastRead.numberOfAyahs)],
          style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
        ),
      ],
    );
  }
}

// Content shown before the user has read anything.
class _StartReadingContent extends StatelessWidget {
  // Creates the empty-state content.
  const _StartReadingContent();

  // Builds the invitation and the start button.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: TextManager.startReading,
                style: getBoldStyle(context: context, fontSize: 22.sp, fontFamily: FontManager.heading, height: 1.3),
              ),
              verticalSpace(4.h),
              CustomText(
                text: TextManager.startReadingHint,
                style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.grey),
              ),
            ],
          ),
        ),
        horizontalSpace(12.w),
        PrimaryPillButton(
          label: TextManager.startAction,
          onPressed: () => LayoutCubit.get(context).openMushaf(),
        ),
      ],
    );
  }
}
