import 'package:equatable/equatable.dart';

// Which bottom tab is open and which sub-tab or search the mushaf index should show.
class LayoutState extends Equatable {
  final int tabIndex;
  final int surahsTab;
  final int searchRequest;

  // Creates the layout state.
  const LayoutState({this.tabIndex = 0, this.surahsTab = 0, this.searchRequest = 0});

  // Returns a copy with the given fields replaced.
  LayoutState copyWith({int? tabIndex, int? surahsTab, int? searchRequest}) => LayoutState(
        tabIndex: tabIndex ?? this.tabIndex,
        surahsTab: surahsTab ?? this.surahsTab,
        searchRequest: searchRequest ?? this.searchRequest,
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [tabIndex, surahsTab, searchRequest];
}
