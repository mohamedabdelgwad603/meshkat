import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_state.dart';

// Bottom bar with the start-session button and the self-test button.
class HifzSetupActions extends StatelessWidget {
  // Creates the bar.
  const HifzSetupActions({super.key});

  // Builds the two buttons, disabled until the setup has loaded.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HifzSetupCubit, HifzSetupState>(
      builder: (context, state) {
        final data = state is HifzSetupSuccess ? state.data : null;
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
          decoration: BoxDecoration(
            color: ColorsManager.surface,
            boxShadow: [BoxShadow(color: ColorsManager.shadow, blurRadius: 20.r, offset: Offset(0, -6.h))],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: data == null ? null : () => _open(context, PageName.hifzTest, data),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, 52.h),
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: ColorsManager.primary),
                  ),
                  child: _buildLabel(context, Icons.quiz_outlined, TextManager.hifzTest, ColorsManager.primary),
                ),
              ),
              horizontalSpace(10.w),
              Expanded(
                child: FilledButton(
                  onPressed: data == null ? null : () => _open(context, PageName.hifzSession, data),
                  style: FilledButton.styleFrom(
                    backgroundColor: ColorsManager.primary,
                    minimumSize: Size(0, 52.h),
                    shape: const StadiumBorder(),
                  ),
                  child: _buildLabel(context, Icons.play_arrow_rounded, TextManager.hifzStart, ColorsManager.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds an icon and a label for a button.
  Widget _buildLabel(BuildContext context, IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20.r, color: color == ColorsManager.white ? ColorsManager.secondry : color),
        horizontalSpace(6.w),
        Flexible(
          child: CustomText(
            text: label,
            maxLines: 1,
            style: getBoldStyle(context: context, fontSize: 14.sp, color: color),
          ),
        ),
      ],
    );
  }

  // Opens a session or test on the chosen range.
  void _open(BuildContext context, String page, HifzSetupData data) => context.pushNamed(page, arguments: data.params);
}
