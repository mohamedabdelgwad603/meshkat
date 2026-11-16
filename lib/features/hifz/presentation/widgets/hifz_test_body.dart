import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/hifz/data/models/hifz_session_model.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_state.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_test_ayah_card.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_test_header.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_test_summary.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_top_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Test page: instructions and hint switch, one card per hidden ayah and the score bar at the bottom.
class HifzTestBody extends StatelessWidget {
  // Creates the body.
  const HifzTestBody({super.key});

  // Builds the page for the current test state.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: ColorsManager.greyBackground,
      body: SafeArea(
        child: BlocBuilder<HifzTestCubit, HifzTestState>(
          builder: (context, state) {
            final data = state is HifzTestSuccess ? state.data : _placeholder;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 8.h, 20.w, 4.h),
                  child: HifzTopBar(
                    title: TextManager.hifzTest,
                    subtitle: data.session.displaySurah(isArabic),
                    translateSubtitle: false,
                  ),
                ),
                Expanded(child: _buildContent(context, state, data)),
                if (state is HifzTestSuccess) HifzTestSummary(data: data),
              ],
            );
          },
        ),
      ),
    );
  }

  // Builds the error view or the list of ayah cards.
  Widget _buildContent(BuildContext context, HifzTestState state, HifzTestData data) {
    if (state is HifzTestError) {
      return StateMessageView(message: state.message, onRetry: HifzTestCubit.get(context).retry);
    }
    return Skeletonizer(
      enabled: state is! HifzTestSuccess,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
        itemCount: data.session.ayahs.length + 1,
        separatorBuilder: (_, __) => verticalSpace(12.h),
        itemBuilder: (_, i) => i == 0
            ? HifzTestHeader(firstWordHint: data.firstWordHint)
            : HifzTestAyahCard(
                key: ValueKey(data.session.ayahs[i - 1].ayahNumber),
                index: i - 1,
                data: data,
              ),
      ),
    );
  }

  // Returns placeholder test data for the loading skeleton.
  static final HifzTestData _placeholder = HifzTestData(
    session: HifzSessionModel.dummy(),
    revealedWords: const [1, 1, 1],
    results: const {},
    firstWordHint: true,
  );
}
