import 'package:educapais_flutter/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login page renders', (tester) async {
    await tester.pumpWidget(const EducaPaisApp());

    expect(find.text('EducaPais'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
