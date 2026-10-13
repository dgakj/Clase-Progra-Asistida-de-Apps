import 'package:flutter/material.dart';

import '../domain/modo_redondeo.dart';
import '../domain/resultado.dart';
import 'divisor_controller.dart';
import 'formateador_moneda.dart';

/// Formulario de una sola pantalla para dividir una cuenta.
class PantallaDivisor extends StatefulWidget {
  const PantallaDivisor({required this.controlador, super.key});

  final DivisorController controlador;

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  final _monto = TextEditingController();
  final _personas = TextEditingController();
  final _propina = TextEditingController(text: '0');
  final _formateador = FormateadorMoneda();
  ModoRedondeo _modo = ModoRedondeo.exacto;
  EstadoCalculo? _estado;

  @override
  void dispose() {
    _monto.dispose();
    _personas.dispose();
    _propina.dispose();
    super.dispose();
  }

  void _calcular() {
    setState(() {
      _estado = widget.controlador.calcular(
        monto: _monto.text,
        personas: _personas.text,
        propina: _propina.text,
        modo: _modo,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final resultado = _estado?.resultado;
    final error = _estado?.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Dividir cuenta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _construirFormulario(tema, error, resultado),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirFormulario(
    ThemeData tema,
    String? error,
    Resultado? resultado,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '¿Cuánto paga cada persona?',
          style: tema.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ingresa los datos de la cuenta y calcula el valor individual.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        ..._construirCampos(),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const Key('boton-calcular'),
          onPressed: _calcular,
          icon: const Icon(Icons.calculate_outlined),
          label: const Text('Calcular'),
        ),
        if (error != null) ..._construirMensajeError(error, tema),
        if (resultado != null) ..._construirTarjetaResultado(resultado, tema),
      ],
    );
  }

  List<Widget> _construirCampos() {
    return [
      TextField(
        key: const Key('campo-monto'),
        controller: _monto,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          labelText: 'Monto total',
          prefixText: '\$ ',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        key: const Key('campo-personas'),
        controller: _personas,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Número de personas',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        key: const Key('campo-propina'),
        controller: _propina,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          labelText: 'Propina',
          suffixText: '%',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<ModoRedondeo>(
        key: const Key('selector-redondeo'),
        initialValue: _modo,
        decoration: const InputDecoration(
          labelText: 'Modo de redondeo',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(
            value: ModoRedondeo.exacto,
            child: Text('Exacto'),
          ),
          DropdownMenuItem(
            value: ModoRedondeo.haciaArriba,
            child: Text('Hacia arriba al entero'),
          ),
        ],
        onChanged: (modo) {
          if (modo != null) setState(() => _modo = modo);
        },
      ),
    ];
  }

  List<Widget> _construirMensajeError(String error, ThemeData tema) {
    return [
      const SizedBox(height: 16),
      Text(
        error,
        key: const Key('mensaje-error'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: tema.colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
  }

  List<Widget> _construirTarjetaResultado(
    Resultado resultado,
    ThemeData tema,
  ) {
    return [
      const SizedBox(height: 20),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Cada persona paga'),
              const SizedBox(height: 8),
              Text(
                _formateador.formatear(resultado.pagoPorPersona),
                key: const Key('resultado-pago'),
                style: tema.textTheme.headlineMedium?.copyWith(
                  color: tema.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
