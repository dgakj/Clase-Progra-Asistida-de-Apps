import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit({
    required ConsultarConexion consultarConexion,
    required ObservarConexion observarConexion,
  }) : _consultarConexion = consultarConexion,
       _observarConexion = observarConexion,
       super(EstadoConexion.otro);

  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  StreamSubscription<EstadoConexion>? _suscripcion;

  Future<void> iniciar() async {
    emit(await _consultarConexion());
    _suscripcion = _observarConexion().listen(emit);
  }

  @override
  Future<void> close() async {
    await _suscripcion?.cancel();
    await super.close();
  }
}
