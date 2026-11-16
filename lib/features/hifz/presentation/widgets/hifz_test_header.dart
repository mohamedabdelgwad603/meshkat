import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_cubit.dart';

// How the test works and a switch for showing the first word of each ayah as a hint.
class HifzTestHeader extends StatelessWidget {
  final bool firstWordHint;

  // Creates the header.
  const HifzTestHeader({super.key, required this.firstWordHint});

  // Builds the instruction and the hint switch.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 10.h, 6.w, 10.h),
      decoration: BoxDecoration(color: ColorsManager.primaryLight, borderRadius: BorderRadius.circular(18.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 18.r, color: ColorsManager.secondryDark),
              horizontalSpace(8.w),
              Expanded(
                child: CustomText(
                  text: TextManager.hifzTestHint,
                  style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.primary, height: 1.5),
                ),
              ),
            ],
          ),
          Row(
            children: [
              horizontalSpace(26.w),
              Expanded(
                child: CustomText(
                  text: TextManager.hifzFirstWordHint,
                  style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.primary),
                ),
              ),
              Switch.adaptive(
                value: firstWordHint,
                activeTrackColor: ColorsManager.primary,
                onChanged: (_) => HifzTestCubit.get(context).toggleHint(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
