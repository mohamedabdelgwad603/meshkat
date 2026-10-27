import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/app_update/domain/repo/app_update_repo.dart';
import 'package:mishkat/features/app_update/presentation/cubit/app_update_state.dart';

// Checks Remote Config for a newer app version and opens the store page.
class AppUpdateCubit extends Cubit<AppUpdateState> {
  final AppUpdateRepo _repo;

  // Creates the cubit with its repository.
  AppUpdateCubit(this._repo) : super(const AppUpdateInitial());

  // Returns the cubit provided above the given context.
  static AppUpdateCubit get(BuildContext context) => BlocProvider.of(context);

  // Fetches the latest published version and emits it against the installed one.
  Future<void> checkForUpdate() async {
    if (isClosed) return;
    emit(const AppUpdateLoading());
    final result = await _repo.checkForUpdate();
    if (isClosed) return;
    result.fold(
      (failure) => emit(AppUpdateError(failure.message)),
      (data) => emit(AppUpdateSuccess(data)),
    );
  }

  // Opens the store page of the latest version.
  Future<void> openStore() async {
    final current = state;
    if (current is! AppUpdateSuccess) return;
    await _repo.openStore(current.data.storeUrl);
  }
}
