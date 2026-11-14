import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_card.dart';
import 'package:mishkat/features/settings/presentation/widgets/social_icon_button.dart';

// Card with the Instagram and Facebook buttons for reaching the team.
class SocialLinksCard extends StatelessWidget {
  // Creates the card.
  const SocialLinksCard({super.key});

  // Builds the title, subtitle and the row of social buttons.
  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Column(
        children: [
          CustomText(text: TextManager.contactUs, style: getSemiBoldStyle(context: context)),
          verticalSpace(4.h),
          CustomText(
            text: TextManager.contactUsSubtitle,
            style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
          ),
          verticalSpace(14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SocialIconButton(
                icon: FontAwesomeIcons.instagram,
                label: TextManager.instagram,
                background: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    ColorsManager.instagramYellow,
                    ColorsManager.instagramOrange,
                    ColorsManager.instagramPink,
                    ColorsManager.instagramPurple,
                    ColorsManager.instagramBlue,
                  ],
                ),
                onTap: () => _open(context, EndPoints.instagramPage),
              ),
              SocialIconButton(
                icon: FontAwesomeIcons.facebookF,
                label: TextManager.facebook,
                background: const LinearGradient(colors: [ColorsManager.facebook, ColorsManager.facebook]),
                onTap: () => _open(context, EndPoints.facebookPage),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Opens a social media page outside the app.
  Future<void> _open(BuildContext context, String url) async {
    final error = await SettingsCubit.get(context).openLink(url);
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
