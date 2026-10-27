import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';

// Player top bar: minimize button and the "now playing" label.
class PlayerTopBar extends StatelessWidget {
  // Creates the top bar.
  const PlayerTopBar({super.key});

  // Builds the bar.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          RoundIconButton(
            icon: Icons.keyboard_arrow_down_rounded,
            semanticLabel: TextManager.minimizePlayer,
            iconColor: ColorsManager.white,
            iconSize: 26,
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: CustomText(
              text: TextManager.nowPlaying,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(context: context, color: ColorsManager.mutedOnDark),
            ),
          ),
          SizedBox.square(dimension: 44.r),
        ],
      ),
    );
  }
}
