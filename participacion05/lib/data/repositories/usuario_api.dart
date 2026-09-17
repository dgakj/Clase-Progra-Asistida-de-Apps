import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  @override
  Future<List<Usuario>> obtener() async {
    // URL de la API
    final respuesta = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    // Verificamos que la petición haya funcionado
    if (respuesta.statusCode != 200) {
      throw Exception('Error al obtener los usuarios');
    }

    // Convertimos el JSON en una lista
    final List<dynamic> datos = jsonDecode(respuesta.body);

    // Convertimos cada elemento del JSON en un objeto Usuario
    return datos.map((dato) {
      return Usuario(
        id: dato['id'],
        nombre: dato['name'],
        email: dato['email'],
      );
    }).toList();
  }
}
