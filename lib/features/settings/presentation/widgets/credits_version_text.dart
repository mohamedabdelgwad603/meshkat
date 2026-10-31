import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_state.dart';

// Shows the installed app version at the bottom of the credits page.
class CreditsVersionText extends StatelessWidget {
  // Creates the version text.
  const CreditsVersionText({super.key});

  // Builds the version label once the settings have loaded it.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final version = state is SettingsSuccess ? state.data.appVersion : '';
        if (version.isEmpty) return const SizedBox.shrink();
        return CustomText(
          text: TextManager.version,
          args: [version],
          textAlign: TextAlign.center,
          style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
        );
      },
    );
  }
}
