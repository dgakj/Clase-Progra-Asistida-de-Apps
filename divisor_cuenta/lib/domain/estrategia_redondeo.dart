/// Contrato para aplicar una regla de redondeo a un pago individual.
abstract interface class EstrategiaRedondeo {
  double redondear(double importe);
}
