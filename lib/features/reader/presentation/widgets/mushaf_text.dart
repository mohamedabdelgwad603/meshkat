import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_state.dart';

const List<String> _quranDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

// Justified Uthmani text of a page where each ayah is tappable and the selected one is highlighted.
class MushafText extends StatefulWidget {
  final List<AyahModel> ayahs;
  final int? selectedAyah;
  final ValueChanged<int> onAyahTap;

  // Creates the text block.
  const MushafText({super.key, required this.ayahs, required this.onAyahTap, this.selectedAyah});

  // Creates the state that owns the tap recognizers.
  @override
  State<MushafText> createState() => _MushafTextState();
}

// Keeps one tap recognizer per ayah and disposes them with the widget.
class _MushafTextState extends State<MushafText> {
  final Map<int, TapGestureRecognizer> _recognizers = {};

  // Releases every recognizer.
  @override
  void dispose() {
    for (final r in _recognizers.values) {
      r.dispose();
    }
    super.dispose();
  }

  // Returns the recognizer of an ayah, creating it on first use.
  TapGestureRecognizer _recognizerFor(int numberInSurah) => _recognizers.putIfAbsent(
        numberInSurah,
        () => TapGestureRecognizer()..onTap = () => widget.onAyahTap(numberInSurah),
      );

  // Formats an ayah number inside ornamental brackets with Arabic-Indic digits.
  String _marker(int number) {
    final digits = number.toString().split('').map((d) => _quranDigits[int.parse(d)]).join();
    return ' ﴿$digits﴾ ';
  }

  // Builds the rich text for the page at the saved font size.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (a, b) => b is SettingsSuccess,
      builder: (context, _) {
        final fontSize = SettingsCubit.get(context).quranFontSize.sp;
        final base = getRegularStyle(
          context: context,
          fontSize: fontSize,
          height: 2.2,
          fontFamily: FontManager.quran,
        );
        final markerStyle = base.copyWith(color: ColorsManager.secondryDark);
        final selectedStyle = base.copyWith(backgroundColor: ColorsManager.goldOverlay);
        return Text.rich(
          TextSpan(
            children: [
              for (final ayah in widget.ayahs) ...[
                TextSpan(
                  text: ayah.text,
                  style: ayah.numberInSurah == widget.selectedAyah ? selectedStyle : base,
                  recognizer: _recognizerFor(ayah.numberInSurah),
                ),
                TextSpan(
                  text: _marker(ayah.numberInSurah),
                  style: markerStyle,
                  recognizer: _recognizerFor(ayah.numberInSurah),
                ),
              ],
            ],
          ),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        );
      },
    );
  }
}
