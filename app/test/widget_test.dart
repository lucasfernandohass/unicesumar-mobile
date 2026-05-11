import 'package:flutter_test/flutter_test.dart';

import 'package:example_application/main.dart';

void main() {
  testWidgets('Renderiza tela inicial de filmes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MainApp(),
    );

    expect(find.text('Movie App - Lista de Filmes'), findsOneWidget);
    expect(find.text('A Origem'), findsOneWidget);
  });
}
