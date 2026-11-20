import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_index_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_index_state.dart';

// Tappable strip in the ayah panel, shown only when the ayah has similar phrases.
class MutashabihatBanner extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;

  // Creates the strip for the given ayah.
  const MutashabihatBanner({super.key, required this.surahNumber, required this.ayahNumber});

  // Builds the strip, or nothing when the ayah has no similar phrases.
  @override
  Widget build(BuildContext context) {
    return BlocSelector<MutashabihatIndexCubit, MutashabihatIndexState, bool>(
      selector: (state) => state is MutashabihatIndexSuccess && state.has(surahNumber, ayahNumber),
      builder: (context, hasPhrases) {
        if (!hasPhrases) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Material(
            color: ColorsManager.goldOverlay,
            borderRadius: BorderRadius.circular(16.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () => context.pushNamed(
                PageName.mutashabihat,
                arguments: MutashabihatArgs(surahNumber: surahNumber, ayahNumber: ayahNumber),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Row(
                  children: [
                    Icon(Icons.compare_arrows_rounded, size: 20.r, color: ColorsManager.secondryDark),
                    horizontalSpace(8.w),
                    Expanded(
                      child: CustomText(
                        text: TextManager.mutashabihatBanner,
                        maxLines: 1,
                        style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.secondryDark),
                      ),
                    ),
                    CustomText(
                      text: TextManager.mutashabihatView,
                      style: getBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.primary),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 18.r, color: ColorsManager.primary),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
