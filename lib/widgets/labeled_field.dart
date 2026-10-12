import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Label on top + gray underlined text field (as in the Create Post modal).
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final bool autofocus;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          minLines: maxLines > 1 ? maxLines : null,
          maxLength: maxLength,
          autofocus: autofocus,
          style: const TextStyle(fontSize: 14, color: AppTheme.black),
          decoration: AppTheme.inputDecoration(hint),
        ),
      ],
    );
  }
}
