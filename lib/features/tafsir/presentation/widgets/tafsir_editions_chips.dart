import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_state.dart';

// Horizontally scrolling chips to choose the tafsir book.
class TafsirEditionsChips extends StatelessWidget {
  // Creates the chip row.
  const TafsirEditionsChips({super.key});

  // Builds one chip per tafsir book.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return BlocBuilder<TafsirCubit, TafsirState>(
      buildWhen: (a, b) => b is TafsirSuccess,
      builder: (context, state) {
        final success = state is TafsirSuccess ? state : null;
        final editions = success?.editions ?? List.generate(4, (_) => TafsirEditionModel.dummy());
        return Semantics(
          label: TextManager.tafsirSources.tr(context: context),
          container: true,
          child: SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: editions.length,
            separatorBuilder: (_, __) => horizontalSpace(8.w),
            itemBuilder: (_, i) {
              final edition = editions[i];
              final selected = edition.identifier == success?.selectedEdition;
              return _EditionChip(
                label: edition.label(isArabic),
                selected: selected,
                onTap: () => TafsirCubit.get(context).selectEdition(edition.identifier),
              );
            },
          ),
          ),
        );
      },
    );
  }
}

// One tafsir book chip.
class _EditionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  // Creates the chip.
  const _EditionChip({required this.label, required this.selected, required this.onTap});

  // Builds a filled or outlined stadium chip.
  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? ColorsManager.primary : ColorsManager.surface,
        shape: StadiumBorder(side: BorderSide(color: selected ? ColorsManager.primary : ColorsManager.greyLight)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Center(
              child: CustomText(
                text: label,
                translate: false,
                style: selected
                    ? getSemiBoldStyle(context: context, color: ColorsManager.white)
                    : getMediumStyle(context: context, color: ColorsManager.darkLight),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
