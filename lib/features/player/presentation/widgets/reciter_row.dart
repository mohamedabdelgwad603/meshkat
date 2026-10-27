import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';
import 'package:mishkat/features/player/presentation/cubit/player_state.dart';
import 'package:mishkat/features/player/presentation/widgets/reciter_picker_sheet.dart';

// Reciter avatar, name, riwaya and the change-reciter button.
class ReciterRow extends StatelessWidget {
  // Creates the row.
  const ReciterRow({super.key});

  // Builds the row from the loaded reciter.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return BlocBuilder<PlayerCubit, PlayerState>(
      buildWhen: (a, b) => b is PlayerSuccess && (a is! PlayerSuccess || a.data.reciter != b.data.reciter),
      builder: (context, state) {
        final data = state is PlayerSuccess ? state.data : PlayerData.dummy();
        return Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: ColorsManager.secondry,
              child: CustomText(
                text: data.reciter.initial(isArabic),
                translate: false,
                style: getBoldStyle(
                  context: context,
                  fontSize: 20.sp,
                  color: ColorsManager.primary,
                  fontFamily: FontManager.heading,
                ),
              ),
            ),
            horizontalSpace(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: data.reciter.displayName(isArabic),
                    translate: false,
                    maxLines: 1,
                    style: getBoldStyle(context: context, fontSize: 17.sp, color: ColorsManager.white),
                  ),
                  CustomText(
                    text: TextManager.riwaya,
                    style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.mutedOnDark),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => _pickReciter(context, data),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(0, 40.h),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                side: const BorderSide(color: ColorsManager.goldBorder),
                shape: const StadiumBorder(),
              ),
              child: CustomText(
                text: TextManager.changeReciter,
                style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.secondry),
              ),
            ),
          ],
        );
      },
    );
  }

  // Opens the reciter picker and switches to the chosen reciter.
  Future<void> _pickReciter(BuildContext context, PlayerData data) async {
    final cubit = PlayerCubit.get(context);
    await cubit.loadReciters();
    if (!context.mounted) return;
    final current = cubit.state;
    final reciters = current is PlayerSuccess ? current.data.reciters : data.reciters;
    final picked = await showReciterPicker(context, reciters: reciters, selectedId: data.reciter.identifier);
    if (picked != null) await cubit.changeReciter(picked);
  }
}
