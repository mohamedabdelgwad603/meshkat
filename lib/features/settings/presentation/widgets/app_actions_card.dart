import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/share_text.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_card.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_link_tile.dart';

// Card with the share and rate actions of the app.
class AppActionsCard extends StatelessWidget {
  // Creates the card.
  const AppActionsCard({super.key});

  // Builds the two action rows separated by a divider.
  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Column(
        children: [
          Builder(
            builder: (tileContext) => SettingsLinkTile(
              icon: Icons.share_outlined,
              title: TextManager.shareApp,
              onTap: () => _shareApp(tileContext),
            ),
          ),
          Divider(height: 16.h, color: ColorsManager.greyLight),
          SettingsLinkTile(
            icon: Icons.star_outline_rounded,
            title: TextManager.rateApp,
            onTap: () => _rateApp(context),
          ),
        ],
      ),
    );
  }

  // Shares this platform's store link with a short description of the app.
  Future<void> _shareApp(BuildContext context) async {
    final result = await SettingsCubit.get(context).getStoreUrl();
    if (!context.mounted) return;
    result.fold(
      (message) => _showError(context, message),
      (url) => shareText(context, TextManager.shareAppMessage.tr(context: context, args: [url])),
    );
  }

  // Opens the app's review page on the store.
  Future<void> _rateApp(BuildContext context) async {
    final error = await SettingsCubit.get(context).rateApp();
    if (error != null && context.mounted) _showError(context, error);
  }

  // Shows a translated error message in a snack bar.
  void _showError(BuildContext context, String message) {
    context.showSnack(CustomText(
      text: message,
      style: getMediumStyle(context: context, color: ColorsManager.white),
    ));
  }
}
