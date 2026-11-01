# Bitácora de comparación

La comparación entre las ramas **vibe** y **SDD** se registrará con evidencia y usando como ejes principales **cumplimiento**, **iteraciones**, **estructura** y **mantenibilidad**.

| Criterio | Rama vibe | Rama SDD |
|---|---|---|
| Iteraciones (veces que se tuvo que volver a pedir algo) | 9 | 10 |
| Casos de aceptación que cumple (0–6) | 6/6 por inspección del código; falta ejecución manual | 6/6 cubiertos entre pruebas de dominio y pantalla |
| Pruebas automatizadas que pasan | No ejecutadas; la prueba existente todavía comprueba el contador y no el divisor | 10 (7 de dominio y 3 de pantalla) |
| Archivos en `lib/` | 1 | 12 |
| Líneas de código en `lib/` | 249 líneas (conteo de `Get-Content`) | 399 líneas (conteo de `Get-Content`) |
| ¿`domain/` depende de Flutter? | No existe `domain/` (no aplica) | No |
| ¿Existe separación `presentation/domain/data`? | No | Sí |
| ¿El agente agregó algo que nadie pidió? | Sí: selector de redondeo exacto/hacia arriba, no mencionado en la solicitud inicial | No; ambos modos están en la especificación |
| ¿Se puede agregar otra estrategia sin modificar el cálculo existente? | No; los modos se resuelven con una condición dentro del cálculo de la pantalla | Sí; `CalcularDivision` recibe `EstrategiaRedondeo` |

## Registro de avances

- Inicio: se definieron cumplimiento, iteraciones, estructura y mantenibilidad como ejes de comparación.
- Rama `vibe`: la solicitud inicial de la app no cuenta como iteración. Se cuentan **9 mensajes posteriores** (incluida la corrección de carpeta objetivo y solicitudes de explicación/acción), según la regla de la guía.
- La app está en `divisor_cuenta/lib/main.dart` y concentra formulario, validación, cálculo y presentación en un archivo. Al revisar el código, los seis escenarios parecen cubiertos: división con propina, sin propina, cero personas, monto no numérico y ambos redondeos. Esto aún requiere ejecutar manualmente la app para confirmar el comportamiento.
- `lib/` contiene un archivo y 249 líneas. No se ejecutaron pruebas automatizadas. `test/widget_test.dart` sigue comprobando el contador inicial de Flutter, por lo que no demuestra los casos del divisor.
- Rama `sdd`: se generó la especificación `divisor_cuenta/specs/001-dividir-cuenta/spec.md` y su checklist. El prompt de especificación fue la solicitud inicial y no cuenta como iteración; la cobertura en código, pruebas y métricas de implementación siguen pendientes.
- Rama `sdd`: se completó `$speckit-clarify` sin preguntas porque no se detectaron ambigüedades críticas. La checklist de calidad permanece en 16/16.
- Rama `sdd`: se cuentan 5 mensajes posteriores al prompt inicial (repetición de specify, clarify, preparación de la respuesta a la pregunta 4, solicitud de plan y repetición de la solicitud de plan), siguiendo la regla de la guía. Se generaron plan, research, modelo de datos y quickstart; no se modificó código ni se ejecutaron pruebas.
- Pregunta 4 de la entrega: `$speckit-clarify` no hizo preguntas relevantes. La especificación pudo evitar ambigüedades al indicar los datos de entrada, cómo se aplica la propina, los dos modos de redondeo con ejemplos numéricos, los mensajes exactos para personas en cero y monto no numérico, y el requisito de operar sin conexión ni persistir datos. En la rama `vibe`, esas decisiones no se preguntaron explícitamente; el agente completó algunas por su cuenta.
- Agente usado: Codex. Modelo: GPT-6 (identificado por el entorno como agente basado en GPT-6). Nivel de razonamiento/configuración: no visible en esta sesión, por lo que no se puede consignar con certeza. Mantener Codex y, si la interfaz permite elegirlo, el mismo modelo y nivel al trabajar en `sdd`.
- Rama `sdd`: se creó `divisor_cuenta/AGENTS.md` con descripción, estructura y regla de dependencias, estándares, límites de cambios y comandos. El código de la app no se modificó en este paso.
- Rama `sdd`: se creó `.specify/memory/constitution.md` en versión inicial 1.0.0, con los cinco principios SOLID pedidos, arquitectura, seguridad, pruebas y regla de explicabilidad. No se modificaron archivos de la app ni pruebas. El informe HTML temporal al inicio debe quitarse antes del commit.
- Rama `sdd`: se generó `specs/001-dividir-cuenta/tasks.md` con 35 tareas organizadas en preparación, fundamentos y las tres historias de usuario. Se planificaron pruebas para los seis escenarios y verificación de arquitectura; no se modificó código ni `test/` en esta iteración.
- Rama `sdd`: con `$speckit-implement` se completaron las 35 tareas. La app quedó separada en `presentation`, `domain` y `data`, con selector de redondeo, validación, propina y cálculo local. Se retiraron `cupertino_icons` y `flutter_lints`; no se añadieron dependencias directas externas.
- Rama `sdd`: se sustituyó la prueba inicial del contador por pruebas unitarias y de pantalla. `flutter analyze` terminó sin hallazgos y `flutter test` pasó las 13 pruebas, incluyendo los seis escenarios. No se ejecutó la app manualmente en un dispositivo ni se comprobó allí el modo sin conexión.
- La revisión final de arquitectura añadió abstracciones de dominio para validación y cálculo; `DivisorController` depende de esos contratos y de `EstrategiaRedondeo`. Tras ese ajuste se repitieron `flutter analyze` (sin hallazgos) y `flutter test` (13 aprobadas). Las 35 tareas quedaron marcadas como completadas.
- Se aplicó `dart format` y se dejó `analysis_options.yaml` local sin `flutter_lints` para evitar heredar la configuración del repositorio padre.
- Se repitió `$speckit-implement` para confirmar el estado final: 35/35 tareas completas, checklist 16/16, `flutter analyze` sin hallazgos y `flutter test` con 13 aprobadas. No se requirieron cambios adicionales en el código.
- Iteración actual: `test/division_test.dart` se rehízo para recorrer `casos`, validar directamente con `ValidarEntrada` y calcular solo entradas válidas; incluye una prueba LSP que sustituye ambas estrategias sin condicionales ni conversiones. Sus 7 pruebas pasan y `flutter analyze lib` no encuentra problemas.
- La suite completa ahora no compila porque `test/pantalla_test.dart` aún usa `casosAceptacion`, nombre que no existe en el fixture actual (`casos`). El usuario indicó no corregir archivos de `test/` fuera de la prueba solicitada; T034 queda pendiente hasta resolver esa referencia. No se cambió código de `lib/` porque el fallo está en `test/`.
- A solicitud del usuario, se reemplazó `test/pantalla_test.dart` por tres pruebas de widget: cálculo de 27.50, cero personas sin resultado y monto `abc`. Se ajustó la pantalla para que el texto del resultado sea exactamente el importe con dos decimales. La suite completa pasa 10/10 y `flutter analyze` no reporta problemas; T034 vuelve a completarse.
