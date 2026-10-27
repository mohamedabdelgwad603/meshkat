import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/bookmarks/data/datasources/bookmarks_local_data_source.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/data/models/last_read_model.dart';
import 'package:mishkat/features/bookmarks/domain/repo/bookmarks_repo.dart';
import 'package:mishkat/features/reader/data/datasources/mushaf_script_local_data_source.dart';

// Local implementation of BookmarksRepo.
class BookmarksRepoImp implements BookmarksRepo {
  final BookmarksLocalDataSource _local;
  final MushafScriptLocalDataSource _mushaf;

  // Creates the repository with its data sources.
  BookmarksRepoImp(this._local, this._mushaf);

  // Returns all saved bookmarks, newest first, with the printed mushaf text.
  @override
  Future<Either<Failure, List<BookmarkModel>>> getBookmarks() =>
      safeExecute(request: () async => _withMushaf(_local.getBookmarks()));

  // Adds the bookmark if missing or removes it if present, and returns the new list.
  @override
  Future<Either<Failure, List<BookmarkModel>>> toggleBookmark(BookmarkModel bookmark) =>
      safeExecute(request: () async {
        final list = _local.getBookmarks();
        final exists = list.any((b) => b.matches(bookmark.surahNumber, bookmark.ayahNumber));
        final updated = exists
            ? list.where((b) => !b.matches(bookmark.surahNumber, bookmark.ayahNumber)).toList()
            : [bookmark, ...list];
        await _local.saveBookmarks(updated);
        return _withMushaf(updated);
      });

  // Replaces each bookmark's text with the printed mushaf text, keeping saved text from older versions readable.
  Future<List<BookmarkModel>> _withMushaf(List<BookmarkModel> bookmarks) async => [
        for (final b in bookmarks) b.copyWithText((await _mushaf.getAyahScript(b.surahNumber, b.ayahNumber)).text),
      ];

  // Returns the last-read position, if any.
  @override
  Future<Either<Failure, LastReadModel?>> getLastRead() => safeExecute(request: () async => _local.getLastRead());

  // Saves the last-read position.
  @override
  Future<Either<Failure, LastReadModel>> saveLastRead(LastReadModel lastRead) => safeExecute(request: () async {
        await _local.saveLastRead(lastRead);
        return lastRead;
      });
}
