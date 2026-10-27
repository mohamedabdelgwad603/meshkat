import 'package:equatable/equatable.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';

// Reading and listening preferences.
class SettingsData extends Equatable {
  final double quranFontSize;
  final List<ReciterModel> reciters;
  final String selectedReciter;

  // Creates the settings data.
  const SettingsData({required this.quranFontSize, required this.reciters, required this.selectedReciter});

  // Returns the chosen reciter, falling back to the default one.
  ReciterModel get reciter => reciters.firstWhere(
        (r) => r.identifier == selectedReciter,
        orElse: ReciterModel.dummy,
      );

  // Returns a copy with the given fields replaced.
  SettingsData copyWith({double? quranFontSize, List<ReciterModel>? reciters, String? selectedReciter}) =>
      SettingsData(
        quranFontSize: quranFontSize ?? this.quranFontSize,
        reciters: reciters ?? this.reciters,
        selectedReciter: selectedReciter ?? this.selectedReciter,
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [quranFontSize, reciters, selectedReciter];
}

// Base state of the settings.
abstract class SettingsState extends Equatable {
  // Creates the base state.
  const SettingsState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Settings have not been loaded yet.
class SettingsInitial extends SettingsState {
  // Creates the initial state.
  const SettingsInitial();
}

// Settings are loading.
class SettingsLoading extends SettingsState {
  // Creates the loading state.
  const SettingsLoading();
}

// Settings are available.
class SettingsSuccess extends SettingsState {
  final SettingsData data;

  // Creates the success state.
  const SettingsSuccess(this.data);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [data];
}

// Settings failed to load; message is a translation key.
class SettingsError extends SettingsState {
  final String message;

  // Creates the error state.
  const SettingsError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
