// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:deber_01/domain/repositories/contador_repository.dart';
import 'package:deber_01/domain/usecases/decrementar.dart';
import 'package:deber_01/domain/usecases/incrementar.dart';
import 'package:deber_01/domain/usecases/obtener_contador.dart';
import 'package:deber_01/main.dart';

void main() {
  testWidgets('vuelve desde Control y conserva el contador', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    expect(find.text('Contador: 0'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 1'), findsOneWidget);

    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 1'), findsOneWidget);
  });

  testWidgets('el back del sistema vuelve y conserva el contador', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Contador: 1'), findsOneWidget);
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  final repository = _FakeContadorRepository();
  await tester.pumpWidget(
    MyApp(
      obtenerContador: ObtenerContador(repository),
      incrementar: Incrementar(repository),
      decrementar: Decrementar(repository),
    ),
  );
  await tester.pumpAndSettle();
}

class _FakeContadorRepository implements ContadorRepository {
  int _valor = 0;

  @override
  Future<int> leer() async => _valor;

  @override
  Future<void> guardar(int valor) async {
    _valor = valor;
  }
}
