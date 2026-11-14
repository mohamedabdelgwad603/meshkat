import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat/features/reflections/data/datasources/reflections_local_data_source.dart';
import 'package:mishkat/features/reflections/data/models/reflection_model.dart';
import 'package:mishkat/features/reflections/data/repo_imp/reflections_repo_imp.dart';
import 'package:mishkat/features/reflections/data/requests_params/save_reflection_params.dart';

// In-memory stand-in for the reflections storage.
class _MemoryReflections implements ReflectionsLocalDataSource {
  List<ReflectionModel> items = [];

  // Returns the stored reflections.
  @override
  List<ReflectionModel> getReflections() => items;

  // Replaces the stored reflections.
  @override
  Future<void> saveReflections(List<ReflectionModel> reflections) async => items = reflections;
}

// Builds save params for an ayah with the given note.
SaveReflectionParams _params(int surah, int ayah, String note) => SaveReflectionParams(
      surahNumber: surah,
      surahName: 'سورة',
      surahEnglishName: 'Surah',
      ayahNumber: ayah,
      ayahText: 'نص',
      note: note,
    );

// Checks adding, editing and deleting reflections in the repository.
void main() {
  late _MemoryReflections storage;
  late ReflectionsRepoImp repo;

  setUp(() {
    storage = _MemoryReflections();
    repo = ReflectionsRepoImp(storage);
  });

  test('adds new reflections at the top and trims the note', () async {
    await repo.saveReflection(_params(1, 1, 'first'));
    await repo.saveReflection(_params(2, 5, '  second  '));
    expect(storage.items.map((r) => r.note), ['second', 'first']);
  });

  test('editing keeps one entry per ayah, moves it to the top and keeps its creation date', () async {
    await repo.saveReflection(_params(1, 1, 'old'));
    final created = storage.items.single.createdAt;
    await repo.saveReflection(_params(2, 2, 'other'));
    await repo.saveReflection(_params(1, 1, 'new'));
    expect(storage.items.length, 2);
    expect(storage.items.first.note, 'new');
    expect(storage.items.first.createdAt, created);
  });

  test('deletes only the reflection of the given ayah', () async {
    await repo.saveReflection(_params(1, 1, 'a'));
    await repo.saveReflection(_params(1, 2, 'b'));
    final result = await repo.deleteReflection(1, 1);
    expect(result.isRight(), isTrue);
    expect(storage.items.map((r) => r.ayahNumber), [2]);
  });

  test('round-trips through JSON', () {
    final model = ReflectionModel.dummy();
    expect(ReflectionModel.fromJson(model.toJson()), model);
  });
}
