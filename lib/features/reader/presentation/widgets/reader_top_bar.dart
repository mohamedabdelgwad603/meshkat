import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_cubit.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_state.dart';
import 'package:mishkat/features/reader/presentation/widgets/font_size_sheet.dart';

// Reader top bar: back, surah name with juz and page, bookmark and reading settings.
class ReaderTopBar extends StatelessWidget {
  // Creates the top bar.
  const ReaderTopBar({super.key});

  // Builds the bar from the reader and bookmarks states.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      child: BlocBuilder<ReaderCubit, ReaderState>(
        builder: (context, state) {
          final success = state is ReaderSuccess ? state : null;
          return Row(
            children: [
              RoundIconButton(
                icon: Icons.arrow_back_rounded,
                semanticLabel: TextManager.backAction,
                onPressed: () => context.pop(),
              ),
              Expanded(child: success == null ? const SizedBox.shrink() : _TitleBlock(state: success)),
              if (success != null) _BookmarkButton(state: success),
              RoundIconButton(
                icon: Icons.text_fields_rounded,
                semanticLabel: TextManager.readingSettings,
                onPressed: () => showFontSizeSheet(context),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Surah name with the juz and page of the visible page.
class _TitleBlock extends StatelessWidget {
  final ReaderSuccess state;

  // Creates the title block.
  const _TitleBlock({required this.state});

  // Builds the two-line title.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final first = state.currentPage.first;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: isArabic ? state.surah.shortName : state.surah.englishName,
          translate: false,
          maxLines: 1,
          style: getBoldStyle(
            context: context,
            fontSize: 20.sp,
            color: ColorsManager.primary,
            fontFamily: FontManager.heading,
            height: 1.2,
          ),
        ),
        CustomText(
          text: TextManager.juzPage,
          args: [localizedDigits(context, first.juz), localizedDigits(context, first.page)],
          style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
        ),
      ],
    );
  }
}

// Saves or unsaves the first ayah of the visible page (or the selected ayah).
class _BookmarkButton extends StatelessWidget {
  final ReaderSuccess state;

  // Creates the button.
  const _BookmarkButton({required this.state});

  // Builds a filled or outlined bookmark icon.
  @override
  Widget build(BuildContext context) {
    final ayah = state.selectedAyah != null ? state.surah.ayahAt(state.selectedAyah!) : state.currentPage.first;
    return BlocBuilder<BookmarksCubit, BookmarksState>(
      builder: (context, bookmarks) {
        final saved = bookmarks is BookmarksSuccess && bookmarks.isSaved(state.surah.number, ayah.numberInSurah);
        return RoundIconButton(
          icon: saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          semanticLabel: TextManager.bookmarkPage,
          iconColor: saved ? ColorsManager.secondry : ColorsManager.primary,
          onPressed: () async {
            final nowSaved = await ReaderCubit.get(context).toggleBookmark(ayah);
            if (!context.mounted) return;
            context.showSnack(CustomText(
              text: nowSaved ? TextManager.bookmarkAdded : TextManager.bookmarkRemoved,
              style: getMediumStyle(context: context, color: ColorsManager.white),
            ));
          },
        );
      },
    );
  }
}
