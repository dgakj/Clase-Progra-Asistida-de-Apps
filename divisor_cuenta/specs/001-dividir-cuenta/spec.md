# Feature Specification: Dividir cuenta

**Feature Branch**: `sdd`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas. El usuario ingresa el monto total, el número de personas y el porcentaje de propina, y al tocar Calcular ve cuánto paga cada persona con dos decimales. Hay dos modos de redondeo: exacto o hacia arriba al entero más cercano. La app funciona sin conexión y no utiliza red ni conserva datos en una base de datos."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Calcular el pago por persona (Priority: P1)

Como persona que comparte una cuenta de restaurante, quiero ingresar el monto, cuántas personas la dividirán y la propina, para saber cuánto paga cada una.

**Why this priority**: Es el propósito central de la app y produce el resultado que necesita el usuario.

**Independent Test**: Ingresar un monto, una cantidad positiva de personas y un porcentaje de propina; al tocar Calcular, comprobar el pago individual mostrado.

**Acceptance Scenarios**:

1. **Given** que el usuario abre la app, **When** se muestra la pantalla principal, **Then** puede ver en esa única pantalla los campos de cuenta, la elección de redondeo y la acción Calcular.
2. **Given** un monto de 100.00, 4 personas y 10% de propina, **When** el usuario elige el modo exacto y toca Calcular, **Then** ve 27.50 por persona.
3. **Given** un monto de 90.00, 3 personas y 0% de propina, **When** el usuario elige el modo exacto y toca Calcular, **Then** ve 30.00 por persona.
4. **Given** que el dispositivo no tiene conexión a internet, **When** el usuario completa un cálculo válido y toca Calcular, **Then** ve el resultado sin necesitar conexión.

---

### User Story 2 - Elegir el redondeo del pago (Priority: P1)

Como persona que comparte la cuenta, quiero elegir cómo redondear el pago individual para ver el valor en el formato que prefiero.

**Why this priority**: La elección del redondeo es parte explícita del flujo de cálculo solicitado.

**Independent Test**: Dividir 10.00 entre 3 personas sin propina y comprobar el resultado con cada modo.

**Acceptance Scenarios**:

1. **Given** un monto de 10.00, 3 personas y 0% de propina, **When** el usuario elige el modo exacto y toca Calcular, **Then** ve 3.33 por persona.
2. **Given** un monto de 10.00, 3 personas y 0% de propina, **When** el usuario elige el modo hacia arriba y toca Calcular, **Then** ve 4.00 por persona.

---

### User Story 3 - Corregir entradas inválidas (Priority: P2)

Como persona que comparte la cuenta, quiero recibir un mensaje claro cuando los datos no permiten calcular, para corregirlos sin confundirlos con un resultado válido.

**Why this priority**: La validación evita presentar un pago engañoso, aunque ocurre después del flujo principal de cálculo.

**Independent Test**: Intentar calcular con cero personas y con un monto que no sea numérico; comprobar los mensajes indicados y la ausencia de un resultado.

**Acceptance Scenarios**:

1. **Given** un monto de 50.00 y 0 personas, **When** el usuario toca Calcular, **Then** ve “Debe haber al menos una persona” y no se muestra ningún resultado.
2. **Given** que el monto ingresado es “abc”, **When** el usuario toca Calcular, **Then** ve “Monto inválido” y no se muestra ningún resultado.

### Edge Cases

- Si el número de personas es cero, no se realiza la división y se muestra el mensaje definido en el escenario de aceptación.
- Si el monto no es numérico, no se calcula ni se muestra un resultado anterior como si correspondiera a la entrada actual.
- Un porcentaje de propina de 0% deja el monto total sin incremento.
- El resultado en modo exacto se presenta con dos decimales; en modo hacia arriba se redondea al entero inmediato igual o superior y se presenta con dos decimales.
- El cálculo debe poder completarse sin conexión a internet.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La app MUST presentar en una sola pantalla campos para el monto total, el número de personas y el porcentaje de propina.
- **FR-002**: El usuario MUST poder elegir entre redondeo exacto y redondeo hacia arriba al entero igual o inmediatamente superior.
- **FR-003**: Al tocar “Calcular”, la app MUST sumar al monto la propina indicada y dividir el total entre el número de personas.
- **FR-004**: La app MUST presentar el pago por persona con dos decimales en ambos modos de redondeo.
- **FR-005**: En modo exacto, la app MUST redondear el pago individual al centavo más cercano.
- **FR-006**: En modo hacia arriba, la app MUST redondear el pago individual al entero inmediato igual o superior y presentarlo con dos decimales.
- **FR-007**: Si el número de personas es cero, la app MUST mostrar “Debe haber al menos una persona” y no mostrar un resultado.
- **FR-008**: Si el monto no es numérico, la app MUST mostrar “Monto inválido” y no mostrar un resultado.
- **FR-009**: La app MUST permitir completar el cálculo sin conexión y MUST NOT requerir servicios de red ni conservar los datos de la cuenta entre sesiones.

### Key Entities

- **Datos de la cuenta**: monto total, número de personas y porcentaje de propina ingresados para un cálculo.
- **Resultado por persona**: monto individual que se presenta luego de aplicar la propina, dividir y aplicar el modo de redondeo elegido. Los datos son temporales y no se conservan entre sesiones.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Los seis escenarios de aceptación producen el valor o mensaje especificado, sin mostrar resultados en los dos escenarios inválidos.
- **SC-002**: Después de completar los campos con datos válidos, el usuario obtiene el pago individual con una sola acción en “Calcular”.
- **SC-003**: El usuario puede completar los seis escenarios de aceptación con el dispositivo sin conexión a internet.
- **SC-004**: El pago mostrado siempre contiene exactamente dos decimales, incluso cuando el modo elegido redondea hacia arriba al entero.

## Assumptions

- La propina se calcula como porcentaje del monto total antes de dividirlo entre las personas.
- El modo exacto aproxima al centavo más cercano; el modo hacia arriba redondea al entero inmediato igual o superior.
- Para un cálculo válido, el monto y el porcentaje de propina son valores numéricos no negativos y el número de personas es un entero positivo.
- Las cantidades se expresan en la misma unidad monetaria del monto ingresado; no se realizan conversiones.
- La app no guarda los datos ni el resultado después de cerrar la sesión.
- Los mensajes exactos definidos son obligatorios para cero personas y para un monto no numérico; los demás casos de entrada inválida deben impedir el cálculo.
