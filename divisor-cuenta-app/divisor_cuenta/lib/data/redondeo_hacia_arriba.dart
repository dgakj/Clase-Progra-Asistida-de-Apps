import '../domain/estrategia_redondeo.dart';

/// Redondea al entero igual o inmediatamente superior.
class RedondeoHaciaArriba implements EstrategiaRedondeo {
  @override
  double redondear(double importe) => importe.ceilToDouble();
}
