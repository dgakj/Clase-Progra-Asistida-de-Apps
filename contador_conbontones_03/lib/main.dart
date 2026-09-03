import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contador',
      home: const Contador(),
      routes: {
        '/segunda': (context) => const SegundaPantalla(),
      },
    );
  }
}

class Contador extends StatefulWidget {
  const Contador({super.key});

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  int contador = 0;

  void sumar() {
    setState(() {
      contador++;
    });
  }

  void restar() {
    setState(() {
      contador--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$contador',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: restar,
                    child: const Text(
                      '-',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 100,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: sumar,
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/segunda');
              },
              icon: const Icon(
                Icons.arrow_forward,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SegundaPantalla extends StatelessWidget {
  const SegundaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda pantalla'),
      ),
      body: Center(
        child: Image.network(
          'https://th.bing.com/th/id/OIP.qqZzrg8PE4YR-YWKJC0vswHaG8?w=190&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
        ),
      ),
    );
  }
}