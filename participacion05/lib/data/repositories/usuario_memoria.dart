import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioMemoria implements UsuarioRepository {
  @override
  Future<List<Usuario>> obtener() async {
    return [
      Usuario(
        id: 1,
        nombre: 'Ana',
        email: 'ana@email.com',
      ),
      Usuario(
        id: 2,
        nombre: 'Carlos',
        email: 'carlos@email.com',
      ),
      Usuario(
        id: 3,
        nombre: 'Elena',
        email: 'elena@email.com',
      ),
    ];
  }
}
