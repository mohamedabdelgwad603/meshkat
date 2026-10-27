import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/app_update/presentation/cubit/app_update_cubit.dart';

// "Update now" button and, unless the update is forced, a "later" button.
class AppUpdateActions extends StatelessWidget {
  final bool forceUpdate;

  // Creates the actions.
  const AppUpdateActions({super.key, required this.forceUpdate});

  // Builds the primary store button and the optional dismiss button.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: AppUpdateCubit.get(context).openStore,
          style: FilledButton.styleFrom(
            backgroundColor: ColorsManager.primary,
            foregroundColor: ColorsManager.white,
            minimumSize: Size(0, 52.h),
            shape: const StadiumBorder(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.system_update_alt_rounded, size: 20.r, color: ColorsManager.secondry),
              horizontalSpace(8.w),
              CustomText(
                text: TextManager.updateNow,
                style: getBoldStyle(context: context, fontSize: 15.sp, color: ColorsManager.white),
              ),
            ],
          ),
        ),
        if (!forceUpdate) ...[
          verticalSpace(6.h),
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(minimumSize: Size(0, 44.h), shape: const StadiumBorder()),
            child: CustomText(
              text: TextManager.updateLater,
              style: getSemiBoldStyle(context: context, color: ColorsManager.grey),
            ),
          ),
        ],
      ],
    );
  }
}
