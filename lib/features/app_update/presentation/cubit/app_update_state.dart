import 'package:equatable/equatable.dart';
import 'package:mishkat/features/app_update/data/models/app_update_model.dart';

// Base state of the update check.
abstract class AppUpdateState extends Equatable {
  // Creates the base state.
  const AppUpdateState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The update check has not started.
class AppUpdateInitial extends AppUpdateState {
  // Creates the initial state.
  const AppUpdateInitial();
}

// The update check is running.
class AppUpdateLoading extends AppUpdateState {
  // Creates the loading state.
  const AppUpdateLoading();
}

// The update check finished with the version info.
class AppUpdateSuccess extends AppUpdateState {
  final AppUpdateModel data;

  // Creates the success state.
  const AppUpdateSuccess(this.data);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [data.currentVersion, data.latestVersion, data.storeUrl, data.forceUpdate];
}

// The update check failed; message is a translation key.
class AppUpdateError extends AppUpdateState {
  final String message;

  // Creates the error state.
  const AppUpdateError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
