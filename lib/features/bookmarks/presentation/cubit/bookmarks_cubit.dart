import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/data/models/last_read_model.dart';
import 'package:mishkat/features/bookmarks/domain/repo/bookmarks_repo.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_state.dart';

// App-wide holder of saved ayahs and the last-read position.
class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarksRepo _repo;

  // Creates the cubit with the bookmarks repository.
  BookmarksCubit(this._repo) : super(const BookmarksInitial());

  // Returns the cubit provided above the given context.
  static BookmarksCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads bookmarks and the last-read position from storage.
  Future<void> load() async {
    if (isClosed) return;
    emit(const BookmarksLoading());
    final bookmarks = await _repo.getBookmarks();
    final lastRead = await _repo.getLastRead();
    if (isClosed) return;
    bookmarks.fold(
      (failure) => emit(BookmarksError(failure.message)),
      (list) => emit(BookmarksSuccess(bookmarks: list, lastRead: lastRead.getOrElse(() => null))),
    );
  }

  // Adds or removes a bookmark and returns true when it is now saved.
  Future<bool> toggle(BookmarkModel bookmark) async {
    final result = await _repo.toggleBookmark(bookmark);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(BookmarksError(failure.message));
        return false;
      },
      (list) {
        emit(BookmarksSuccess(bookmarks: list, lastRead: _lastRead));
        return list.any((b) => b.matches(bookmark.surahNumber, bookmark.ayahNumber));
      },
    );
  }

  // Saves the reader's current position when it changed.
  Future<void> saveLastRead(LastReadModel lastRead) async {
    if (_lastRead == lastRead) return;
    final result = await _repo.saveLastRead(lastRead);
    if (isClosed) return;
    result.fold(
      (failure) => emit(BookmarksError(failure.message)),
      (saved) => emit(BookmarksSuccess(bookmarks: _bookmarks, lastRead: saved)),
    );
  }

  // Returns the bookmarks held by the current state.
  List<BookmarkModel> get _bookmarks {
    final current = state;
    return current is BookmarksSuccess ? current.bookmarks : const [];
  }

  // Returns the last-read position held by the current state.
  LastReadModel? get _lastRead {
    final current = state;
    return current is BookmarksSuccess ? current.lastRead : null;
  }
}
