import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';
import 'package:mishkat/features/surahs/presentation/cubit/surahs_cubit.dart';
import 'package:mishkat/features/surahs/presentation/cubit/surahs_state.dart';
import 'package:mishkat/features/surahs/presentation/widgets/surah_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

// List of surahs with skeleton loading, error and no-results states.
class SurahListView extends StatelessWidget {
  // Creates the list.
  const SurahListView({super.key});

  // Builds the list for the current state.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurahsCubit, SurahsState>(
      builder: (context, state) {
        if (state is SurahsError) {
          return StateMessageView(message: state.message, onRetry: SurahsCubit.get(context).loadSurahs);
        }
        if (state is SurahsSuccess && state.filtered.isEmpty) {
          return const StateMessageView(message: TextManager.noResults);
        }
        final isLoading = state is! SurahsSuccess;
        final surahs = state is SurahsSuccess ? state.filtered : List.generate(10, (_) => SurahModel.dummy());
        return Skeletonizer(
          enabled: isLoading,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: surahs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => SurahTile(surah: surahs[i]),
          ),
        );
      },
    );
  }
}
