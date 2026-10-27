import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_state.dart';

// Bottom bar with previous and next ayah buttons.
class TafsirNavBar extends StatelessWidget {
  // Creates the bar.
  const TafsirNavBar({super.key});

  // Builds the two buttons, disabled at the surah edges.
  @override
  Widget build(BuildContext context) {
    final cubit = TafsirCubit.get(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: ColorsManager.surface,
        border: Border(top: BorderSide(color: ColorsManager.greyLight)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 14.h),
        child: BlocBuilder<TafsirCubit, TafsirState>(
          builder: (context, state) {
            final success = state is TafsirSuccess ? state : null;
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: success?.hasPrevious ?? false ? cubit.previousAyah : null,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 48.h),
                      side: const BorderSide(color: ColorsManager.greyLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      foregroundColor: ColorsManager.primary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded, size: 14.r),
                        horizontalSpace(8.w),
                        CustomText(
                          text: TextManager.prevAyah,
                          style: getSemiBoldStyle(context: context, color: ColorsManager.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalSpace(12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: success?.hasNext ?? false ? cubit.nextAyah : null,
                    style: FilledButton.styleFrom(
                      minimumSize: Size(0, 48.h),
                      backgroundColor: ColorsManager.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: TextManager.nextAyah,
                          style: getSemiBoldStyle(context: context, color: ColorsManager.white),
                        ),
                        horizontalSpace(8.w),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14.r, color: ColorsManager.white),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
