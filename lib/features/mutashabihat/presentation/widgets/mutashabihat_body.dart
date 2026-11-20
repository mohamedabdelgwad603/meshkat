import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_details_model.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_state.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabih_phrase_card.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabihat_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Page with the title, the opened ayah and one card per similar phrase.
class MutashabihatBody extends StatelessWidget {
  // Creates the body.
  const MutashabihatBody({super.key});

  // Builds the page for the current state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.greyBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 20.w, 4.h),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: Icons.arrow_back_rounded,
                    semanticLabel: TextManager.backAction,
                    onPressed: () => context.pop(),
                  ),
                  horizontalSpace(8.w),
                  CustomText(
                    text: TextManager.mutashabihatTitle,
                    style: getBoldStyle(
                      context: context,
                      fontSize: 20.sp,
                      color: ColorsManager.primary,
                      fontFamily: FontManager.heading,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<MutashabihatCubit, MutashabihatState>(
                builder: (context, state) {
                  if (state is MutashabihatError) {
                    return StateMessageView(message: state.message, onRetry: MutashabihatCubit.get(context).retry);
                  }
                  final result = state is MutashabihatSuccess ? state.result : MutashabihatResultModel.dummy();
                  if (state is MutashabihatSuccess && result.phrases.isEmpty) {
                    return const StateMessageView(message: TextManager.noMutashabihat);
                  }
                  return Skeletonizer(
                    enabled: state is! MutashabihatSuccess,
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                      itemCount: result.phrases.length + 1,
                      separatorBuilder: (_, __) => verticalSpace(12.h),
                      itemBuilder: (_, i) => i == 0
                          ? MutashabihatHeader(ayah: result.ayah)
                          : MutashabihPhraseCard(phrase: result.phrases[i - 1]),
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
}
