import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/home/data/requests_params/daily_ayah_params.dart';
import 'package:mishkat/features/home/domain/repo/home_repo.dart';
import 'package:mishkat/features/home/presentation/cubit/home_state.dart';

// Loads the ayah of the day for the home screen.
class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _repo;

  // Creates the cubit with the home repository.
  HomeCubit(this._repo) : super(const HomeInitial());

  // Returns the cubit provided above the given context.
  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads today's ayah.
  Future<void> loadDailyAyah() async {
    if (isClosed) return;
    emit(const HomeLoading());
    final result = await _repo.getDailyAyah(DailyAyahParams.today());
    if (isClosed) return;
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (ayah) => emit(HomeSuccess(ayah)),
    );
  }
}
