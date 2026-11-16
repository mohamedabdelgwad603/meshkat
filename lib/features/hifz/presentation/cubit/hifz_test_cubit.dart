import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/hifz/domain/repo/hifz_repo.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_state.dart';

// Hides the ayahs of a range so the user can recite from memory, reveal them and rate themselves.
class HifzTestCubit extends Cubit<HifzTestState> {
  final HifzRepo _repo;
  HifzSessionParams? _params;

  // Creates the cubit with the memorization repository.
  HifzTestCubit(this._repo) : super(const HifzTestInitial());

  // Returns the cubit provided above the given context.
  static HifzTestCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the range with every ayah hidden except its first word.
  Future<void> load(HifzSessionParams params) async {
    _params = params;
    if (isClosed) return;
    emit(const HifzTestLoading());
    final result = await _repo.getTestAyahs(params);
    if (isClosed) return;
    result.fold(
      (failure) => emit(HifzTestError(failure.message)),
      (session) => emit(HifzTestSuccess(HifzTestData(
        session: session,
        revealedWords: [for (final a in session.ayahs) _hintWords(a.words.length, true)],
        results: const {},
        firstWordHint: true,
      ))),
    );
  }

  // Reloads the test after a failure.
  Future<void> retry() async {
    final params = _params;
    if (params != null) await load(params);
  }

  // Shows one more word of the ayah at the given index.
  void revealWord(int index) => _setRevealed(index, (data) => data.revealedWords[index] + 1);

  // Shows the whole ayah at the given index.
  void revealAyah(int index) => _setRevealed(index, (data) => data.session.ayahs[index].words.length);

  // Hides the ayah at the given index again, keeping the hint.
  void hideAyah(int index) =>
      _setRevealed(index, (data) => _hintWords(data.session.ayahs[index].words.length, data.firstWordHint));

  // Turns the first-word hint on or off and hides every ayah again.
  void toggleHint() {
    final data = _data;
    if (data == null) return;
    final hint = !data.firstWordHint;
    _emit(data.copyWith(
      firstWordHint: hint,
      revealedWords: [for (final a in data.session.ayahs) _hintWords(a.words.length, hint)],
    ));
  }

  // Rates the ayah at the given index and saves it to the memorization progress.
  Future<void> rate(int index, {required bool memorized}) async {
    final data = _data;
    if (data == null) return;
    final ayah = data.session.ayahs[index];
    _emit(data.copyWith(
      results: {...data.results, ayah.ayahNumber: memorized},
      revealedWords: [...data.revealedWords]..[index] = ayah.words.length,
    ));
    await _repo.setMemorized(ayah.surahNumber, ayah.ayahNumber, memorized);
  }

  // Hides every ayah and clears the ratings for another round.
  void restart() {
    final data = _data;
    if (data == null) return;
    _emit(data.copyWith(
      results: const {},
      revealedWords: [for (final a in data.session.ayahs) _hintWords(a.words.length, data.firstWordHint)],
    ));
  }

  // Returns how many words stay visible as a hint for an ayah of the given length.
  int _hintWords(int wordCount, bool hint) => hint && wordCount > 1 ? 1 : 0;

  // Updates how many words of one ayah are shown, within the ayah's length.
  void _setRevealed(int index, int Function(HifzTestData) value) {
    final data = _data;
    if (data == null || index < 0 || index >= data.revealedWords.length) return;
    final words = data.session.ayahs[index].words.length;
    _emit(data.copyWith(revealedWords: [...data.revealedWords]..[index] = value(data).clamp(0, words).toInt()));
  }

  // Returns the loaded test data, if any.
  HifzTestData? get _data {
    final current = state;
    return current is HifzTestSuccess ? current.data : null;
  }

  // Emits new test data unless the cubit is closed.
  void _emit(HifzTestData data) {
    if (isClosed) return;
    emit(HifzTestSuccess(data));
  }
}
