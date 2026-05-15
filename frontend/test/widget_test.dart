import 'package:flutter_test/flutter_test.dart';
import 'package:quem_e_o_impostor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renderiza tela inicial', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    await tester.pumpWidget(const ImpostorApp());

    expect(find.text('Inicializando IMPOSTOR_OS 95'), findsOneWidget);
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }

    expect(find.text('Quem e o Impostor?'), findsWidgets);
    expect(find.text('Nova partida'), findsOneWidget);
    expect(find.text('Exemplo API + Persistencia'), findsOneWidget);
  });
}
