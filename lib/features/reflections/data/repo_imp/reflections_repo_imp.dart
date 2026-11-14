import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/reflections/data/datasources/reflections_local_data_source.dart';
import 'package:mishkat/features/reflections/data/models/reflection_model.dart';
import 'package:mishkat/features/reflections/data/requests_params/save_reflection_params.dart';
import 'package:mishkat/features/reflections/domain/repo/reflections_repo.dart';

// Local implementation of ReflectionsRepo.
class ReflectionsRepoImp implements ReflectionsRepo {
  final ReflectionsLocalDataSource _local;

  // Creates the repository with its local data source.
  ReflectionsRepoImp(this._local);

  // Returns all saved reflections, most recently edited first.
  @override
  Future<Either<Failure, List<ReflectionModel>>> getReflections() =>
      safeExecute(request: () async => _local.getReflections());

  // Adds or updates the reflection of an ayah, moves it to the top and returns the new list.
  @override
  Future<Either<Failure, List<ReflectionModel>>> saveReflection(SaveReflectionParams params) =>
      safeExecute(request: () async {
        final list = _local.getReflections();
        final now = DateTime.now();
        final existing = list.where((r) => r.matches(params.surahNumber, params.ayahNumber)).firstOrNull;
        final saved = ReflectionModel(
          surahNumber: params.surahNumber,
          surahName: params.surahName,
          surahEnglishName: params.surahEnglishName,
          ayahNumber: params.ayahNumber,
          ayahText: params.ayahText,
          note: params.note.trim(),
          createdAt: existing?.createdAt ?? now,
          updatedAt: now,
        );
        final updated = [saved, ...list.where((r) => !r.matches(params.surahNumber, params.ayahNumber))];
        await _local.saveReflections(updated);
        return updated;
      });

  // Removes the reflection of an ayah and returns the new list.
  @override
  Future<Either<Failure, List<ReflectionModel>>> deleteReflection(int surahNumber, int ayahNumber) =>
      safeExecute(request: () async {
        final updated = _local.getReflections().where((r) => !r.matches(surahNumber, ayahNumber)).toList();
        await _local.saveReflections(updated);
        return updated;
      });
}
