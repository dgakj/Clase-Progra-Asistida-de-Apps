import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:flutter_test/flutter_test.dart';

import 'casos_de_prueba.dart';

void main() {
  final estrategiasPorModo = <String, EstrategiaRedondeo>{
    'exacto': RedondeoExacto(),
    'arriba': RedondeoHaciaArriba(),
  };

  for (final caso in casos) {
    test(caso.nombre, () {
      final validacion = ValidarEntrada().ejecutar(
        monto: caso.monto.toString(),
        personas: caso.personas.toString(),
        propina: caso.propina.toString(),
      );

      if (caso.errorEsperado != null) {
        expect(validacion.error, caso.errorEsperado);
        expect(validacion.cuenta, isNull);
        return;
      }

      final cuenta = validacion.cuenta;
      expect(cuenta, isNotNull);
      final estrategia = estrategiasPorModo[caso.modo];
      expect(estrategia, isNotNull);

      final resultado = CalcularDivision().ejecutar(cuenta!, estrategia!);
      expect(resultado.pagoPorPersona, closeTo(caso.esperado!, 0.001));
    });
  }

  test('CalcularDivision sustituye una estrategia por otra (LSP)', () {
    final calculadora = CalcularDivision();
    const cuenta = Cuenta(
      montoTotal: 10,
      personas: 3,
      porcentajePropina: 0,
    );

    final resultadoExacto = calculadora.ejecutar(cuenta, RedondeoExacto());
    final resultadoHaciaArriba = calculadora.ejecutar(
      cuenta,
      RedondeoHaciaArriba(),
    );

    expect(resultadoExacto.pagoPorPersona, closeTo(3.33, 0.001));
    expect(resultadoHaciaArriba.pagoPorPersona, closeTo(4, 0.001));
  });
}
