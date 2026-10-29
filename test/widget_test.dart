
import 'package:flutter_test/flutter_test.dart';
import 'package:bread_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Bakery app builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const BakeryApp());

    // نتحقق من ظهور التطبيق قبل انتهاء مؤقّت شاشة البداية.
    expect(find.byType(BakeryApp), findsOneWidget);

    // ننهي الاختبار قبل انتقال SplashView إلى RegisterView.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
