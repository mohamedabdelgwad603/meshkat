import 'package:equatable/equatable.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// The surah, range and repeat settings chosen for the next session.
class HifzSetupData extends Equatable {
  final List<MushafSurahModel> surahs;
  final MushafSurahModel surah;
  final int fromAyah;
  final int toAyah;
  final HifzSettingsModel settings;
  final Set<int> memorized;

  // Creates the setup data.
  const HifzSetupData({
    required this.surahs,
    required this.surah,
    required this.fromAyah,
    required this.toAyah,
    required this.settings,
    required this.memorized,
  });

  // Builds placeholder setup data for Skeletonizer loading states.
  factory HifzSetupData.dummy() {
    final surah = MushafSurahModel.dummy();
    return HifzSetupData(
      surahs: [surah],
      surah: surah,
      fromAyah: 1,
      toAyah: 5,
      settings: HifzSettingsModel.dummy(),
      memorized: const {},
    );
  }

  // Returns how many ayahs the range holds.
  int get rangeLength => toAyah - fromAyah + 1;

  // Returns how many ayahs of the range are marked as memorized.
  int get memorizedInRange => memorized.where((a) => a >= fromAyah && a <= toAyah).length;

  // Returns the params for starting a session or test on this range.
  HifzSessionParams get params =>
      HifzSessionParams(surahNumber: surah.number, fromAyah: fromAyah, toAyah: toAyah, settings: settings);

  // Returns a copy with the given fields replaced.
  HifzSetupData copyWith({
    MushafSurahModel? surah,
    int? fromAyah,
    int? toAyah,
    HifzSettingsModel? settings,
    Set<int>? memorized,
  }) =>
      HifzSetupData(
        surahs: surahs,
        surah: surah ?? this.surah,
        fromAyah: fromAyah ?? this.fromAyah,
        toAyah: toAyah ?? this.toAyah,
        settings: settings ?? this.settings,
        memorized: memorized ?? this.memorized,
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surah.number, fromAyah, toAyah, settings, memorized];
}

// Base state of the memorization setup.
abstract class HifzSetupState extends Equatable {
  // Creates the base state.
  const HifzSetupState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The setup has not loaded yet.
class HifzSetupInitial extends HifzSetupState {
  // Creates the initial state.
  const HifzSetupInitial();
}

// The surah list is loading.
class HifzSetupLoading extends HifzSetupState {
  // Creates the loading state.
  const HifzSetupLoading();
}

// The setup is ready to edit.
class HifzSetupSuccess extends HifzSetupState {
  final HifzSetupData data;

  // Creates the success state.
  const HifzSetupSuccess(this.data);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [data];
}

// The setup failed to load; message is a translation key.
class HifzSetupError extends HifzSetupState {
  final String message;

  // Creates the error state.
  const HifzSetupError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
