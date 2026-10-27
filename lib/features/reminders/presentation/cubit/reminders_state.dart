import 'package:equatable/equatable.dart';

// Base state of the daily reminders.
abstract class RemindersState extends Equatable {
  // Creates the base state.
  const RemindersState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Reminders have not been scheduled yet.
class RemindersInitial extends RemindersState {
  // Creates the initial state.
  const RemindersInitial();
}

// Reminders are being scheduled.
class RemindersLoading extends RemindersState {
  // Creates the loading state.
  const RemindersLoading();
}

// Reminders were scheduled.
class RemindersSuccess extends RemindersState {
  // Creates the success state.
  const RemindersSuccess();
}

// Scheduling failed; message is a translation key.
class RemindersError extends RemindersState {
  final String message;

  // Creates the error state.
  const RemindersError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
