
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Partidos de Fútbol',
      home: const PaginaPartidos(),
    );
  }
}

class PaginaPartidos extends StatefulWidget {
  const PaginaPartidos({super.key});

  @override
  State<PaginaPartidos> createState() => _PaginaPartidosState();
}

class _PaginaPartidosState extends State<PaginaPartidos> {
  List<dynamic> partidos = [];

  bool cargando = true;

  String error = '';

  @override
  void initState() {
    super.initState();

    obtenerPartidos();
  }

  Future<void> obtenerPartidos() async {
    try {
      final respuesta = await http.get(
        Uri.parse(
          'https://www.scorebat.com/video-api/v3/',
        ),
      );

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);

        setState(() {
          partidos = datos['response'];
          cargando = false;
        });
      } else {
        setState(() {
          error = 'Error HTTP: ${respuesta.statusCode}';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partidos de Fútbol'),
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
                  itemCount: partidos.length,
                  itemBuilder: (context, index) {
                    final partido = partidos[index];

                    final homeTeam = partido['homeTeam'];
                    final awayTeam = partido['awayTeam'];

                    return Card(
                      margin: const EdgeInsets.all(10),

                      child: Padding(
                        padding: const EdgeInsets.all(15),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            // COMPETICIÓN
                            Text(
                              '${partido['competition']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // PARTIDO
                            Text(
                              '${homeTeam['name']}  vs  ${awayTeam['name']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // FECHA
                            Text(
                              'Fecha: ${partido['date']}',
                            ),

                            const SizedBox(height: 10),

                            // BOTÓN
                            ElevatedButton(
                              onPressed: () {
                                // Aquí después podemos abrir
                                // los videos del partido.
                              },
                              child: const Text(
                                'Ver partido',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}