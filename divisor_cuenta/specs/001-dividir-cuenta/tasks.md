---
description: "Tareas de implementación de la app para dividir una cuenta"
---

# Tasks: Dividir cuenta

**Input**: Documentos de diseño en `/specs/001-dividir-cuenta/`.

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`.

**Tests**: Se planifican pruebas porque la Constitución exige pruebas para funciones críticas y que los criterios de aceptación sean ejecutables. Estas tareas no modifican `test/` en esta fase; la implementación de pruebas corresponde a la fase de implementación autorizada.

**Organization**: Tareas agrupadas por historia de usuario y ordenadas por prioridad.

## Formato

- `[P]` identifica tareas que pueden avanzar en paralelo en archivos distintos.
- `[USx]` vincula la tarea con una historia de usuario.
- Las rutas se expresan desde la raíz de `divisor_cuenta/`.

## Fase 1: Preparación

**Propósito**: Dejar el proyecto alineado con el plan Flutter sin paquetes externos.

- [ ] T001 Retirar `cupertino_icons` y `flutter_lints` de `pubspec.yaml`, conservando las dependencias del SDK Flutter necesarias.
- [ ] T002 Ajustar `analysis_options.yaml` para que no dependa de `flutter_lints`.
- [ ] T003 [P] Crear las carpetas `lib/domain/`, `lib/data/` y `lib/presentation/`.

## Fase 2: Fundamentos compartidos

**Propósito**: Establecer contratos y tipos comunes requeridos por las historias.

- [ ] T004 Crear la interfaz Dart pura `EstrategiaRedondeo` en `lib/domain/estrategia_redondeo.dart`, con un único método para transformar el importe.
- [ ] T005 Crear `ModoRedondeo` en `lib/domain/modo_redondeo.dart` para identificar las opciones exacto y hacia arriba sin depender de `data`.

**Punto de control**: Las abstracciones compartidas existen y `lib/domain/` no importa `package:flutter`.

## Fase 3: Historia 1 — Calcular el pago por persona (Prioridad: P1, MVP)

**Objetivo**: Ingresar monto, personas y propina, y ver el pago individual con redondeo exacto.

**Prueba independiente**: Ejecutar los escenarios de cálculo exacto 1 y 2, comprobar los valores `27.50` y `30.00`, y confirmar que la pantalla ofrece los campos y la acción Calcular.

### Pruebas de la historia 1

- [ ] T006 [P] [US1] Registrar los escenarios de cálculo exacto 1 y 2 como datos reutilizables en `test/casos_de_prueba.dart`.
- [ ] T007 [P] [US1] Crear pruebas unitarias de suma de propina, división y redondeo exacto en `test/division_test.dart`.
- [ ] T008 [US1] Crear prueba de widget del flujo válido exacto y sus campos en `test/pantalla_test.dart`.

### Implementación de la historia 1

- [ ] T009 [P] [US1] Crear la entidad `Cuenta` con monto, personas y porcentaje de propina en `lib/domain/cuenta.dart`.
- [ ] T010 [P] [US1] Crear la entidad `Resultado` con el pago por persona en `lib/domain/resultado.dart`.
- [ ] T011 [US1] Implementar validación de los textos de entrada y los errores requeridos en `lib/domain/validar_entrada.dart`.
- [ ] T012 [US1] Implementar el cálculo de total con propina, división y delegación a `EstrategiaRedondeo` en `lib/domain/calcular_division.dart`; mantenerlo sin validación ni formato.
- [ ] T013 [US1] Implementar el redondeo exacto al centavo más cercano en `lib/data/redondeo_exacto.dart`.
- [ ] T014 [US1] Implementar `DivisorController` con dependencias de dominio inyectadas por constructor en `lib/presentation/divisor_controller.dart`.
- [ ] T015 [US1] Implementar formato monetario con dos decimales en `lib/presentation/formateador_moneda.dart`.
- [ ] T016 [US1] Crear la pantalla de una vista con campos y estado local `setState` en `lib/presentation/pantalla_divisor.dart`.
- [ ] T017 [US1] Componer las dependencias concretas desde `main.dart` y mostrar `PantallaDivisor` en `lib/main.dart`.

**Punto de control**: Los dos escenarios exactos de la historia se pueden ejecutar en pruebas y la pantalla funciona sin conexión.

## Fase 4: Historia 2 — Elegir el redondeo del pago (Prioridad: P1)

**Objetivo**: Permitir elegir entre pago exacto al centavo y redondeo hacia arriba al entero inmediato.

**Prueba independiente**: Con `10.00`, 3 personas y 0% de propina, comprobar `3.33` en modo exacto y `4.00` en modo hacia arriba.

### Pruebas de la historia 2

- [ ] T018 [P] [US2] Añadir los dos resultados de redondeo a los casos reutilizables en `test/casos_de_prueba.dart`.
- [ ] T019 [US2] Probar que las dos implementaciones son sustituibles mediante `EstrategiaRedondeo` en `test/division_test.dart`.
- [ ] T020 [US2] Probar selección de modos y resultados `3.33`/`4.00` en `test/pantalla_test.dart`.

### Implementación de la historia 2

- [ ] T021 [P] [US2] Implementar redondeo al entero igual o superior en `lib/data/redondeo_hacia_arriba.dart`.
- [ ] T022 [US2] Inyectar las estrategias por constructor y resolver la selección usando `ModoRedondeo` en `lib/presentation/divisor_controller.dart`, sin importar clases concretas de `data`.
- [ ] T023 [US2] Añadir a la pantalla el selector de modo exacto/hacia arriba en `lib/presentation/pantalla_divisor.dart`.
- [ ] T024 [US2] Registrar ambas implementaciones en el punto único de composición `lib/main.dart`.

**Punto de control**: Los dos modos pasan sus escenarios y agregar una estrategia no requiere cambiar `CalcularDivision`.

## Fase 5: Historia 3 — Corregir entradas inválidas (Prioridad: P2)

**Objetivo**: Mostrar el error correspondiente y retirar cualquier resultado anterior cuando los datos no permiten calcular.

**Prueba independiente**: Probar cero personas y monto `abc`; comprobar los mensajes exactos y que no hay resultado visible.

### Pruebas de la historia 3

- [ ] T025 [P] [US3] Añadir los casos de cero personas y monto no numérico a `test/casos_de_prueba.dart`.
- [ ] T026 [P] [US3] Probar errores de validación y ausencia de resultado en `test/division_test.dart`.
- [ ] T027 [US3] Probar los mensajes `Debe haber al menos una persona` y `Monto inválido` y la ausencia de resultado en `test/pantalla_test.dart`.

### Implementación de la historia 3

- [ ] T028 [US3] Completar la precedencia y mensajes de validación para cero personas y monto no numérico en `lib/domain/validar_entrada.dart`.
- [ ] T029 [US3] Actualizar el controlador para reemplazar el resultado anterior por el estado de error cuando falla la validación en `lib/presentation/divisor_controller.dart`.
- [ ] T030 [US3] Mostrar mensajes de validación y ocultar resultados inválidos en `lib/presentation/pantalla_divisor.dart`.

**Punto de control**: Los seis escenarios de aceptación son verificables y los dos errores no muestran resultado.

## Fase 6: Cierre y verificación

**Propósito**: Comprobar estructura, restricciones y ejecución descritas por el plan.

- [ ] T031 [P] Revisar que `lib/domain/` no importe Flutter y que las dependencias respeten presentation → domain ← data.
- [ ] T032 Ejecutar `flutter pub get` desde `divisor_cuenta/` después de los cambios al manifiesto.
- [ ] T033 Ejecutar `flutter analyze` desde `divisor_cuenta/` y resolver los hallazgos de esta app.
- [ ] T034 Ejecutar `flutter test` desde `divisor_cuenta/` y confirmar los seis escenarios de aceptación.
- [ ] T035 [P] Completar la guía de ejecución y verificación en `specs/001-dividir-cuenta/quickstart.md`.

## Dependencias y orden de ejecución

- Preparación precede a fundamentos; fundamentos preceden a todas las historias.
- La historia 1 entrega el cálculo exacto mínimo. La historia 2 extiende ese flujo con la segunda estrategia y el selector. La historia 3 completa y verifica los estados de error.
- Dentro de cada historia, las pruebas y entidades independientes pueden prepararse en paralelo; integración de controlador y pantalla requiere que existan sus dependencias.
- Cierre depende de las tres historias.

### Oportunidades de paralelismo

- T001 y T002 son cambios separados de configuración; T003 puede hacerse en paralelo.
- En US1, T009 y T010 son archivos independientes; las pruebas T006 y T007 pueden elaborarse en paralelo.
- En US2, T018 y T021 afectan archivos diferentes y se pueden trabajar a la vez.
- En US3, T025 y T028 pueden prepararse en paralelo; las pruebas de widget dependen de la pantalla integrada.

## Estrategia de entrega

1. Completar preparación y fundamentos.
2. Completar US1 y validar el MVP de cálculo exacto.
3. Añadir US2 y validar ambos modos.
4. Añadir US3 y comprobar las seis situaciones de aceptación.
5. Ejecutar los comandos de verificación y revisar la arquitectura.

## Notas

- La tarea de pruebas está incluida por los requisitos de la Constitución y de aceptación; su ejecución corresponde a la implementación, no a esta generación del plan.
- No empezar cambios en `test/` hasta que el usuario autorice la fase de implementación, conforme a `AGENTS.md`.
- Mantener nombres en español, null safety, sin persistencia ni servicios de red.
- No modificar `android/` ni `ios/`.
