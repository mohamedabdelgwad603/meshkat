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

// Small tag warning that an ayah has similar phrases, opening them when tapped.
class MutashabihatBadge extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;

  // Creates the tag for the given ayah.
  const MutashabihatBadge({super.key, required this.surahNumber, required this.ayahNumber});

  // Builds the tag, or nothing when the ayah has no similar phrases.
  @override
  Widget build(BuildContext context) {
    return BlocSelector<MutashabihatIndexCubit, MutashabihatIndexState, bool>(
      selector: (state) => state is MutashabihatIndexSuccess && state.has(surahNumber, ayahNumber),
      builder: (context, hasPhrases) {
        if (!hasPhrases) return const SizedBox.shrink();
        return InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => context.pushNamed(
            PageName.mutashabihat,
            arguments: MutashabihatArgs(surahNumber: surahNumber, ayahNumber: ayahNumber),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(color: ColorsManager.goldOverlay, borderRadius: BorderRadius.circular(12.r)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.compare_arrows_rounded, size: 14.r, color: ColorsManager.secondryDark),
                horizontalSpace(4.w),
                CustomText(
                  text: TextManager.mutashabihatBadge,
                  style: getSemiBoldStyle(context: context, fontSize: 11.sp, color: ColorsManager.secondryDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
