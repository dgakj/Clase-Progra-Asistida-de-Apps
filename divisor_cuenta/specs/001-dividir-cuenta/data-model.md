# Modelo de datos: Dividir cuenta

## Cuenta

Representa los datos validados para un cálculo temporal.

| Campo | Tipo conceptual | Regla |
|---|---|---|
| montoTotal | número | No negativo; usa la misma unidad monetaria durante todo el cálculo. |
| personas | entero | Debe ser mayor que cero. |
| porcentajePropina | número | No negativo; se aplica al monto total antes de dividir. |

La cuenta vive en memoria y no se conserva entre sesiones.

## Resultado

Representa el importe que corresponde a cada persona.

| Campo | Tipo conceptual | Regla |
|---|---|---|
| pagoPorPersona | número | Resultado después de propina, división y estrategia de redondeo. Se muestra con dos decimales. |

Los escenarios establecen que el redondeo se aplica a cada pago individual; no se redistribuye el residuo de centavos entre personas.

## ModoRedondeo

Selección del usuario usada para encontrar la estrategia inyectada:

- `exacto`: aproxima el pago al centavo más cercano.
- `haciaArriba`: redondea el pago al entero inmediato igual o superior.

Este modo identifica la opción seleccionada; no sustituye la interfaz de estrategia.

## ValidarEntrada

Recibe los tres valores de campo como texto y, si todos son válidos, produce una `Cuenta`. Si no, comunica un error de validación para que la presentación lo muestre. El dominio no importa Flutter.

- Un monto no numérico como `abc` produce exactamente `Monto inválido`.
- Cero personas produce exactamente `Debe haber al menos una persona`.
- Propina no numérica, valores negativos y un número de personas no entero impiden el cálculo. La especificación no fija mensajes exactos para estos casos.

## CalcularDivision

Recibe una `Cuenta` válida y una `EstrategiaRedondeo`, calcula `(montoTotal + montoTotal × porcentajePropina / 100) / personas` y devuelve un `Resultado`. No valida campos ni formatea el importe.

## EstrategiaRedondeo

Interfaz de dominio con un solo método: recibe el pago individual sin formato y devuelve el importe redondeado. `RedondeoExacto` y `RedondeoHaciaArriba` son sustituibles detrás de esta interfaz.

## Relaciones y ciclo de vida

```text
textos de la pantalla
        │
        ▼
ValidarEntrada ── válido ──▶ Cuenta
                                │
                                ▼
                          CalcularDivision ◀── EstrategiaRedondeo
                                │
                                ▼
                            Resultado
                                │
                                ▼
                       FormateadorMoneda
```

La presentación conserva el modo seleccionado, el error y el resultado solo mientras la pantalla está abierta. No existe identidad de usuario, historial ni almacenamiento persistente.
