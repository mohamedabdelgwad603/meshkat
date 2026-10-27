import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/features/home/presentation/cubit/home_cubit.dart';
import 'package:mishkat/features/home/presentation/widgets/continue_reading_card.dart';
import 'package:mishkat/features/home/presentation/widgets/daily_ayah_section.dart';
import 'package:mishkat/features/home/presentation/widgets/home_header.dart';
import 'package:mishkat/features/home/presentation/widgets/quick_actions_row.dart';

// Scrollable home layout with the card overlapping the green header.
class HomeBody extends StatelessWidget {
  // Creates the home body.
  const HomeBody({super.key});

  // Builds the header and the stacked content below it.
  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final headerHeight = topInset + 160.h;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RefreshIndicator(
        onRefresh: () => HomeCubit.get(context).loadDailyAyah(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              HomeHeader(height: headerHeight),
              Padding(
                padding: EdgeInsets.only(top: headerHeight - 64.h),
                child: Column(
                  children: [
                    const ContinueReadingCard(),
                    verticalSpace(24.h),
                    const QuickActionsRow(),
                    verticalSpace(28.h),
                    const DailyAyahSection(),
                    verticalSpace(24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
