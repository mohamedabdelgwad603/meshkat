import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';

// Opens a bottom sheet listing reciters and returns the one the user picks.
Future<ReciterModel?> showReciterPicker(
  BuildContext context, {
  required List<ReciterModel> reciters,
  required String selectedId,
}) {
  return showModalBottomSheet<ReciterModel>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28.r))),
    builder: (_) => ReciterPickerSheet(reciters: reciters, selectedId: selectedId),
  );
}

// List of reciters with the current one marked.
class ReciterPickerSheet extends StatelessWidget {
  final List<ReciterModel> reciters;
  final String selectedId;

  // Creates the sheet.
  const ReciterPickerSheet({super.key, required this.reciters, required this.selectedId});

  // Builds the title and the reciter list.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomText(
                text: TextManager.chooseReciter,
                style: getBoldStyle(context: context, fontSize: 18.sp, color: ColorsManager.primary),
              ),
            ),
            verticalSpace(8.h),
            Expanded(
              child: reciters.isEmpty
                  ? const StateMessageView(message: TextManager.errorNoInternet)
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
                      itemCount: reciters.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final reciter = reciters[i];
                        final selected = reciter.identifier == selectedId;
                        return ListTile(
                          onTap: () => context.pop(reciter),
                          selected: selected,
                          leading: CircleAvatar(
                            backgroundColor: selected ? ColorsManager.secondry : ColorsManager.primaryLight,
                            child: CustomText(
                              text: reciter.initial(isArabic),
                              translate: false,
                              style: getBoldStyle(
                                context: context,
                                fontSize: 18.sp,
                                color: ColorsManager.primary,
                                fontFamily: FontManager.heading,
                              ),
                            ),
                          ),
                          title: CustomText(
                            text: reciter.displayName(isArabic),
                            translate: false,
                            style: getSemiBoldStyle(context: context, fontSize: 15.sp),
                          ),
                          trailing: selected
                              ? Icon(Icons.check_circle_rounded, color: ColorsManager.secondry, size: 22.r)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
