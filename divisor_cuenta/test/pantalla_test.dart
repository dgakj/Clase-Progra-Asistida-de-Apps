import 'package:divisor_cuenta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iniciarPantalla(WidgetTester tester) async {
  tester.view.physicalSize = const Size(900, 1100);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(crearAplicacion());
}

void main() {
  testWidgets('calcula 27.50 por persona', (tester) async {
    await iniciarPantalla(tester);
    await tester.enterText(find.byKey(const Key('campo-monto')), '100');
    await tester.enterText(find.byKey(const Key('campo-personas')), '4');
    await tester.enterText(find.byKey(const Key('campo-propina')), '10');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('27.50'), findsOneWidget);
  });

  testWidgets('cero personas muestra error y ningún resultado', (tester) async {
    await iniciarPantalla(tester);
    await tester.enterText(find.byKey(const Key('campo-monto')), '50');
    await tester.enterText(find.byKey(const Key('campo-personas')), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.byKey(const Key('resultado-pago')), findsNothing);
  });

  testWidgets('monto no numérico muestra error', (tester) async {
    await iniciarPantalla(tester);
    await tester.enterText(find.byKey(const Key('campo-monto')), 'abc');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Monto inválido'), findsOneWidget);
  });
}
