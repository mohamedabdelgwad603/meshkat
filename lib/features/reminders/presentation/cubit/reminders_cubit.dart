import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/reminders/data/requests_params/schedule_reminders_params.dart';
import 'package:mishkat/features/reminders/domain/repo/reminders_repo.dart';
import 'package:mishkat/features/reminders/presentation/cubit/reminders_state.dart';

// Schedules the five daily reminder notifications.
class RemindersCubit extends Cubit<RemindersState> {
  final RemindersRepo _repo;

  // Creates the cubit with its repository.
  RemindersCubit(this._repo) : super(const RemindersInitial());

  // Returns the cubit provided above the given context.
  static RemindersCubit get(BuildContext context) => BlocProvider.of(context);

  // Schedules every daily reminder with the given translated texts.
  Future<void> scheduleDailyReminders(ScheduleRemindersParams params) async {
    if (isClosed) return;
    emit(const RemindersLoading());
    final result = await _repo.scheduleDailyReminders(params);
    if (isClosed) return;
    result.fold(
      (failure) => emit(RemindersError(failure.message)),
      (_) => emit(const RemindersSuccess()),
    );
  }
}
