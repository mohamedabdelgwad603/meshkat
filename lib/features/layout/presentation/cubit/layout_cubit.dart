import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_state.dart';

// Switches the main bottom tabs and routes home shortcuts into the mushaf index.
class LayoutCubit extends Cubit<LayoutState> {
  static const int homeTab = 0;
  static const int mushafTab = 1;
  static const int savedTab = 2;
  static const int settingsTab = 3;

  // Creates the cubit on the home tab.
  LayoutCubit() : super(const LayoutState());

  // Returns the cubit provided above the given context.
  static LayoutCubit get(BuildContext context) => BlocProvider.of(context);

  // Opens one of the main tabs.
  void changeTab(int index) {
    if (isClosed) return;
    emit(state.copyWith(tabIndex: index));
  }

  // Opens the mushaf index on the surahs, juz or bookmarks sub-tab.
  void openMushaf({int surahsTab = 0}) {
    if (isClosed) return;
    emit(state.copyWith(tabIndex: mushafTab, surahsTab: surahsTab));
  }

  // Opens the mushaf index and asks it to focus the search field.
  void openSearch() {
    if (isClosed) return;
    emit(state.copyWith(tabIndex: mushafTab, surahsTab: 0, searchRequest: state.searchRequest + 1));
  }
}
