import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_model.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Card with the tafsir book name and its text for the current ayah.
class TafsirTextCard extends StatelessWidget {
  // Creates the card.
  const TafsirTextCard({super.key});

  // Builds the card for the current tafsir loading state.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return BlocBuilder<TafsirCubit, TafsirState>(
      builder: (context, state) {
        final success = state is TafsirSuccess ? state : null;
        final edition = success?.selectedEditionModel ?? TafsirEditionModel.dummy();
        final tafsir = success?.tafsir;
        return Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: ColorsManager.surface,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: ColorsManager.greyLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomText(
                text: isArabic ? edition.name : edition.englishName,
                translate: false,
                style: getBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.secondryDark),
              ),
              verticalSpace(10.h),
              if (success?.tafsirError != null)
                StateMessageView(message: success!.tafsirError!, onRetry: TafsirCubit.get(context).retryTafsir)
              else
                Skeletonizer(
                  enabled: tafsir == null,
                  child: CustomText(
                    text: (tafsir ?? TafsirModel.dummy()).text,
                    translate: false,
                    textDirection: TextDirection.rtl,
                    style: getRegularStyle(context: context, fontSize: 16.sp, height: 2),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
