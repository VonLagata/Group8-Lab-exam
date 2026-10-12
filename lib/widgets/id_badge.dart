import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Black circle with the post number inside (top of every card).
class IdBadge extends StatelessWidget {
  const IdBadge({super.key, required this.label, this.size = 26});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppTheme.black,
        shape: BoxShape.circle,
      ),
      child: FittedBox(
        child: Text(
          label,
          style: const TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
