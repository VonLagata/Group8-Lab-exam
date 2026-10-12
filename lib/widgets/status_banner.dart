import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Result message shown on screen (success = black, error = red border).
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.message,
    required this.isSuccess,
    this.onClose,
  });

  final String message;
  final bool isSuccess;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? AppTheme.black : AppTheme.error;

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppTheme.pad, AppTheme.pad, AppTheme.pad, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: color),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Icon(isSuccess ? Icons.check_circle : Icons.error, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onClose != null)
            InkWell(
              onTap: onClose,
              child: Icon(Icons.close, size: 20, color: color),
            ),
        ],
      ),
    );
  }
}
