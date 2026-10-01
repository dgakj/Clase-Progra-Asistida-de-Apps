# Implementation Plan: Dividir cuenta

**Branch**: `sdd` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Implementación en Flutter estable, sin paquetes externos, estado local con `setState` y capas `domain`, `data` y `presentation` según la Constitución. `main.dart` será el punto único de composición.

## Summary

Crear una pantalla que recibe monto, personas, propina y modo de redondeo, valida la entrada y presenta el valor por persona. El dominio será Dart puro: `ValidarEntrada` produce una `Cuenta` válida; `CalcularDivision` calcula y delega el redondeo en `EstrategiaRedondeo`; `FormateadorMoneda` se ocupa de mostrar dos decimales. El controlador coordina esos pasos y la pantalla actualiza el estado local con `setState`.

## Technical Context

**Language/Version**: Dart con null safety; el proyecto declara `^3.13.1`. Usar el canal estable de Flutter, como pidió el usuario.

**Primary Dependencies**: Flutter SDK para la app. No añadir paquetes de terceros. `flutter_test` se usa desde el SDK para pruebas. El template actual trae `cupertino_icons` y `flutter_lints`; quitarlos si se mantiene la regla de cero paquetes externos y ajustar `analysis_options.yaml` al retirar el linter externo.

**Storage**: Ninguno. Los datos y resultado existen solo durante la sesión de la pantalla.

**Testing**: `flutter_test` (SDK): pruebas unitarias de validación/cálculo/estrategias y pruebas de widget de los escenarios de aceptación. `flutter analyze` para análisis estático.

**Target Platform**: Plataformas Flutter habilitadas por el proyecto creado; no se requieren APIs específicas de Android o iOS. El uso principal es en un teléfono.

**Project Type**: App Flutter de una sola pantalla.

**Performance Goals**: El cálculo es local y síncrono; el resultado debe aparecer en la misma interacción con “Calcular”. No se requiere una meta de carga o concurrencia.

**Constraints**: Una pantalla; estado local con `setState`; sin red, persistencia ni paquetes externos; `lib/domain/` no importa Flutter; las dependencias apuntan `presentation → domain ← data`; solo `main.dart` instancia las estrategias concretas.

**Scale/Scope**: Una cuenta temporal por cálculo. No hay historial, sincronización ni cuentas guardadas.

## Constitution Check

**Gate antes de Phase 0: PASS** — el enfoque propuesto respeta las reglas de la Constitución:

- **SRP**: `ValidarEntrada`, `CalcularDivision` y `FormateadorMoneda` separan validación, cálculo y formato.
- **OCP**: el cálculo delega el redondeo en una interfaz; sus clases existentes no conocen las estrategias concretas.
- **LSP**: ambos redondeos implementan el mismo contrato de un método y pueden sustituirse.
- **ISP**: `EstrategiaRedondeo` expone un solo método.
- **DIP**: `DivisorController` recibe abstracciones del dominio; no importa clases de `data`.
- **Arquitectura**: `domain` es Dart puro; dependencias `presentation → domain ← data`; `main.dart` compone las implementaciones.
- **Seguridad**: no se necesitan secretos ni claves.
- **Pruebas y regla de la materia**: los seis escenarios se convierten en pruebas ejecutables y las funciones deberán ser explicables por el estudiante.
- **Alcance sin conexión**: no se introducen servicios de red ni almacenamiento.

**Gate después del diseño: PASS** — los artefactos de Phase 1 mantienen las mismas separaciones y restricciones. No se identifican violaciones que requieran excepciones.

## Project Structure

### Documentation (this feature)

```text
specs/001-dividir-cuenta/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/requirements.md
└── tasks.md                 # Se generará en la fase $speckit-tasks
```

No se crea `contracts/`: la app no expone APIs ni integra servicios externos.

### Source Code (repository root)

```text
lib/
├── main.dart
├── domain/
│   ├── cuenta.dart
│   ├── resultado.dart
│   ├── calcular_division.dart
│   ├── validar_entrada.dart
│   └── estrategia_redondeo.dart   # Interfaz y modo de redondeo
├── data/
│   ├── redondeo_exacto.dart
│   └── redondeo_hacia_arriba.dart
└── presentation/
    ├── divisor_controller.dart
    ├── formateador_moneda.dart
    └── pantalla_divisor.dart

test/
├── casos_de_prueba.dart
├── division_test.dart
└── pantalla_test.dart
```

El proyecto ya tiene `test/widget_test.dart` del contador inicial de Flutter. Durante la implementación habrá que reemplazar esa prueba obsoleta por pruebas del divisor, respetando la instrucción de no tocar `test/` hasta que el usuario autorice esa fase.

**Structure Decision**: Un solo proyecto Flutter. Las entidades y casos de uso se ubican en `domain`, las dos estrategias concretas en `data` y el controlador, formato y pantalla en `presentation`. `main.dart` crea las estrategias y las inyecta al controlador.

### Composition and state flow

1. `main.dart` instancia `RedondeoExacto`, `RedondeoHaciaArriba`, `ValidarEntrada` y `CalcularDivision`, y entrega sus dependencias a `DivisorController` por constructor.
2. `PantallaDivisor` guarda campos, selección, error y resultado en su estado de Flutter; llama al controlador y usa `setState` para reflejar cambios.
3. `DivisorController` pasa los textos a `ValidarEntrada`, elige una estrategia mediante un modo del dominio y solicita el cálculo. La selección se resuelve con una colección de `EstrategiaRedondeo`, no con comprobaciones del tipo concreto.
4. `CalcularDivision` recibe una `Cuenta` válida y una estrategia, calcula el valor sin validar ni formatear y devuelve `Resultado`.
5. `FormateadorMoneda` presenta el pago individual con dos decimales. Los errores se muestran sin un resultado previo.

La suma para cada persona es `(monto + monto × propina / 100) / personas`. El modo exacto aproxima cada pago individual al centavo; el modo hacia arriba lo lleva al entero inmediato igual o superior. No se redistribuye el residuo entre personas, conforme al escenario 10.00 / 3 → 3.33 para cada una.

## Complexity Tracking

Sin violaciones de la Constitución; no requiere excepciones.
