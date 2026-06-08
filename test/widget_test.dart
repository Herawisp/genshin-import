import 'package:flutter_test/flutter_test.dart';
import 'package:genshin_import/main.dart';

void main() {
  testWidgets('shows landing page first', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('CREATE NEW ACCOUNT'), findsOneWidget);
    expect(find.text('I ALREADY HAVE AN ACCOUNT'), findsOneWidget);
  });
}
