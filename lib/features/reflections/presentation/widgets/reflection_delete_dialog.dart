import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Asks the user to confirm deleting a reflection and returns true when confirmed.
Future<bool> showReflectionDeleteDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => const ReflectionDeleteDialog(),
  );
  return confirmed ?? false;
}

// Confirmation dialog shown before a reflection is deleted.
class ReflectionDeleteDialog extends StatelessWidget {
  // Creates the dialog.
  const ReflectionDeleteDialog({super.key});

  // Builds the title, warning and the cancel and delete actions.
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      title:
          CustomText(text: TextManager.deleteReflectionTitle, style: getBoldStyle(context: context, fontSize: 17.sp)),
      content: CustomText(
        text: TextManager.deleteReflectionBody,
        style: getRegularStyle(context: context, fontSize: 14.sp, color: ColorsManager.grey),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: CustomText(
              text: TextManager.cancel, style: getSemiBoldStyle(context: context, color: ColorsManager.grey)),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: CustomText(
            text: TextManager.deleteReflection,
            style: getSemiBoldStyle(context: context, color: ColorsManager.red),
          ),
        ),
      ],
    );
  }
}
