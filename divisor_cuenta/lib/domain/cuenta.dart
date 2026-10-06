/// Datos ya validados que se usan para calcular una división.
class Cuenta {
  const Cuenta({
    required this.montoTotal,
    required this.personas,
    required this.porcentajePropina,
  });

  final double montoTotal;
  final int personas;
  final double porcentajePropina;
}
