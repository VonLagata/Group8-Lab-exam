import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab_exam/theme/app_theme.dart';
import 'package:lab_exam/widgets/status_banner.dart';

void main() {
  testWidgets('StatusBanner shows its message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: StatusBanner(message: 'Post created', isSuccess: true),
        ),
      ),
    );

    expect(find.text('Post created'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
