import 'package:flutter/material.dart';

import '../domain/entities/usuario.dart';
import '../domain/usecases/obtener_usuarios_con_vocal.dart';

class PaginaUsuarios extends StatefulWidget {
  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  const PaginaUsuarios({
    super.key,
    required this.obtenerUsuariosConVocal,
  });

  @override
  State<PaginaUsuarios> createState() => _PaginaUsuariosState();
}

class _PaginaUsuariosState extends State<PaginaUsuarios> {
  List<Usuario> usuarios = [];
  bool cargando = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  Future<void> obtenerUsuarios() async {
    try {
      // Pedimos los usuarios al caso de uso
      final resultado =
          await widget.obtenerUsuariosConVocal.ejecutar();

      setState(() {
        usuarios = resultado;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        error = 'Ocurrió un error al obtener los usuarios';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error.isNotEmpty
              ? Center(
                  child: Text(error),
                )
              : ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(usuario.nombre[0]),
                      ),
                      title: Text(usuario.nombre),
                      subtitle: Text(usuario.email),
                    );
                  },
                ),
    );
  }
}
