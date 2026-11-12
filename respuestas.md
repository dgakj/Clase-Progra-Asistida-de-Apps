# Respuestas

1. **Arquitectura.** El LLM entendió la solicitud, eligió las herramientas y propuso sus argumentos; no ejecutó el código del servidor. El harness/host coordinó la conversación y puso las herramientas a disposición. El cliente MCP envió las llamadas al servidor y devolvió sus respuestas. El servidor MCP implementó la lógica de las herramientas. **Python lo ejecutó el proceso del servidor MCP** (`server.py`), iniciado y coordinado por el host.

2. **Evidencia.** En `INC-003` hubo cuatro `LOGIN_FAILED` de `admin` desde `192.0.2.50` entre 03:00 y 03:03, seguidos por `LOGIN_SUCCESS` desde esa misma IP a las 03:04. La secuencia amerita investigación, pero los registros no explican quién usó la cuenta ni si el acceso fue autorizado; por sí sola no prueba una intrusión.

3. **Validación y seguridad.** El servidor MCP rechaza un ID de caso inexistente como `INC-999` y valida los campos de una alerta, incluidos nivel permitido, motivo no vacío y una alerta por caso. El cliente/harness puede comprobar formato y tipos de la llamada, pero las reglas de negocio las aplica el servidor. No se debe confiar solo en los argumentos del modelo: puede proponer IDs, niveles o valores inválidos, así que el servidor debe validar cada llamada antes de actuar.
