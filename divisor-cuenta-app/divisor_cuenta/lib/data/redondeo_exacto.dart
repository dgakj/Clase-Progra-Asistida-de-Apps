import '../domain/estrategia_redondeo.dart';

/// Redondea el importe al centavo más cercano.
class RedondeoExacto implements EstrategiaRedondeo {
  @override
  double redondear(double importe) => (importe * 100).round() / 100;
}
