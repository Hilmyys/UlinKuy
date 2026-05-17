// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:ulinkuy/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UlinKuyApp());

    // Verify that the app title is present
    expect(find.text('UlinKuy'), findsWidgets);
  });
}
