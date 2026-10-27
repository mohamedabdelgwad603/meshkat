import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/features/reader/data/requests_params/surah_text_params.dart';
import 'package:mishkat/features/reader/domain/repo/reader_repo.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';
import 'package:mishkat/features/tafsir/data/requests_params/tafsir_params.dart';
import 'package:mishkat/features/tafsir/domain/repo/tafsir_repo.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_state.dart';

// Loads an ayah's tafsir, switches between tafsir books and steps through ayahs.
class TafsirCubit extends Cubit<TafsirState> {
  final TafsirRepo _repo;
  final ReaderRepo _readerRepo;

  // Creates the cubit with the tafsir and reader repositories.
  TafsirCubit(this._repo, this._readerRepo) : super(const TafsirInitial());

  // Returns the cubit provided above the given context.
  static TafsirCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the surah text, the tafsir books and the tafsir of the given ayah.
  Future<void> init(int surahNumber, int ayahNumber) async {
    if (isClosed) return;
    emit(const TafsirLoading());
    final surahResult = await _readerRepo.getSurahText(SurahTextParams(surahNumber: surahNumber));
    final editionsResult = await _repo.getEditions();
    if (isClosed) return;
    surahResult.fold(
      (failure) => emit(TafsirError(failure.message)),
      (surah) {
        final editions = editionsResult.getOrElse(() => const <TafsirEditionModel>[]);
        final safeEditions = editions.isEmpty ? [TafsirEditionModel.dummy()] : editions;
        final saved = _repo.getSelectedEdition();
        final selected = safeEditions.any((e) => e.identifier == saved) ? saved : safeEditions.first.identifier;
        emit(TafsirSuccess(
          surah: surah,
          ayahNumber: ayahNumber.clamp(1, surah.ayahs.length).toInt(),
          editions: safeEditions,
          selectedEdition: selected.isEmpty ? EndPoints.defaultTafsir : selected,
        ));
        _loadTafsir();
      },
    );
  }

  // Switches to another tafsir book and remembers the choice.
  Future<void> selectEdition(String identifier) async {
    final current = state;
    if (current is! TafsirSuccess || current.selectedEdition == identifier) return;
    if (isClosed) return;
    emit(current.copyWith(selectedEdition: identifier, clearTafsir: true));
    await _repo.saveSelectedEdition(identifier);
    await _loadTafsir();
  }

  // Moves to the next ayah of the surah.
  Future<void> nextAyah() async {
    final current = state;
    if (current is! TafsirSuccess || !current.hasNext) return;
    if (isClosed) return;
    emit(current.copyWith(ayahNumber: current.ayahNumber + 1, clearTafsir: true));
    await _loadTafsir();
  }

  // Moves to the previous ayah of the surah.
  Future<void> previousAyah() async {
    final current = state;
    if (current is! TafsirSuccess || !current.hasPrevious) return;
    if (isClosed) return;
    emit(current.copyWith(ayahNumber: current.ayahNumber - 1, clearTafsir: true));
    await _loadTafsir();
  }

  // Retries loading the tafsir text after a failure.
  Future<void> retryTafsir() => _loadTafsir();

  // Fetches the tafsir text for the current ayah and book.
  Future<void> _loadTafsir() async {
    final current = state;
    if (current is! TafsirSuccess) return;
    if (isClosed) return;
    emit(current.copyWith(isTafsirLoading: true));
    final result = await _repo.getTafsir(TafsirParams(
      surahNumber: current.surah.number,
      ayahNumber: current.ayahNumber,
      edition: current.selectedEdition,
    ));
    if (isClosed) return;
    final latest = state;
    if (latest is! TafsirSuccess ||
        latest.ayahNumber != current.ayahNumber ||
        latest.selectedEdition != current.selectedEdition) {
      return;
    }
    result.fold(
      (failure) => emit(latest.copyWith(isTafsirLoading: false, tafsirError: failure.message)),
      (tafsir) => emit(latest.copyWith(isTafsirLoading: false, tafsir: tafsir)),
    );
  }
}
