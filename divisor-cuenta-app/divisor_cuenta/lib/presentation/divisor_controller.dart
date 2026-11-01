import '../domain/calcular_division.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/modo_redondeo.dart';
import '../domain/resultado.dart';
import '../domain/validar_entrada.dart';

/// Estado visible que produce el controlador al intentar calcular.
class EstadoCalculo {
  const EstadoCalculo._({this.resultado, this.error});

  const EstadoCalculo.exitoso(Resultado resultado)
    : this._(resultado: resultado);

  const EstadoCalculo.fallido(String error) : this._(error: error);

  final Resultado? resultado;
  final String? error;
}

/// Coordina validación y cálculo; las reglas concretas llegan por constructor.
class DivisorController {
  DivisorController({
    required ValidadorEntrada validador,
    required CalculadorDivision calculadora,
    required Map<ModoRedondeo, EstrategiaRedondeo> estrategias,
  }) : _validador = validador,
       _calculadora = calculadora,
       _estrategias = Map.unmodifiable(estrategias);

  final ValidadorEntrada _validador;
  final CalculadorDivision _calculadora;
  final Map<ModoRedondeo, EstrategiaRedondeo> _estrategias;

  EstadoCalculo calcular({
    required String monto,
    required String personas,
    required String propina,
    required ModoRedondeo modo,
  }) {
    final validacion = _validador.ejecutar(
      monto: monto,
      personas: personas,
      propina: propina,
    );
    final cuenta = validacion.cuenta;
    if (cuenta == null) {
      return EstadoCalculo.fallido(validacion.error ?? 'Entrada inválida');
    }

    final estrategia = _estrategias[modo];
    if (estrategia == null) {
      return const EstadoCalculo.fallido('Modo de redondeo inválido');
    }

    return EstadoCalculo.exitoso(_calculadora.ejecutar(cuenta, estrategia));
  }
}
