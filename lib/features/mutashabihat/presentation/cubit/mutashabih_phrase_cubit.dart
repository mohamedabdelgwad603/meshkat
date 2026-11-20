import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/mutashabih_phrase_params.dart';
import 'package:mishkat/features/mutashabihat/domain/repo/mutashabihat_repo.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabih_phrase_state.dart';

// Loads one similar phrase with every ayah it appears in.
class MutashabihPhraseCubit extends Cubit<MutashabihPhraseState> {
  final MutashabihatRepo _repo;
  MutashabihPhraseParams? _params;

  // Creates the cubit with the mutashabihat repository.
  MutashabihPhraseCubit(this._repo) : super(const MutashabihPhraseInitial());

  // Returns the cubit provided above the given context.
  static MutashabihPhraseCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the given phrase.
  Future<void> load(MutashabihPhraseParams params) async {
    _params = params;
    if (isClosed) return;
    emit(const MutashabihPhraseLoading());
    final result = await _repo.getPhrase(params);
    if (isClosed) return;
    result.fold(
      (failure) => emit(MutashabihPhraseError(failure.message)),
      (phrase) => emit(MutashabihPhraseSuccess(phrase)),
    );
  }

  // Reloads the page after a failure.
  Future<void> retry() async {
    final params = _params;
    if (params != null) await load(params);
  }
}
