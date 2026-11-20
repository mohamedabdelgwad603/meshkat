import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/ayah_mutashabihat_params.dart';
import 'package:mishkat/features/mutashabihat/domain/repo/mutashabihat_repo.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_state.dart';

// Loads one ayah's similar phrases and the other ayahs they appear in.
class MutashabihatCubit extends Cubit<MutashabihatState> {
  final MutashabihatRepo _repo;
  AyahMutashabihatParams? _params;

  // Creates the cubit with the mutashabihat repository.
  MutashabihatCubit(this._repo) : super(const MutashabihatInitial());

  // Returns the cubit provided above the given context.
  static MutashabihatCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the similar phrases of the given ayah.
  Future<void> load(AyahMutashabihatParams params) async {
    _params = params;
    if (isClosed) return;
    emit(const MutashabihatLoading());
    final result = await _repo.getAyahMutashabihat(params);
    if (isClosed) return;
    result.fold(
      (failure) => emit(MutashabihatError(failure.message)),
      (data) => emit(MutashabihatSuccess(data)),
    );
  }

  // Reloads the page after a failure.
  Future<void> retry() async {
    final params = _params;
    if (params != null) await load(params);
  }
}
