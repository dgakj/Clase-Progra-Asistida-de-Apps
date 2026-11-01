<!--
Sync Impact Report
Version: unratified template → 1.0.0
Modified principles: replaced template placeholders with the five requested SOLID principles.
Added sections: architecture and security; tests and student explainability.
Removed sections: none.
Deferred items: remove this report before committing, as it is review scratch material.
-->

# Constitución del divisor de cuenta

## Core Principles

### I. Single Responsibility Principle (SRP)

Cada clase tendrá una sola razón de cambio. El cálculo de la división no validará entradas ni dará formato a los resultados.

### II. Open-Closed Principle (OCP)

El cálculo permitirá agregar una nueva regla de redondeo sin modificar las clases de cálculo existentes.

### III. Liskov Substitution Principle (LSP)

Cualquier implementación de una interfaz podrá sustituir a otra sin que quien la use tenga que consultar su tipo concreto.

### IV. Interface Segregation Principle (ISP)

Las interfaces serán pequeñas. Ninguna clase dependerá de métodos que no utiliza.

### V. Dependency Inversion Principle (DIP)

La capa de presentación dependerá de abstracciones definidas en el dominio y nunca de clases concretas de datos.

## Arquitectura y seguridad

- El código se organizará en las capas `presentation`, `domain` y `data`.
- La regla de dependencia será `presentation → domain ← data`.
- `lib/domain/` será Dart puro y no importará `package:flutter`.
- `main.dart` será el único lugar donde se instancien implementaciones concretas.
- No se guardarán secretos ni claves de API en el repositorio.

## Calidad, pruebas y regla de la materia

- Toda funcionalidad crítica tendrá pruebas.
- Los criterios de aceptación de cada especificación se convertirán en pruebas ejecutables.
- El estudiante deberá poder explicar cada función generada: qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce.

## Governance

Esta constitución define las reglas de calidad y arquitectura del proyecto. Las especificaciones, planes, implementaciones y revisiones deberán comprobar su cumplimiento. Toda enmienda se documentará mediante una actualización de versión semántica: PATCH para aclaraciones sin cambio de significado, MINOR para agregar principios o secciones y MAJOR para eliminar o redefinir reglas existentes.

**Version**: 1.0.0 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-01
