import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/reader/presentation/widgets/ayah_action_button.dart';
import 'package:mishkat/features/reflections/data/requests_params/save_reflection_params.dart';
import 'package:mishkat/features/reflections/presentation/cubit/reflections_cubit.dart';
import 'package:mishkat/features/reflections/presentation/cubit/reflections_state.dart';
import 'package:mishkat/features/reflections/presentation/widgets/reflection_editor_sheet.dart';

// Ayah panel action that opens the reflection editor and shows when the ayah already has a note.
class ReflectActionButton extends StatelessWidget {
  final SaveReflectionParams target;

  // Creates the button for the given ayah.
  const ReflectActionButton({super.key, required this.target});

  // Rebuilds only when this ayah gains or loses a reflection.
  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReflectionsCubit, ReflectionsState, bool>(
      selector: (state) => state is ReflectionsSuccess && state.find(target.surahNumber, target.ayahNumber) != null,
      builder: (context, hasNote) => AyahActionButton(
        icon: hasNote ? Icons.edit_note_rounded : Icons.edit_outlined,
        label: hasNote ? TextManager.reflectedAction : TextManager.reflectAction,
        onTap: () => showReflectionEditor(context, target),
      ),
    );
  }
}
