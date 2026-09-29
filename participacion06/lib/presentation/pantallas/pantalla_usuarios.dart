import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/perfiles_provider.dart';
import '../providers/sesion_provider.dart';
import 'pantalla_ingreso.dart';

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PerfilesProvider>().cargar();
    });
  }

  Future<void> _cerrarSesion() async {
    await context.read<SesionProvider>().salir();
    if (!mounted) return;

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const PantallaIngreso(),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final local = fecha.toLocal();
    final mes = local.month.toString().padLeft(2, '0');
    final dia = local.day.toString().padLeft(2, '0');
    return '$dia/$mes/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PerfilesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          IconButton(
            tooltip: 'Recargar perfiles',
            onPressed: provider.cargando
                ? null
                : () => context.read<PerfilesProvider>().cargar(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: provider.cargando
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: provider.perfiles.length,
              itemBuilder: (context, index) {
                final perfil = provider.perfiles[index];
                return ListTile(
                  title: Text(perfil.nombre),
                  subtitle: Text(_formatearFecha(perfil.creadoEn)),
                );
              },
            ),
    );
  }
}
