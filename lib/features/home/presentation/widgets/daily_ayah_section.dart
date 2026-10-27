import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/home/data/models/daily_ayah_model.dart';
import 'package:mishkat/features/home/presentation/cubit/home_cubit.dart';
import 'package:mishkat/features/home/presentation/cubit/home_state.dart';
import 'package:mishkat/features/home/presentation/widgets/daily_ayah_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Section title plus the ayah-of-the-day card with loading and error states.
class DailyAyahSection extends StatelessWidget {
  // Creates the section.
  const DailyAyahSection({super.key});

  // Builds the title row and the card for the current state.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: TextManager.dailyAyah,
                  style: getBoldStyle(context: context, fontSize: 17.sp),
                ),
              ),
              IslamicStar(size: 22.r, color: ColorsManager.secondry, strokeWidth: 1.6),
            ],
          ),
          verticalSpace(12.h),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeError) {
                return StateMessageView(
                  message: state.message,
                  onRetry: () => HomeCubit.get(context).loadDailyAyah(),
                );
              }
              final ayah = state is HomeSuccess ? state.dailyAyah : DailyAyahModel.dummy();
              return Skeletonizer(
                enabled: state is! HomeSuccess,
                child: DailyAyahCard(ayah: ayah),
              );
            },
          ),
        ],
      ),
    );
  }
}
