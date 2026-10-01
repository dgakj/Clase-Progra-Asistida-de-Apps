# Quickstart: Dividir cuenta

Esta guía se ejecuta desde la raíz del proyecto `divisor_cuenta`, después de implementar la feature. No se ejecutaron estos comandos durante la fase de planificación.

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

Resultado esperado: el análisis termina sin errores y las pruebas de dominio/widget cubren los seis escenarios de aceptación. La prueba de contador que trae el template debe reemplazarse durante la implementación por pruebas del divisor, con autorización para modificar `test/`.

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
