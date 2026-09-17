import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  final UsuarioRepository repository;

  ObtenerUsuariosConVocal(this.repository);

  Future<List<Usuario>> ejecutar() async {
    final usuarios = await repository.obtener();

    return usuarios.where((usuario) {
      final nombre = usuario.nombre.toUpperCase();

      return nombre.startsWith('A') ||
          nombre.startsWith('E') ||
          nombre.startsWith('I') ||
          nombre.startsWith('O') ||
          nombre.startsWith('U');
    }).toList();
  }
}
