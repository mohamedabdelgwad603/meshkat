import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/data/models/last_read_model.dart';

// Contract for saved ayahs and the last-read position.
abstract class BookmarksRepo {
  // Returns all saved bookmarks, newest first.
  Future<Either<Failure, List<BookmarkModel>>> getBookmarks();

  // Adds the bookmark if missing or removes it if present, and returns the new list.
  Future<Either<Failure, List<BookmarkModel>>> toggleBookmark(BookmarkModel bookmark);

  // Returns the last-read position, if any.
  Future<Either<Failure, LastReadModel?>> getLastRead();

  // Saves the last-read position.
  Future<Either<Failure, LastReadModel>> saveLastRead(LastReadModel lastRead);
}
