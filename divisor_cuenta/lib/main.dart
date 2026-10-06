import 'package:flutter/material.dart';

import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/estrategia_redondeo.dart';
import 'domain/modo_redondeo.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/pantalla_divisor.dart';

void main() => runApp(crearAplicacion());

/// Punto único de composición de la aplicación.
Widget crearAplicacion() {
  final estrategias = <ModoRedondeo, EstrategiaRedondeo>{
    ModoRedondeo.exacto: RedondeoExacto(),
    ModoRedondeo.haciaArriba: RedondeoHaciaArriba(),
  };
  final controlador = DivisorController(
    validador: ValidarEntrada(),
    calculadora: CalcularDivision(),
    estrategias: estrategias,
  );

  return MaterialApp(
    title: 'Dividir cuenta',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087E75)),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        alignLabelWithHint: true,
      ),
    ),
    home: PantallaDivisor(controlador: controlador),
  );
}
