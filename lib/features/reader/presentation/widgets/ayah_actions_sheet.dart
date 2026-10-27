import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/functions/share_text.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_cubit.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_state.dart';
import 'package:mishkat/features/reader/presentation/widgets/ayah_action_button.dart';
import 'package:mishkat/features/reader/presentation/widgets/tafsir_preview_card.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';

// Bottom panel that slides up when an ayah is selected, with actions and a tafsir preview.
class AyahActionsSheet extends StatelessWidget {
  // Creates the panel.
  const AyahActionsSheet({super.key});

  // Shows or hides the panel based on the selected ayah.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReaderCubit, ReaderState>(
      buildWhen: (a, b) =>
          b is ReaderSuccess && (a is! ReaderSuccess || a.selectedAyah != b.selectedAyah),
      builder: (context, state) {
        final success = state is ReaderSuccess ? state : null;
        final selected = success?.selectedAyah;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
          child: selected == null || success == null
              ? const SizedBox.shrink(key: ValueKey('none'))
              : _SheetContent(
                  key: ValueKey(selected),
                  surahNumber: success.surah.number,
                  surahName: success.surah.shortName,
                  surahEnglishName: success.surah.englishName,
                  ayah: success.surah.ayahAt(selected),
                ),
        );
      },
    );
  }
}

// Panel content for one selected ayah.
class _SheetContent extends StatelessWidget {
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final AyahModel ayah;

  // Creates the content.
  const _SheetContent({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.ayah,
  });

  // Builds the handle, title, action grid and tafsir preview.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [BoxShadow(color: ColorsManager.shadow, blurRadius: 36.r, offset: Offset(0, -10.h))],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(color: ColorsManager.greyLight, borderRadius: BorderRadius.circular(2.r)),
            ),
          ),
          verticalSpace(12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: TextManager.ayahN,
                      args: [localizedDigits(context, ayah.numberInSurah)],
                      style: getBoldStyle(context: context, fontSize: 16.sp),
                    ),
                    CustomText(
                      text: TextManager.surahName,
                      args: [isArabic ? surahName : surahEnglishName],
                      style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
                    ),
                  ],
                ),
              ),
              RoundIconButton(
                icon: Icons.close_rounded,
                semanticLabel: TextManager.close,
                backgroundColor: ColorsManager.track,
                iconColor: ColorsManager.darkLight,
                iconSize: 18,
                onPressed: ReaderCubit.get(context).clearSelection,
              ),
            ],
          ),
          verticalSpace(14.h),
          _ActionsGrid(surahNumber: surahNumber, surahName: isArabic ? surahName : surahEnglishName, ayah: ayah),
          verticalSpace(14.h),
          BlocProvider(
            create: (_) => getIt<TafsirCubit>()..init(surahNumber, ayah.numberInSurah),
            child: TafsirPreviewCard(surahNumber: surahNumber, ayahNumber: ayah.numberInSurah),
          ),
        ],
      ),
    );
  }
}

// Five actions: tafsir, listen, copy, share and save.
class _ActionsGrid extends StatelessWidget {
  final int surahNumber;
  final String surahName;
  final AyahModel ayah;

  // Creates the grid.
  const _ActionsGrid({required this.surahNumber, required this.surahName, required this.ayah});

  // Builds the five action buttons.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AyahActionButton(
          icon: Icons.article_outlined,
          label: TextManager.tafsirAction,
          isPrimary: true,
          onTap: () => context.pushNamed(
            PageName.tafsir,
            arguments: TafsirArgs(surahNumber: surahNumber, ayahNumber: ayah.numberInSurah),
          ),
        ),
        AyahActionButton(
          icon: Icons.play_arrow_rounded,
          label: TextManager.listenAction,
          onTap: () => context.pushNamed(
            PageName.player,
            arguments: PlayerArgs(surahNumber: surahNumber, startAyah: ayah.numberInSurah),
          ),
        ),
        AyahActionButton(icon: Icons.copy_rounded, label: TextManager.copyAction, onTap: () => _copy(context)),
        Builder(
          builder: (buttonContext) => AyahActionButton(
            icon: Icons.share_outlined,
            label: TextManager.shareAction,
            onTap: () => _share(buttonContext),
          ),
        ),
        BlocBuilder<BookmarksCubit, BookmarksState>(
          builder: (context, state) {
            final saved = state is BookmarksSuccess && state.isSaved(surahNumber, ayah.numberInSurah);
            return AyahActionButton(
              icon: saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              label: saved ? TextManager.savedAction : TextManager.saveAction,
              onTap: () => ReaderCubit.get(context).toggleBookmark(ayah),
            );
          },
        ),
      ],
    );
  }

  // Returns the ayah text with its reference.
  String get _shareText =>
      '﴿${ayah.text}﴾\n${TextManager.surahAyahRef.tr(args: [surahName, ayah.numberInSurah.toString()])}';

  // Copies the ayah to the clipboard and confirms with a snack bar.
  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _shareText));
    if (!context.mounted) return;
    context.showSnack(CustomText(
      text: TextManager.copied,
      style: getMediumStyle(context: context, color: ColorsManager.white),
    ));
  }

  // Opens the system share sheet with the ayah.
  void _share(BuildContext context) => shareText(context, _shareText);
}
