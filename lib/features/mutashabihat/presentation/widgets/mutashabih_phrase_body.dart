import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_details_model.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabih_phrase_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabih_phrase_state.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabih_occurrence_tile.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabihat_top_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Phrase page: the phrase with its counts, then every ayah it appears in with the phrase shaded.
class MutashabihPhraseBody extends StatelessWidget {
  // Creates the body.
  const MutashabihPhraseBody({super.key});

  // Builds the page for the current phrase state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.greyBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MutashabihatTopBar(title: TextManager.mutashabihatTitle),
            Expanded(
              child: BlocBuilder<MutashabihPhraseCubit, MutashabihPhraseState>(
                builder: (context, state) {
                  if (state is MutashabihPhraseError) {
                    return StateMessageView(message: state.message, onRetry: MutashabihPhraseCubit.get(context).retry);
                  }
                  final phrase = state is MutashabihPhraseSuccess ? state.phrase : MutashabihPhraseDetailsModel.dummy();
                  return Skeletonizer(
                    enabled: state is! MutashabihPhraseSuccess,
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                      itemCount: phrase.otherAyahs.length + 1,
                      separatorBuilder: (_, __) => verticalSpace(10.h),
                      itemBuilder: (_, i) => i == 0
                          ? _buildHeader(context, phrase)
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: ColorsManager.surface,
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(color: ColorsManager.greyLight),
                              ),
                              child: MutashabihOccurrenceTile(ayah: phrase.otherAyahs[i - 1]),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the gold card with the phrase and how often it repeats.
  Widget _buildHeader(BuildContext context, MutashabihPhraseDetailsModel phrase) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: ColorsManager.primary, borderRadius: BorderRadius.circular(22.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: phrase.text,
            translate: false,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: getRegularStyle(
              context: context,
              fontSize: 24.sp,
              height: 1.9,
              color: ColorsManager.secondry,
              fontFamily: FontManager.quran,
            ),
          ),
          verticalSpace(6.h),
          CustomText(
            text: TextManager.mutashabihatStats,
            args: [localizedDigits(context, phrase.ayahCount), localizedDigits(context, phrase.surahCount)],
            textAlign: TextAlign.center,
            style: getMediumStyle(context: context, fontSize: 13.sp, color: ColorsManager.mutedOnDark),
          ),
        ],
      ),
    );
  }
}
