import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/reflections/data/models/reflection_model.dart';
import 'package:mishkat/features/reflections/data/requests_params/save_reflection_params.dart';

// Contract for the reflection notebook.
abstract class ReflectionsRepo {
  // Returns all saved reflections, most recently edited first.
  Future<Either<Failure, List<ReflectionModel>>> getReflections();

  // Adds or updates the reflection of an ayah and returns the new list.
  Future<Either<Failure, List<ReflectionModel>>> saveReflection(SaveReflectionParams params);

  // Removes the reflection of an ayah and returns the new list.
  Future<Either<Failure, List<ReflectionModel>>> deleteReflection(int surahNumber, int ayahNumber);
}
