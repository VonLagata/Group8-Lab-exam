import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The black "Read Post" style button used across all screens.
class BlackButton extends StatelessWidget {
  const BlackButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 32,
    this.fontSize = 11,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final double fontSize;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.black,
          foregroundColor: AppTheme.white,
          disabledBackgroundColor: AppTheme.field,
          disabledForegroundColor: AppTheme.black,
          minimumSize: Size(0, height),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(horizontal: fullWidth ? 4 : 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          ),
          textStyle:
              TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: fontSize + 5),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}
