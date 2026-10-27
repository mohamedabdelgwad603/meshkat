import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/app_update/data/models/app_update_model.dart';
import 'package:mishkat/features/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:mishkat/features/app_update/presentation/widgets/app_update_actions.dart';
import 'package:mishkat/features/app_update/presentation/widgets/app_update_header.dart';
import 'package:mishkat/features/app_update/presentation/widgets/app_update_versions_row.dart';

// Opens the update sheet; a forced update cannot be dismissed.
Future<void> showAppUpdateSheet(BuildContext context, AppUpdateModel update) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: !update.forceUpdate,
    enableDrag: !update.forceUpdate,
    showDragHandle: !update.forceUpdate,
    backgroundColor: ColorsManager.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28.r))),
    builder: (_) => BlocProvider.value(
      value: AppUpdateCubit.get(context),
      child: AppUpdateSheet(update: update),
    ),
  );
}

// Update sheet content: branded header, message, versions and actions.
class AppUpdateSheet extends StatelessWidget {
  final AppUpdateModel update;

  // Creates the sheet content.
  const AppUpdateSheet({super.key, required this.update});

  // Builds the sheet and blocks the back button when the update is forced.
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !update.forceUpdate,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, update.forceUpdate ? 24.h : 0, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppUpdateHeader(),
              verticalSpace(20.h),
              CustomText(
                text: TextManager.updateTitle,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  context: context,
                  fontSize: 22.sp,
                  color: ColorsManager.primary,
                  fontFamily: FontManager.heading,
                ),
              ),
              verticalSpace(8.h),
              CustomText(
                text: update.forceUpdate ? TextManager.updateRequiredBody : TextManager.updateBody,
                textAlign: TextAlign.center,
                style: getRegularStyle(context: context, fontSize: 14.sp, color: ColorsManager.grey, height: 1.6),
              ),
              verticalSpace(18.h),
              AppUpdateVersionsRow(currentVersion: update.currentVersion, latestVersion: update.latestVersion),
              verticalSpace(24.h),
              AppUpdateActions(forceUpdate: update.forceUpdate),
            ],
          ),
        ),
      ),
    );
  }
}
