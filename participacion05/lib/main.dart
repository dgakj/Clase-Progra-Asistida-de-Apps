import 'package:flutter/material.dart';

import 'data/repositories/usuario_api.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';
import 'presentation/pagina_usuarios.dart';

void main() {
  // 1. Creamos el repositorio concreto
  final usuarioApi = UsuarioApi();

  // 2. Creamos el caso de uso y le inyectamos el repositorio
  final obtenerUsuariosConVocal = ObtenerUsuariosConVocal(
    usuarioApi,
  );

  // 3. Inyectamos el caso de uso en la pantalla
  runApp(
    MiAplicacion(
      obtenerUsuariosConVocal: obtenerUsuariosConVocal,
    ),
  );
}

class MiAplicacion extends StatelessWidget {
  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  const MiAplicacion({
    super.key,
    required this.obtenerUsuariosConVocal,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaUsuarios(
        obtenerUsuariosConVocal: obtenerUsuariosConVocal,
      ),
    );
  }
}
