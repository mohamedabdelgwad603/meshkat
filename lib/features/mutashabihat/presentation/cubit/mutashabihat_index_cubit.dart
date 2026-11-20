import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/mutashabihat/domain/repo/mutashabihat_repo.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_index_state.dart';

// App-wide holder of which ayahs have similar phrases, used to show the mutashabihat entry points.
class MutashabihatIndexCubit extends Cubit<MutashabihatIndexState> {
  final MutashabihatRepo _repo;

  // Creates the cubit with the mutashabihat repository.
  MutashabihatIndexCubit(this._repo) : super(const MutashabihatIndexInitial());

  // Returns the cubit provided above the given context.
  static MutashabihatIndexCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the ayah keys once.
  Future<void> load() async {
    if (state is MutashabihatIndexSuccess || state is MutashabihatIndexLoading) return;
    if (isClosed) return;
    emit(const MutashabihatIndexLoading());
    final result = await _repo.getAyahKeys();
    if (isClosed) return;
    result.fold(
      (failure) => emit(MutashabihatIndexError(failure.message)),
      (keys) => emit(MutashabihatIndexSuccess(keys)),
    );
  }
}
