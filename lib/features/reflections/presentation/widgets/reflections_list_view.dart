import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/reflections/data/models/reflection_model.dart';
import 'package:mishkat/features/reflections/presentation/cubit/reflections_cubit.dart';
import 'package:mishkat/features/reflections/presentation/cubit/reflections_state.dart';
import 'package:mishkat/features/reflections/presentation/widgets/reflection_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

// List of reflections with empty, loading and error states.
class ReflectionsListView extends StatelessWidget {
  // Creates the list.
  const ReflectionsListView({super.key});

  // Builds the list for the current reflections state.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReflectionsCubit, ReflectionsState>(
      builder: (context, state) {
        if (state is ReflectionsError) {
          return StateMessageView(message: state.message, onRetry: ReflectionsCubit.get(context).load);
        }
        if (state is ReflectionsSuccess && state.reflections.isEmpty) {
          return const StateMessageView(message: TextManager.noReflections, hint: TextManager.noReflectionsHint);
        }
        final reflections =
            state is ReflectionsSuccess ? state.reflections : List.generate(3, (_) => ReflectionModel.dummy());
        return Skeletonizer(
          enabled: state is! ReflectionsSuccess,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
            itemCount: reflections.length,
            separatorBuilder: (_, __) => verticalSpace(12.h),
            itemBuilder: (_, i) => ReflectionTile(
              key: ValueKey('${reflections[i].surahNumber}:${reflections[i].ayahNumber}'),
              reflection: reflections[i],
            ),
          ),
        );
      },
    );
  }
}
