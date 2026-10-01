# Bitácora de comparación

La comparación entre las ramas **vibe** y **SDD** se registrará con evidencia y usando como ejes principales **cumplimiento**, **iteraciones**, **estructura** y **mantenibilidad**.

| Criterio | Rama vibe | Rama SDD |
|---|---|---|
| Iteraciones (veces que se tuvo que volver a pedir algo) | 9 | 6 |
| Casos de aceptación que cumple (0–6) | 6/6 por inspección del código; falta ejecución manual | Pendiente |
| Pruebas automatizadas que pasan | No ejecutadas; la prueba existente todavía comprueba el contador y no el divisor | Pendiente |
| Archivos en `lib/` | 1 | Pendiente |
| Líneas de código en `lib/` | 249 líneas (conteo de `Get-Content`) | Pendiente |
| ¿`domain/` depende de Flutter? | No existe `domain/` (no aplica) | Pendiente |
| ¿Existe separación `presentation/domain/data`? | No | Pendiente |
| ¿El agente agregó algo que nadie pidió? | Sí: selector de redondeo exacto/hacia arriba, no mencionado en la solicitud inicial | Pendiente |
| ¿Se puede agregar otra estrategia sin modificar el cálculo existente? | No; los modos se resuelven con una condición dentro del cálculo de la pantalla | Pendiente |

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
