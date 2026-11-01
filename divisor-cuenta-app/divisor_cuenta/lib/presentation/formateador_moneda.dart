/// Presenta un importe con exactamente dos decimales.
class FormateadorMoneda {
  const FormateadorMoneda();

  String formatear(double importe) => importe.toStringAsFixed(2);
}
