import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sesion_provider.dart';
import 'pantalla_usuarios.dart';

class PantallaIngreso extends StatefulWidget {
  const PantallaIngreso({super.key});

  @override
  State<PantallaIngreso> createState() => _PantallaIngresoState();
}

class _PantallaIngresoState extends State<PantallaIngreso> {
  final correo = TextEditingController();
  final clave = TextEditingController();
  final nombre = TextEditingController();
  bool _navegando = false;

  @override
  void dispose() {
    correo.dispose();
    clave.dispose();
    nombre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();

    if (sesion.idUsuario != null && !_navegando) {
      _navegando = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const PantallaUsuarios(),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: clave,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Clave'),
            ),
            TextField(
              controller: nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            if (sesion.cargando) const CircularProgressIndicator(),
            if (sesion.error != null)
              Text(
                sesion.error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: sesion.cargando
                        ? null
                        : () => context.read<SesionProvider>().ingresar(
                              correo.text,
                              clave.text,
                            ),
                    child: const Text('Ingresar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: sesion.cargando
                        ? null
                        : () => context.read<SesionProvider>().registrar(
                              correo.text,
                              clave.text,
                              nombre.text,
                            ),
                    child: const Text('Crear cuenta'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
