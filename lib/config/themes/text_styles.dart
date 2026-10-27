import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';

// Builds a text style with the given weight and the shared optional overrides.
TextStyle _getTextStyle({
  required BuildContext context,
  required FontWeight fontWeight,
  double? fontSize,
  Color? color,
  double? height,
  TextDecoration? decoration,
  String? fontFamily,
}) {
  return TextStyle(
    fontFamily: fontFamily ?? FontManager.ui,
    fontWeight: fontWeight,
    fontSize: fontSize ?? 14.sp,
    color: color ?? ColorsManager.onSurface,
    height: height,
    decoration: decoration,
  );
}

// Returns the regular (400) style used for body copy and descriptions.
TextStyle getRegularStyle({
  required BuildContext context,
  double? fontSize,
  Color? color,
  double? height,
  TextDecoration? decoration,
  String? fontFamily,
}) =>
    _getTextStyle(
      context: context,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      fontFamily: fontFamily,
    );

// Returns the medium (500) style used for labels and secondary info.
TextStyle getMediumStyle({
  required BuildContext context,
  double? fontSize,
  Color? color,
  double? height,
  TextDecoration? decoration,
  String? fontFamily,
}) =>
    _getTextStyle(
      context: context,
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      fontFamily: fontFamily,
    );

// Returns the semi-bold (600) style used for subtitles and card titles.
TextStyle getSemiBoldStyle({
  required BuildContext context,
  double? fontSize,
  Color? color,
  double? height,
  TextDecoration? decoration,
  String? fontFamily,
}) =>
    _getTextStyle(
      context: context,
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      fontFamily: fontFamily,
    );

// Returns the bold (700) style used for screen titles and headlines.
TextStyle getBoldStyle({
  required BuildContext context,
  double? fontSize,
  Color? color,
  double? height,
  TextDecoration? decoration,
  String? fontFamily,
}) =>
    _getTextStyle(
      context: context,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      fontFamily: fontFamily,
    );
