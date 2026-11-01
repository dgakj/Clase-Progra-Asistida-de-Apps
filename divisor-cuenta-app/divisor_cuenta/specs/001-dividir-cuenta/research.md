# Research: Dividir cuenta

## Flutter SDK estable

- **Decision**: Usar el canal estable de Flutter y el rango de Dart que ya declara el proyecto (`^3.13.1`). No fijar aquí una versión puntual del SDK porque el proyecto no tiene un archivo de versión de Flutter.
- **Rationale**: El usuario pidió el SDK estable. Flutter documenta sus canales y el uso del canal estable para trabajo de producción.
- **Alternatives considered**: Los canales beta y dev se descartan porque no son el canal estable solicitado.
- **Reference**: [Flutter upgrade and release channels](https://docs.flutter.dev/install/upgrade).

## Estado local con `setState`

- **Decision**: Mantener el estado de campos, modo seleccionado, error y resultado en la pantalla con `setState`; usar `DivisorController` para coordinar validación y cálculo, sin introducir un gestor de estado externo.
- **Rationale**: La pantalla es única y el estado vive mientras el usuario está en ella. La guía de Flutter clasifica el estado local de un widget como estado efímero adecuado para `setState`.
- **Alternatives considered**: Un gestor global de estado se descarta porque no hay pantallas compartidas, estado persistente ni flujo entre rutas.
- **Reference**: [Ephemeral state and app state](https://docs.flutter.dev/data-and-backend/state-mgmt/ephemeral-vs-app).

## Dependencias y pruebas

- **Decision**: No agregar paquetes de terceros. Usar widgets e iconos incluidos en Flutter. `flutter_test` es una dependencia del SDK de Flutter y se usará para pruebas automatizadas.
- **Rationale**: Se respeta la instrucción de no usar paquetes externos y la Constitución exige pruebas para la lógica crítica y los criterios de aceptación.
- **Existing project note**: El `pubspec.yaml` del proyecto base incluye `cupertino_icons` y `flutter_lints`. No se necesitan para la funcionalidad; el plan contempla quitar esas dependencias del template y ajustar `analysis_options.yaml` si se mantiene la regla literal de no usar paquetes externos. Esto es trabajo futuro, no se modificó en esta fase.
- **Alternatives considered**: No se propone un paquete decimal, gestor de estado, almacenamiento ni conectividad.
- **References**: [Flutter packages and SDK dependencies](https://docs.flutter.dev/tools/pubspec), [Flutter testing overview](https://docs.flutter.dev/testing/overview), [Flutter CLI reference](https://docs.flutter.dev/reference/flutter-cli).

## Cálculo y selección de redondeo

- **Decision**: `CalcularDivision` recibe una `Cuenta` válida y una `EstrategiaRedondeo`; delega el redondeo sin distinguir clases concretas. `DivisorController` recibe por constructor las dependencias de dominio y una colección de estrategias indexada por un modo definido en `domain`. `main.dart` construye e inyecta `RedondeoExacto` y `RedondeoHaciaArriba`.
- **Rationale**: Esto permite que la interfaz seleccione el modo sin importar `data`; agregar una estrategia no requiere editar el caso de cálculo ni las estrategias ya existentes. Las dos implementaciones pueden sustituirse detrás de la interfaz de un método.
- **Alternatives considered**: Un `if` por tipo concreto en el cálculo se descarta porque acoplaría el dominio a las implementaciones y contravendría OCP y DIP.

## Validación y presentación

- **Decision**: `ValidarEntrada` recibirá los valores de los campos como texto y devolverá una `Cuenta` válida o un error de dominio. `CalcularDivision` no valida ni formatea. `FormateadorMoneda` presentará el resultado con exactamente dos decimales.
- **Rationale**: La entrada `abc` debe rechazarse antes de calcular; mantener validación, cálculo y formato en responsabilidades distintas respeta SRP.
- **Alternatives considered**: Parsear el texto dentro de `CalcularDivision` se descarta porque mezclaría validación con cálculo.

## Aritmética

- **Decision**: La estrategia exacta redondeará el pago individual al centavo más cercano; la estrategia hacia arriba lo elevará al entero inmediato igual o superior. Cada persona recibe el mismo importe calculado para ella, sin redistribuir el residuo de centavos.
- **Rationale**: La salida de 3.33 por persona para 10.00 dividido entre 3 confirma que el residuo no se redistribuye entre personas. Los valores del resultado se formatean con dos decimales.
- **Alternatives considered**: Repartir centavos residuales de forma desigual se descarta porque no coincide con el escenario de aceptación.
