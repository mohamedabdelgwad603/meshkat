import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:mishkat/features/bookmarks/presentation/widgets/bookmark_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

// List of saved ayahs with empty, loading and error states.
class BookmarksListView extends StatelessWidget {
  // Creates the list.
  const BookmarksListView({super.key});

  // Builds the list for the current bookmarks state.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksCubit, BookmarksState>(
      builder: (context, state) {
        if (state is BookmarksError) {
          return StateMessageView(message: state.message, onRetry: BookmarksCubit.get(context).load);
        }
        if (state is BookmarksSuccess && state.bookmarks.isEmpty) {
          return const StateMessageView(message: TextManager.noBookmarks, hint: TextManager.noBookmarksHint);
        }
        final bookmarks = state is BookmarksSuccess ? state.bookmarks : List.generate(4, (_) => BookmarkModel.dummy());
        return Skeletonizer(
          enabled: state is! BookmarksSuccess,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
            itemCount: bookmarks.length,
            separatorBuilder: (_, __) => verticalSpace(12.h),
            itemBuilder: (_, i) => BookmarkTile(bookmark: bookmarks[i]),
          ),
        );
      },
    );
  }
}
