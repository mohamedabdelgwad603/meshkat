import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/reflections/data/models/reflection_model.dart';
import 'package:mishkat/features/reflections/data/requests_params/save_reflection_params.dart';
import 'package:mishkat/features/reflections/domain/repo/reflections_repo.dart';
import 'package:mishkat/features/reflections/presentation/cubit/reflections_state.dart';

// App-wide holder of the reflection notebook.
class ReflectionsCubit extends Cubit<ReflectionsState> {
  final ReflectionsRepo _repo;

  // Creates the cubit with the reflections repository.
  ReflectionsCubit(this._repo) : super(const ReflectionsInitial());

  // Returns the cubit provided above the given context.
  static ReflectionsCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the saved reflections from storage.
  Future<void> load() async {
    if (isClosed) return;
    emit(const ReflectionsLoading());
    final result = await _repo.getReflections();
    if (isClosed) return;
    result.fold(
      (failure) => emit(ReflectionsError(failure.message)),
      (list) => emit(ReflectionsSuccess(list)),
    );
  }

  // Saves the reflection of an ayah and returns the failure message key when it could not.
  Future<String?> save(SaveReflectionParams params) async => _applyList(await _repo.saveReflection(params));

  // Deletes the reflection of an ayah and returns the failure message key when it could not.
  Future<String?> delete(int surahNumber, int ayahNumber) async =>
      _applyList(await _repo.deleteReflection(surahNumber, ayahNumber));

  // Returns the reflection written on the given ayah, if any.
  ReflectionModel? find(int surahNumber, int ayahNumber) {
    final current = state;
    return current is ReflectionsSuccess ? current.find(surahNumber, ayahNumber) : null;
  }

  // Emits the new list on success and keeps the current one on failure, returning the failure message key.
  String? _applyList(Either<Failure, List<ReflectionModel>> result) {
    if (isClosed) return null;
    return result.fold(
      (failure) => failure.message,
      (list) {
        emit(ReflectionsSuccess(list));
        return null;
      },
    );
  }
}
