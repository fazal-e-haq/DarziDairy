import 'package:flutter_test/flutter_test.dart';
import 'package:darzi_dairy/app.dart';

void main() {
  testWidgets('App renders dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TailorMasterApp());
    expect(find.byType(TailorMasterApp), findsOneWidget);
  });
}
