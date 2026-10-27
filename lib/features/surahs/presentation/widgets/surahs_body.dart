import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/features/bookmarks/presentation/widgets/bookmarks_list_view.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_state.dart';
import 'package:mishkat/features/surahs/presentation/widgets/juz_list_view.dart';
import 'package:mishkat/features/surahs/presentation/widgets/surah_list_view.dart';
import 'package:mishkat/features/surahs/presentation/widgets/surahs_header.dart';
import 'package:mishkat/features/surahs/presentation/widgets/surahs_search_field.dart';
import 'package:mishkat/features/surahs/presentation/widgets/surahs_tab_switcher.dart';

// Index layout that keeps the selected sub-tab and reacts to shortcuts from home.
class SurahsBody extends StatefulWidget {
  // Creates the body.
  const SurahsBody({super.key});

  // Creates the body state.
  @override
  State<SurahsBody> createState() => _SurahsBodyState();
}

// Holds the sub-tab index and the search focus node.
class _SurahsBodyState extends State<SurahsBody> {
  final FocusNode _searchFocus = FocusNode();
  int _tab = 0;
  int _handledSearchRequest = 0;

  // Releases the focus node.
  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  // Applies a sub-tab or search request coming from the home shortcuts.
  void _onLayoutChanged(LayoutState state) {
    setState(() => _tab = state.surahsTab);
    if (state.searchRequest != _handledSearchRequest) {
      _handledSearchRequest = state.searchRequest;
      WidgetsBinding.instance.addPostFrameCallback((_) => _searchFocus.requestFocus());
    }
  }

  // Builds the header, search field, tab switcher and the selected list.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocListener<LayoutCubit, LayoutState>(
        listenWhen: (a, b) => a.surahsTab != b.surahsTab || a.searchRequest != b.searchRequest,
        listener: (context, state) => _onLayoutChanged(state),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                child: Column(
                  children: [
                    const SurahsHeader(),
                    verticalSpace(16.h),
                    if (_tab == 0) ...[
                      SurahsSearchField(focusNode: _searchFocus),
                      verticalSpace(16.h),
                    ],
                    SurahsTabSwitcher(
                      selectedIndex: _tab,
                      onChanged: (i) => LayoutCubit.get(context).openMushaf(surahsTab: i),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _tab,
                  children: const [SurahListView(), JuzListView(), BookmarksListView()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
