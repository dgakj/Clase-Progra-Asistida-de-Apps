import 'cuenta.dart';

/// Resultado de validar los textos escritos en el formulario.
class ResultadoValidacion {
  const ResultadoValidacion._({this.cuenta, this.error});

  const ResultadoValidacion.valida(Cuenta cuenta) : this._(cuenta: cuenta);

  const ResultadoValidacion.invalida(String error) : this._(error: error);

  final Cuenta? cuenta;
  final String? error;

  bool get esValida => cuenta != null;
}

/// Abstracción del servicio que valida los datos del formulario.
abstract interface class ValidadorEntrada {
  ResultadoValidacion ejecutar({
    required String monto,
    required String personas,
    required String propina,
  });
}

/// Convierte y valida las entradas del formulario sin depender de Flutter.
class ValidarEntrada implements ValidadorEntrada {
  @override
  ResultadoValidacion ejecutar({
    required String monto,
    required String personas,
    required String propina,
  }) {
    final montoConvertido = double.tryParse(monto.trim());
    if (montoConvertido == null ||
        !montoConvertido.isFinite ||
        montoConvertido < 0) {
      return const ResultadoValidacion.invalida('Monto inválido');
    }

    final personasConvertidas = int.tryParse(personas.trim());
    if (personasConvertidas == null || personasConvertidas < 1) {
      return const ResultadoValidacion.invalida(
        'Debe haber al menos una persona',
      );
    }

    final propinaConvertida = double.tryParse(propina.trim());
    if (propinaConvertida == null ||
        !propinaConvertida.isFinite ||
        propinaConvertida < 0) {
      return const ResultadoValidacion.invalida('Propina inválida');
    }

    if (propinaConvertida > 100) {
      return const ResultadoValidacion.invalida(
        'La propina no puede superar el 100%',
      );
    }

    return ResultadoValidacion.valida(
      Cuenta(
        montoTotal: montoConvertido,
        personas: personasConvertidas,
        porcentajePropina: propinaConvertida,
      ),
    );
  }
}
