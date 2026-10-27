import 'package:easy_localization/easy_localization.dart' hide TextDirection;
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
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_model.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Two-line tafsir excerpt for the selected ayah that opens the full tafsir.
class TafsirPreviewCard extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;

  // Creates the preview card.
  const TafsirPreviewCard({super.key, required this.surahNumber, required this.ayahNumber});

  // Builds the excerpt from the tafsir state.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Material(
      color: ColorsManager.greyBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: const BorderSide(color: ColorsManager.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.pushNamed(
          PageName.tafsir,
          arguments: TafsirArgs(surahNumber: surahNumber, ayahNumber: ayahNumber),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: BlocBuilder<TafsirCubit, TafsirState>(
            builder: (context, state) {
              final success = state is TafsirSuccess ? state : null;
              final edition = success?.selectedEditionModel ?? TafsirEditionModel.dummy();
              final tafsir = success?.tafsir;
              final failed = state is TafsirError || success?.tafsirError != null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: edition.label(isArabic),
                    translate: false,
                    style: getSemiBoldStyle(context: context, fontSize: 12.sp, color: ColorsManager.secondryDark),
                  ),
                  verticalSpace(6.h),
                  if (failed)
                    CustomText(
                      text: success?.tafsirError ?? (state as TafsirError).message,
                      style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.grey),
                    )
                  else
                    Skeletonizer(
                      enabled: tafsir == null,
                      child: CustomText(
                        text: (tafsir ?? TafsirModel.dummy()).text,
                        translate: false,
                        maxLines: 2,
                        textDirection: TextDirection.rtl,
                        style: getRegularStyle(context: context, fontSize: 14.sp, height: 1.8),
                      ),
                    ),
                  verticalSpace(6.h),
                  CustomText(
                    text: TextManager.readFullTafsir,
                    style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.primary),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
