import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/reflections/data/requests_params/save_reflection_params.dart';
import 'package:mishkat/features/reflections/presentation/cubit/reflections_cubit.dart';
import 'package:mishkat/features/reflections/presentation/widgets/reflection_ayah_quote.dart';
import 'package:mishkat/features/reflections/presentation/widgets/reflection_delete_dialog.dart';

// Opens the sheet for writing or editing the reflection of the given ayah.
Future<void> showReflectionEditor(BuildContext context, SaveReflectionParams target) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: ColorsManager.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28.r))),
    builder: (_) => ReflectionEditorSheet(target: target),
  );
}

// Sheet with the ayah, a text box for the reflection and save and delete actions.
class ReflectionEditorSheet extends StatefulWidget {
  final SaveReflectionParams target;

  // Creates the sheet for the given ayah.
  const ReflectionEditorSheet({super.key, required this.target});

  // Creates the sheet state.
  @override
  State<ReflectionEditorSheet> createState() => _ReflectionEditorSheetState();
}

// Holds the typed text and whether a save or delete is running.
class _ReflectionEditorSheetState extends State<ReflectionEditorSheet> {
  late final TextEditingController _controller;
  late final String _initialNote;
  bool _busy = false;

  static const int _maxLength = 2000;

  // Fills the text box with the saved reflection, if any.
  @override
  void initState() {
    super.initState();
    final cubit = ReflectionsCubit.get(context);
    _initialNote = cubit.find(widget.target.surahNumber, widget.target.ayahNumber)?.note ?? '';
    _controller = TextEditingController(text: _initialNote)..addListener(_onChanged);
  }

  // Releases the text controller.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Rebuilds so the save button follows the typed text.
  void _onChanged() => setState(() {});

  // Tells whether the ayah already had a reflection when the sheet opened.
  bool get _isEditing => _initialNote.isNotEmpty;

  // Tells whether there is new, non-empty text to save.
  bool get _canSave => !_busy && _controller.text.trim().isNotEmpty && _controller.text.trim() != _initialNote;

  // Builds the header, the ayah, the text box and the actions above the keyboard.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final target = widget.target;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomText(
                text: _isEditing ? TextManager.editReflection : TextManager.newReflection,
                style: getBoldStyle(context: context, fontSize: 18.sp, color: ColorsManager.primary),
              ),
              verticalSpace(12.h),
              ReflectionAyahQuote(
                surahName: isArabic ? target.surahName : target.surahEnglishName,
                ayahNumber: target.ayahNumber,
                ayahText: target.ayahText,
                maxLines: 3,
              ),
              verticalSpace(14.h),
              _buildTextField(context),
              verticalSpace(16.h),
              _buildSaveButton(context),
              if (_isEditing) ...[
                verticalSpace(4.h),
                TextButton.icon(
                  onPressed: _busy ? null : _delete,
                  style: TextButton.styleFrom(minimumSize: Size(0, 44.h), shape: const StadiumBorder()),
                  icon: Icon(Icons.delete_outline_rounded, size: 18.r, color: ColorsManager.red),
                  label: CustomText(
                    text: TextManager.deleteReflection,
                    style: getSemiBoldStyle(context: context, color: ColorsManager.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Builds the multi-line box where the reflection is typed.
  Widget _buildTextField(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.r),
      borderSide: const BorderSide(color: ColorsManager.greyLight),
    );
    return TextField(
      controller: _controller,
      autofocus: !_isEditing,
      minLines: 5,
      maxLines: 10,
      maxLength: _maxLength,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      style: getRegularStyle(context: context, fontSize: 15.sp, height: 1.7),
      decoration: InputDecoration(
        hintText: TextManager.reflectionHint.tr(context: context),
        hintStyle: getRegularStyle(context: context, fontSize: 14.sp, color: ColorsManager.grey, height: 1.7),
        hintMaxLines: 3,
        filled: true,
        fillColor: ColorsManager.greyBackground,
        contentPadding: EdgeInsets.all(14.r),
        counterStyle: getRegularStyle(context: context, fontSize: 11.sp, color: ColorsManager.grey),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: const BorderSide(color: ColorsManager.secondry, width: 1.4)),
      ),
    );
  }

  // Builds the primary save button, disabled until there is something new to save.
  Widget _buildSaveButton(BuildContext context) {
    return FilledButton(
      onPressed: _canSave ? _save : null,
      style: FilledButton.styleFrom(
        backgroundColor: ColorsManager.primary,
        foregroundColor: ColorsManager.white,
        disabledBackgroundColor: ColorsManager.track,
        minimumSize: Size(0, 52.h),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 20.r, color: _canSave ? ColorsManager.secondry : ColorsManager.grey),
          horizontalSpace(8.w),
          CustomText(
            text: TextManager.saveReflection,
            style: getBoldStyle(
              context: context,
              fontSize: 15.sp,
              color: _canSave ? ColorsManager.white : ColorsManager.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Saves the typed reflection, then closes the sheet with a confirmation.
  Future<void> _save() async {
    setState(() => _busy = true);
    final error = await ReflectionsCubit.get(context).save(widget.target.copyWithNote(_controller.text));
    if (!mounted) return;
    _finish(error ?? TextManager.reflectionSaved, closeSheet: error == null);
  }

  // Asks for confirmation, deletes the reflection and closes the sheet.
  Future<void> _delete() async {
    final confirmed = await showReflectionDeleteDialog(context);
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    final error = await ReflectionsCubit.get(context).delete(widget.target.surahNumber, widget.target.ayahNumber);
    if (!mounted) return;
    _finish(error ?? TextManager.reflectionDeleted, closeSheet: error == null);
  }

  // Shows the outcome message and closes the sheet on success or re-enables it on failure.
  void _finish(String message, {required bool closeSheet}) {
    context.showSnack(CustomText(
      text: message,
      style: getMediumStyle(context: context, color: ColorsManager.white),
    ));
    if (closeSheet) {
      context.pop();
    } else {
      setState(() => _busy = false);
    }
  }
}
