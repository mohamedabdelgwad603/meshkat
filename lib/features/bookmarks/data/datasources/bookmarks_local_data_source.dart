import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/data/models/last_read_model.dart';

// Stores bookmarks and the last-read position on the device.
abstract class BookmarksLocalDataSource {
  // Returns all saved bookmarks, newest first.
  List<BookmarkModel> getBookmarks();

  // Replaces the saved bookmark list.
  Future<void> saveBookmarks(List<BookmarkModel> bookmarks);

  // Returns the last-read position, if any.
  LastReadModel? getLastRead();

  // Saves the last-read position.
  Future<void> saveLastRead(LastReadModel lastRead);
}

// SharedPreferences implementation of BookmarksLocalDataSource.
class BookmarksLocalDataSourceImp implements BookmarksLocalDataSource {
  final CacheHelper _cache;

  // Creates the data source with the cache helper.
  BookmarksLocalDataSourceImp(this._cache);

  // Returns all saved bookmarks, newest first.
  @override
  List<BookmarkModel> getBookmarks() {
    final json = _cache.readJson(CacheKeys.bookmarks);
    if (json == null) return [];
    return (json as List<dynamic>).map((e) => BookmarkModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Replaces the saved bookmark list.
  @override
  Future<void> saveBookmarks(List<BookmarkModel> bookmarks) =>
      _cache.saveJson(CacheKeys.bookmarks, bookmarks.map((e) => e.toJson()).toList());

  // Returns the last-read position, if any.
  @override
  LastReadModel? getLastRead() {
    final json = _cache.readJson(CacheKeys.lastRead);
    return json == null ? null : LastReadModel.fromJson(json as Map<String, dynamic>);
  }

  // Saves the last-read position.
  @override
  Future<void> saveLastRead(LastReadModel lastRead) => _cache.saveJson(CacheKeys.lastRead, lastRead.toJson());
}
