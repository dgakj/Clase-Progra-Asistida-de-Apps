import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String pantalla = '0';
  double numeroAnterior = 0;
  String operacion = '';

  void presionarNumero(String numero) {
    setState(() {
      if (pantalla == '0') {
        pantalla = numero;
      } else {
        pantalla += numero;
      }
    });
  }

  void presionarOperacion(String nuevaOperacion) {
    setState(() {
      numeroAnterior = double.parse(pantalla);
      operacion = nuevaOperacion;
      pantalla = '0';
    });
  }

  void calcular() {
    double numeroActual = double.parse(pantalla);
    double resultado = 0;

    if (operacion == '+') {
      resultado = numeroAnterior + numeroActual;
    } else if (operacion == '-') {
      resultado = numeroAnterior - numeroActual;
    } else if (operacion == '×') {
      resultado = numeroAnterior * numeroActual;
    } else if (operacion == '÷') {
      if (numeroActual == 0) {
        pantalla = 'Error';
        return;
      }
      resultado = numeroAnterior / numeroActual;
    }

    setState(() {
      pantalla = resultado.toString();
      if (pantalla.endsWith('.0')) {
        pantalla = pantalla.substring(0, pantalla.length - 2);
      }
      operacion = '';
    });
  }

  void borrar() {
    setState(() {
      pantalla = '0';
      numeroAnterior = 0;
      operacion = '';
    });
  }

  Widget boton(String texto) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: () {
            if (texto == 'C') {
              borrar();
            } else if (['+', '-', '×', '÷'].contains(texto)) {
              presionarOperacion(texto);
            } else if (texto == '=') {
              calcular();
            } else {
              presionarNumero(texto);
            }
          },
          child: Text(
            texto,
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(25),
              child: Text(
                pantalla,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Row(
            children: [
              boton('7'),
              boton('8'),
              boton('9'),
              boton('÷'),
            ],
          ),

          Row(
            children: [
              boton('4'),
              boton('5'),
              boton('6'),
              boton('×'),
            ],
          ),

          Row(
            children: [
              boton('1'),
              boton('2'),
              boton('3'),
              boton('-'),
            ],
          ),

          Row(
            children: [
              boton('0'),
              boton('C'),
              boton('='),
              boton('+'),
            ],
          ),
        ],
      ),
    );
  }
}