import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:mishkat/features/home/presentation/widgets/quick_action_tile.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_cubit.dart';

// Four shortcuts: surahs, juz, tafsir of the last-read ayah and recitations.
class QuickActionsRow extends StatelessWidget {
  // Creates the shortcuts row.
  const QuickActionsRow({super.key});

  // Builds the four tiles.
  @override
  Widget build(BuildContext context) {
    final layout = LayoutCubit.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          QuickActionTile(
            icon: Icons.menu_book_outlined,
            label: TextManager.quickSurahs,
            onTap: () => layout.openMushaf(),
          ),
          QuickActionTile(
            icon: Icons.grid_view_rounded,
            label: TextManager.quickJuz,
            onTap: () => layout.openMushaf(surahsTab: 1),
          ),
          QuickActionTile(
            icon: Icons.article_outlined,
            label: TextManager.quickTafsir,
            onTap: () => _openTafsir(context),
          ),
          QuickActionTile(
            icon: Icons.headphones_outlined,
            label: TextManager.quickRecitations,
            onTap: () => context.pushNamed(PageName.player),
          ),
        ],
      ),
    );
  }

  // Opens the tafsir of the last-read ayah, or of Al-Fatiha when nothing was read yet.
  void _openTafsir(BuildContext context) {
    final state = context.read<BookmarksCubit>().state;
    final lastRead = state is BookmarksSuccess ? state.lastRead : null;
    context.pushNamed(
      PageName.tafsir,
      arguments: TafsirArgs(surahNumber: lastRead?.surahNumber ?? 1, ayahNumber: lastRead?.ayahNumber ?? 1),
    );
  }
}
