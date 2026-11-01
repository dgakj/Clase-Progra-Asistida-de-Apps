# Instrucciones del proyecto

Esta es una app Flutter de una sola pantalla para dividir una cuenta.

Organiza el código en `lib/presentation`, `lib/domain` y `lib/data`. Las dependencias deben apuntar de `presentation` hacia `domain` y de `data` hacia `domain`; `domain` no debe importar `package:flutter`.

Usa null safety, nombres en español y no agregues paquetes externos.

No modifiques `test/` sin que te lo pidan. No agregues dependencias a `pubspec.yaml` sin avisar. No modifiques `android/` ni `ios/`.

Comandos del proyecto: `flutter pub get`, `flutter run`, `flutter analyze` y `flutter test`.
