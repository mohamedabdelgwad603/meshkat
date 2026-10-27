import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_state.dart';
import 'package:mishkat/features/tafsir/presentation/widgets/tafsir_ayah_card.dart';
import 'package:mishkat/features/tafsir/presentation/widgets/tafsir_editions_chips.dart';
import 'package:mishkat/features/tafsir/presentation/widgets/tafsir_nav_bar.dart';
import 'package:mishkat/features/tafsir/presentation/widgets/tafsir_text_card.dart';
import 'package:mishkat/features/tafsir/presentation/widgets/tafsir_top_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Tafsir layout: top bar, ayah card, book chips, tafsir text and ayah navigation.
class TafsirBody extends StatelessWidget {
  final TafsirArgs args;

  // Creates the body.
  const TafsirBody({super.key, required this.args});

  // Builds the layout for the current tafsir state.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const TafsirTopBar(),
              Expanded(
                child: BlocBuilder<TafsirCubit, TafsirState>(
                  builder: (context, state) {
                    if (state is TafsirError) {
                      return StateMessageView(
                        message: state.message,
                        onRetry: () => TafsirCubit.get(context).init(args.surahNumber, args.ayahNumber),
                      );
                    }
                    return Skeletonizer(
                      enabled: state is! TafsirSuccess,
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                        children: [
                          const TafsirAyahCard(),
                          verticalSpace(16.h),
                          const TafsirEditionsChips(),
                          verticalSpace(16.h),
                          const TafsirTextCard(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const TafsirNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}
