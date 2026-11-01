# Quickstart: Dividir cuenta

Esta guía se ejecuta desde la raíz del proyecto `divisor_cuenta`.

## Prerrequisitos

- Flutter instalado en el canal estable.
- Un dispositivo o emulador compatible con el proyecto.
- Un terminal abierto en la carpeta `divisor_cuenta`.

Comprueba la instalación y prepara el proyecto:

```powershell
flutter --version
flutter pub get
```

## Verificación automatizada y análisis

```powershell
flutter analyze
flutter test
```

Resultado verificado: `flutter analyze` terminó sin hallazgos y `flutter test` pasó las 13 pruebas, incluidas las seis pruebas de pantalla para los escenarios de aceptación. La prueba del contador inicial se reemplazó por pruebas del divisor.

## Ejecución manual

```powershell
flutter run
```

Comprueba en la pantalla única:

| Caso | Monto | Personas | Propina | Modo | Resultado esperado |
|---|---:|---:|---:|---|---|
| 1 | 100.00 | 4 | 10% | Exacto | 27.50 por persona |
| 2 | 90.00 | 3 | 0% | Exacto | 30.00 por persona |
| 3 | 50.00 | 0 | 0% | Exacto | “Debe haber al menos una persona”; sin resultado |
| 4 | abc | 4 | 0% | Exacto | “Monto inválido”; sin resultado |
| 5 | 10.00 | 3 | 0% | Exacto | 3.33 por persona |
| 6 | 10.00 | 3 | 0% | Hacia arriba | 4.00 por persona |

Para validar el modo sin conexión, desactiva la conexión del dispositivo y repite un cálculo válido. Debe producir el mismo valor sin servicios de red.
