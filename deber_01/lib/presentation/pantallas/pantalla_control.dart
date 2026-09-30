import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';

class PantallaControl extends StatelessWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContadorCubit, int>(
      builder: (context, contador) {
        return Scaffold(
          appBar: AppBar(title: const Text('Control')),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Contador: $contador',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton(
                      onPressed: () =>
                          context.read<ContadorCubit>().decrementar(),
                      child: const Text('-1'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<ContadorCubit>().incrementar(),
                      child: const Text('+1'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}