import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_state.dart';
import 'package:mishkat/features/settings/presentation/widgets/language_selector.dart';
import 'package:mishkat/features/settings/presentation/widgets/quran_font_size_control.dart';
import 'package:mishkat/features/settings/presentation/widgets/reciter_setting_tile.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_card.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_link_tile.dart';

// Scrollable list of settings cards.
class SettingsBody extends StatelessWidget {
  // Creates the body.
  const SettingsBody({super.key});

  // Builds the title and cards for the current settings state.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsError) {
            return StateMessageView(message: state.message, onRetry: SettingsCubit.get(context).load);
          }
          return ListView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            children: [
              CustomText(
                text: TextManager.settingsTitle,
                style: getBoldStyle(
                  context: context,
                  fontSize: 30.sp,
                  color: ColorsManager.primary,
                  fontFamily: FontManager.heading,
                  height: 1.2,
                ),
              ),
              verticalSpace(20.h),
              const SettingsCard(child: LanguageSelector()),
              verticalSpace(12.h),
              const SettingsCard(child: QuranFontSizeControl()),
              verticalSpace(12.h),
              const SettingsCard(child: ReciterSettingTile()),
              verticalSpace(12.h),
              SettingsCard(
                child: SettingsLinkTile(
                  icon: Icons.verified_outlined,
                  title: TextManager.sourcesTitle,
                  onTap: () => context.pushNamed(PageName.credits),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
