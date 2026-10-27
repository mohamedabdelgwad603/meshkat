import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/surahs/data/models/juz_model.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';
import 'package:mishkat/features/surahs/presentation/cubit/surahs_cubit.dart';
import 'package:mishkat/features/surahs/presentation/cubit/surahs_state.dart';
import 'package:mishkat/features/surahs/presentation/widgets/juz_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

// List of the thirty juz, each opening the reader at its first ayah.
class JuzListView extends StatelessWidget {
  // Creates the list.
  const JuzListView({super.key});

  // Builds the list for the current state.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurahsCubit, SurahsState>(
      builder: (context, state) {
        if (state is SurahsError) {
          return StateMessageView(message: state.message, onRetry: SurahsCubit.get(context).loadSurahs);
        }
        final success = state is SurahsSuccess ? state : null;
        final juzList = success?.juzList ?? List.generate(10, (_) => JuzModel.dummy());
        return Skeletonizer(
          enabled: success == null,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
            itemCount: juzList.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final juz = juzList[i];
              final surah = success?.surahByNumber(juz.surahNumber) ?? SurahModel.dummy();
              return JuzTile(juz: juz, surah: surah);
            },
          ),
        );
      },
    );
  }
}
