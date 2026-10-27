import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';

// Circular 44pt icon button with a translated accessibility label.
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final Color iconColor;
  final Color backgroundColor;
  final Color? borderColor;
  final double size;
  final double iconSize;

  // Creates the round button.
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.iconColor = ColorsManager.primary,
    this.backgroundColor = ColorsManager.transparent,
    this.borderColor,
    this.size = 44,
    this.iconSize = 20,
  });

  // Builds the tappable circle with its icon.
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: semanticLabel.tr(context: context),
      child: Material(
        color: backgroundColor,
        shape: CircleBorder(
          side: borderColor == null ? BorderSide.none : BorderSide(color: borderColor!),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size.r,
            child: Icon(icon, size: iconSize.r, color: iconColor, semanticLabel: semanticLabel.tr(context: context)),
          ),
        ),
      ),
    );
  }
}
