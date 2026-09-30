import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({super.key, required this.consultarConexion});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estado;
  DateTime? _horaConsulta;
  bool _consultando = false;
  String? _error;

  Future<void> _consultarAhora() async {
    final hora = DateTime.now();
    setState(() {
      _consultando = true;
      _error = null;
    });

    try {
      final estado = await widget.consultarConexion();
      if (!mounted) return;
      setState(() {
        _estado = estado;
        _horaConsulta = hora;
        _consultando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _horaConsulta = hora;
        _error = 'No se pudo consultar la conexión';
        _consultando = false;
      });
    }
  }

  String get _horaFormateada {
    final hora = _horaConsulta!;
    final hh = hora.hour.toString().padLeft(2, '0');
    final mm = hora.minute.toString().padLeft(2, '0');
    final ss = hora.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final conectado =
        _estado != null && _estado != EstadoConexion.sinConexion;
    final colorEstado = conectado ? Colors.green : Colors.red;

    final (etiqueta, icono) = switch (_estado) {
      EstadoConexion.wifi => ('Wi-Fi', Icons.wifi),
      EstadoConexion.datosMoviles => ('Datos móviles', Icons.signal_cellular_alt),
      EstadoConexion.sinConexion => ('Sin conexión', Icons.wifi_off),
      EstadoConexion.otro => ('Otra conexión', Icons.device_hub),
      null => ('', Icons.help_outline),
    };

    return Center(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_estado != null) ...[
                Icon(icono, size: 88, color: colorEstado),
                const SizedBox(height: 16),
                Text(
                  etiqueta,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colorEstado,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Consulta realizada a las $_horaFormateada'),
                const SizedBox(height: 24),
              ] else if (_horaConsulta != null) ...[
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text('Consulta realizada a las $_horaFormateada'),
                const SizedBox(height: 24),
              ],
              FilledButton.icon(
                onPressed: _consultando ? null : _consultarAhora,
                icon: _consultando
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: const Text('Consultar ahora'),
              ),
            ],
          ),
      ),
    );
  }
}
