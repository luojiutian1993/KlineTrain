// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:kline_trainer/app.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('K线训练营'), findsAny);
  });
}
