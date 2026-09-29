import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl({
    super.key,
    required this.contadorInicial,
    required this.incrementar,
    required this.decrementar,
  });

  final int contadorInicial;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador;

  @override
  void initState() {
    super.initState();
    _contador = widget.contadorInicial;
  }

  Future<void> _incrementar() async {
    final valor = await widget.incrementar();
    if (!mounted) return;
    setState(() => _contador = valor);
  }

  Future<void> _decrementar() async {
    final valor = await widget.decrementar();
    if (!mounted) return;
    setState(() => _contador = valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contador: $_contador',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(onPressed: _decrementar, child: const Text('-1')),
                const SizedBox(width: 16),
                FilledButton(onPressed: _incrementar, child: const Text('+1')),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(_contador),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}