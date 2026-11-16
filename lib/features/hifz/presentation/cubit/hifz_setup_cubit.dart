import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';
import 'package:mishkat/features/hifz/domain/repo/hifz_repo.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_state.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Holds the surah, range and repeat settings the user picks before a session.
class HifzSetupCubit extends Cubit<HifzSetupState> {
  final HifzRepo _repo;
  late final StreamSubscription<int> _progressSubscription;
  int _initialSurah = 1;
  int _initialAyah = 1;

  static const int defaultRangeLength = 5;

  // Creates the cubit and refreshes the progress whenever a self-test rates an ayah of the chosen surah.
  HifzSetupCubit(this._repo) : super(const HifzSetupInitial()) {
    _progressSubscription = _repo.memorizedChanges.listen((surah) {
      if (_data?.surah.number == surah) refreshProgress();
    });
  }

  // Returns the cubit provided above the given context.
  static HifzSetupCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the surahs, the saved settings and the progress, starting at the given surah and ayah.
  Future<void> load({int surahNumber = 1, int fromAyah = 1}) async {
    _initialSurah = surahNumber;
    _initialAyah = fromAyah;
    if (isClosed) return;
    emit(const HifzSetupLoading());
    final result = await _repo.getSurahs();
    if (isClosed) return;
    await result.fold(
      (failure) async => emit(HifzSetupError(failure.message)),
      (surahs) async {
        if (surahs.isEmpty) {
          emit(const HifzSetupError(TextManager.errorUnknown));
          return;
        }
        final surah = surahs.firstWhere((s) => s.number == _initialSurah, orElse: () => surahs.first);
        final from = _initialAyah.clamp(1, surah.ayahCount).toInt();
        final memorized = (await _repo.getMemorized(surah.number)).getOrElse(() => <int>{});
        if (isClosed) return;
        emit(HifzSetupSuccess(HifzSetupData(
          surahs: surahs,
          surah: surah,
          fromAyah: from,
          toAyah: _defaultEnd(from, surah),
          settings: _repo.getSettings(),
          memorized: memorized,
        )));
      },
    );
  }

  // Reloads the setup after a failure.
  Future<void> retry() => load(surahNumber: _initialSurah, fromAyah: _initialAyah);

  // Switches to another surah and selects its first ayahs.
  Future<void> selectSurah(MushafSurahModel surah) async {
    final data = _data;
    if (data == null || data.surah.number == surah.number) return;
    final memorized = (await _repo.getMemorized(surah.number)).getOrElse(() => <int>{});
    if (isClosed) return;
    emit(HifzSetupSuccess(
        data.copyWith(surah: surah, fromAyah: 1, toAyah: _defaultEnd(1, surah), memorized: memorized)));
  }

  // Sets the first ayah of the range, moving the last one along when needed.
  void setFrom(int ayah) {
    final data = _data;
    if (data == null) return;
    final from = ayah.clamp(1, data.surah.ayahCount).toInt();
    _emit(data.copyWith(fromAyah: from, toAyah: data.toAyah < from ? from : data.toAyah));
  }

  // Sets the last ayah of the range, moving the first one along when needed.
  void setTo(int ayah) {
    final data = _data;
    if (data == null) return;
    final to = ayah.clamp(1, data.surah.ayahCount).toInt();
    _emit(data.copyWith(toAyah: to, fromAyah: data.fromAyah > to ? to : data.fromAyah));
  }

  // Applies and remembers new repeat settings.
  void updateSettings(HifzSettingsModel settings) {
    final data = _data;
    if (data == null) return;
    _emit(data.copyWith(settings: settings));
    _repo.saveSettings(settings);
  }

  // Re-reads the memorized ayahs of the current surah, after a self-test for example.
  Future<void> refreshProgress() async {
    final data = _data;
    if (data == null) return;
    final memorized = (await _repo.getMemorized(data.surah.number)).getOrElse(() => data.memorized);
    final latest = _data;
    if (latest == null || latest.surah.number != data.surah.number) return;
    _emit(latest.copyWith(memorized: memorized));
  }

  // Returns the default last ayah for a range starting at the given ayah.
  int _defaultEnd(int from, MushafSurahModel surah) =>
      (from + defaultRangeLength - 1).clamp(from, surah.ayahCount).toInt();

  // Returns the loaded setup data, if any.
  HifzSetupData? get _data {
    final current = state;
    return current is HifzSetupSuccess ? current.data : null;
  }

  // Emits new setup data unless the cubit is closed.
  void _emit(HifzSetupData data) {
    if (isClosed) return;
    emit(HifzSetupSuccess(data));
  }

  // Stops listening for progress changes when the setup screen closes.
  @override
  Future<void> close() async {
    await _progressSubscription.cancel();
    return super.close();
  }
}
