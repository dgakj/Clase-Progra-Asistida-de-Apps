import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConexionCubit(
        consultarConexion: consultarConexion,
        observarConexion: observarConexion,
      )..iniciar(),
      child: const _ContenidoPantallaStream(),
    );
  }
}

class _ContenidoPantallaStream extends StatefulWidget {
  const _ContenidoPantallaStream();

  @override
  State<_ContenidoPantallaStream> createState() =>
      _ContenidoPantallaStreamState();
}

class _ContenidoPantallaStreamState extends State<_ContenidoPantallaStream> {
  int _cambiosRecibidos = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConexionCubit, EstadoConexion>(
      listener: (context, estado) {
        setState(() => _cambiosRecibidos++);
      },
      child: BlocBuilder<ConexionCubit, EstadoConexion>(
        builder: (context, estado) {
          final conectado = estado != EstadoConexion.sinConexion;
          final color = conectado ? Colors.green : Colors.red;
          final (etiqueta, icono) = switch (estado) {
            EstadoConexion.wifi => ('Wi-Fi', Icons.wifi),
            EstadoConexion.datosMoviles => (
              'Datos móviles',
              Icons.signal_cellular_alt,
            ),
            EstadoConexion.sinConexion => ('Sin conexión', Icons.wifi_off),
            EstadoConexion.otro => ('Otra conexión', Icons.device_hub),
          };

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icono, size: 88, color: color),
                const SizedBox(height: 16),
                Text(
                  etiqueta,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Cambios recibidos: $_cambiosRecibidos'),
              ],
            ),
          );
        },
      ),
    );
  }
}
