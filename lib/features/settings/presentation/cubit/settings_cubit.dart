import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';
import 'package:mishkat/features/player/domain/repo/player_repo.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';
import 'package:mishkat/features/settings/domain/repo/settings_repo.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_state.dart';

// App-wide holder of the mushaf font size and default reciter.
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo _repo;
  final PlayerRepo _playerRepo;
  final PlayerCubit _playerCubit;

  static const double minFontSize = 18;
  static const double maxFontSize = 38;

  // Creates the cubit with its repositories and the shared player.
  SettingsCubit(this._repo, this._playerRepo, this._playerCubit) : super(const SettingsInitial());

  // Returns the cubit provided above the given context.
  static SettingsCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the saved preferences, the reciter list and the app version.
  Future<void> load() async {
    if (isClosed) return;
    emit(const SettingsLoading());
    final fontSize = await _repo.getQuranFontSize();
    final reciters = await _playerRepo.getReciters();
    final appVersion = await _repo.getAppVersion();
    if (isClosed) return;
    fontSize.fold(
      (failure) => emit(SettingsError(failure.message)),
      (size) => emit(SettingsSuccess(SettingsData(
        quranFontSize: size,
        reciters: reciters.getOrElse(() => const []),
        selectedReciter: _playerRepo.getSelectedReciter(),
        appVersion: appVersion.getOrElse(() => ''),
      ))),
    );
  }

  // Saves a new mushaf font size within the allowed range.
  Future<void> setQuranFontSize(double size) async {
    final current = state;
    if (current is! SettingsSuccess) return;
    final clamped = size.clamp(minFontSize, maxFontSize).toDouble();
    if (isClosed) return;
    emit(SettingsSuccess(current.data.copyWith(quranFontSize: clamped)));
    await _repo.saveQuranFontSize(clamped);
  }

  // Saves the default reciter and applies it to the player.
  Future<void> setReciter(ReciterModel reciter) async {
    final current = state;
    if (current is! SettingsSuccess) return;
    if (isClosed) return;
    emit(SettingsSuccess(current.data.copyWith(selectedReciter: reciter.identifier)));
    await _playerCubit.changeReciter(reciter);
  }

  // Returns the current mushaf font size or the default.
  double get quranFontSize {
    final current = state;
    return current is SettingsSuccess ? current.data.quranFontSize : 25;
  }
}
