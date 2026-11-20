import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_summary_model.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_state.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabih_phrase_tile.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabihat_browse_filters.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabihat_top_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Browse page: title, filters and the list of every similar phrase.
class MutashabihatBrowseBody extends StatelessWidget {
  // Creates the body.
  const MutashabihatBrowseBody({super.key});

  // Builds the page for the current browse state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.greyBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MutashabihatTopBar(title: TextManager.mutashabihatBrowseTitle),
            Expanded(
              child: BlocBuilder<MutashabihatBrowseCubit, MutashabihatBrowseState>(
                builder: (context, state) {
                  if (state is MutashabihatBrowseError) {
                    return StateMessageView(message: state.message, onRetry: MutashabihatBrowseCubit.get(context).load);
                  }
                  if (state is! MutashabihatBrowseSuccess) return _buildSkeleton();
                  final data = state.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MutashabihatBrowseFilters(data: data),
                      Expanded(
                        child: data.visible.isEmpty
                            ? const StateMessageView(message: TextManager.noMutashabihatResults)
                            : ListView.separated(
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                                itemCount: data.visible.length,
                                separatorBuilder: (_, __) => verticalSpace(10.h),
                                itemBuilder: (_, i) => MutashabihPhraseTile(
                                  key: ValueKey(data.visible[i].id),
                                  phrase: data.visible[i],
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds placeholder rows while the phrases load.
  Widget _buildSkeleton() {
    return Skeletonizer(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
        itemCount: 6,
        separatorBuilder: (_, __) => verticalSpace(10.h),
        itemBuilder: (_, __) => MutashabihPhraseTile(phrase: MutashabihPhraseSummaryModel.dummy()),
      ),
    );
  }
}
