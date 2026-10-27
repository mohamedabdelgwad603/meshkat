import 'package:equatable/equatable.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/data/models/last_read_model.dart';

// Base state of saved ayahs and last-read position.
abstract class BookmarksState extends Equatable {
  // Creates the base state.
  const BookmarksState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Bookmarks have not been loaded yet.
class BookmarksInitial extends BookmarksState {
  // Creates the initial state.
  const BookmarksInitial();
}

// Bookmarks are loading from storage.
class BookmarksLoading extends BookmarksState {
  // Creates the loading state.
  const BookmarksLoading();
}

// Bookmarks and last-read position are available.
class BookmarksSuccess extends BookmarksState {
  final List<BookmarkModel> bookmarks;
  final LastReadModel? lastRead;

  // Creates the success state.
  const BookmarksSuccess({required this.bookmarks, this.lastRead});

  // Tells whether the given ayah is saved.
  bool isSaved(int surah, int ayah) => bookmarks.any((b) => b.matches(surah, ayah));

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [bookmarks, lastRead];
}

// Bookmarks failed to load; message is a translation key.
class BookmarksError extends BookmarksState {
  final String message;

  // Creates the error state.
  const BookmarksError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
