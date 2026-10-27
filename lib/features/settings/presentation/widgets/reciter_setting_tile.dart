import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/player/presentation/widgets/reciter_picker_sheet.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_state.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_link_tile.dart';

// Row showing the default reciter that opens the reciter picker.
class ReciterSettingTile extends StatelessWidget {
  // Creates the row.
  const ReciterSettingTile({super.key});

  // Builds the row from the settings state.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final data = state is SettingsSuccess ? state.data : null;
        return SettingsLinkTile(
          icon: Icons.record_voice_over_outlined,
          title: TextManager.defaultReciter,
          value: data?.reciter.displayName(isArabic),
          onTap: () async {
            if (data == null) return;
            final picked = await showReciterPicker(
              context,
              reciters: data.reciters,
              selectedId: data.selectedReciter,
            );
            if (picked != null && context.mounted) SettingsCubit.get(context).setReciter(picked);
          },
        );
      },
    );
  }
}
