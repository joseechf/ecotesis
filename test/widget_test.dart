import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ecoazuero/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'assets/translations',
        fallbackLocale: const Locale('es'),
        child: const AppLoader(),
      ),
    );

    await tester.pumpAndSettle();

    // verificar que MaterialApp exista
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
