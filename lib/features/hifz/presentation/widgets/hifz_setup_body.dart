import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_state.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_options_card.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_progress_banner.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_range_card.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_setup_actions.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_top_bar.dart';
import 'package:mishkat/features/settings/presentation/widgets/reciter_setting_tile.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Setup page: surah and range, reciter, repeat options and the start buttons pinned at the bottom.
class HifzSetupBody extends StatelessWidget {
  // Creates the body.
  const HifzSetupBody({super.key});

  // Builds the page for the current setup state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.greyBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 20.w, 4.h),
              child: const HifzTopBar(title: TextManager.hifzTitle, subtitle: TextManager.hifzSubtitle),
            ),
            Expanded(
              child: BlocBuilder<HifzSetupCubit, HifzSetupState>(
                buildWhen: (a, b) => a.runtimeType != b.runtimeType,
                builder: (context, state) {
                  if (state is HifzSetupError) {
                    return StateMessageView(message: state.message, onRetry: HifzSetupCubit.get(context).retry);
                  }
                  return Skeletonizer(
                    enabled: state is! HifzSetupSuccess,
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                      children: [
                        const HifzRangeCard(),
                        verticalSpace(12.h),
                        const HifzProgressBanner(),
                        verticalSpace(12.h),
                        const SettingsCard(child: ReciterSettingTile()),
                        verticalSpace(12.h),
                        const HifzOptionsCard(),
                      ],
                    ),
                  );
                },
              ),
            ),
            const HifzSetupActions(),
          ],
        ),
      ),
    );
  }
}
