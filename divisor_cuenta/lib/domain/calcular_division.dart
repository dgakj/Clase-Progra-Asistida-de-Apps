import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

/// Abstracción del caso de uso que calcula el pago por persona.
abstract interface class CalculadorDivision {
  Resultado ejecutar(Cuenta cuenta, EstrategiaRedondeo estrategia);
}

/// Calcula el pago individual y delega la regla de redondeo recibida.
class CalcularDivision implements CalculadorDivision {
  @override
  Resultado ejecutar(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    final totalConPropina =
        cuenta.montoTotal + cuenta.montoTotal * cuenta.porcentajePropina / 100;
    final pagoSinRedondear = totalConPropina / cuenta.personas;
    return Resultado(pagoPorPersona: estrategia.redondear(pagoSinRedondear));
  }
}
