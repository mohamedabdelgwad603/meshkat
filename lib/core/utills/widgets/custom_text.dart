import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

// Displays a translated text key (or raw data when translate is false) with optional arguments.
class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final List<String>? args;
  final bool translate;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDirection? textDirection;

  // Creates a text widget that translates its key internally.
  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.args,
    this.translate = true,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textDirection,
  });

  // Builds the text after resolving the translation key.
  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? text.tr(context: context, args: args) : text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      textDirection: textDirection,
    );
  }
}
