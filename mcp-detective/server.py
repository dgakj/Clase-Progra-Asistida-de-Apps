"""Servidor MCP para consultar casos y registrar alertas en memoria."""

import json
from pathlib import Path
from typing import Any

from mcp.server import MCPServer


RUTA_CASOS = Path(__file__).with_name("casos.json")
with RUTA_CASOS.open("r", encoding="utf-8") as archivo:
    CASOS: dict[str, dict[str, Any]] = json.load(archivo)

ALERTAS: dict[str, dict[str, str]] = {}
NIVELES_VALIDOS = {"bajo", "medio", "alto"}


def listar_casos() -> list[dict[str, Any]]:
    """Devuelve el id, el sistema y la cantidad de eventos de cada caso."""
    return [
        {
            "id": caso_id,
            "sistema": caso["sistema"],
            "cantidad_eventos": len(caso["eventos"]),
        }
        for caso_id, caso in CASOS.items()
    ]


def consultar_eventos(caso_id: str) -> list[dict[str, Any]]:
    """Devuelve sin modificar los eventos del caso indicado."""
    if caso_id not in CASOS:
        raise ValueError(f"No existe un caso con id '{caso_id}'.")
    return CASOS[caso_id]["eventos"]


def registrar_alerta(caso_id: str, nivel: str, motivo: str) -> dict[str, str]:
    """Valida y registra en memoria una alerta para un caso existente."""
    if caso_id not in CASOS:
        raise ValueError(f"No existe un caso con id '{caso_id}'.")
    if nivel not in NIVELES_VALIDOS:
        raise ValueError("El nivel debe ser 'bajo', 'medio' o 'alto'.")
    if not isinstance(motivo, str) or not motivo.strip():
        raise ValueError("El motivo no puede estar vacío ni contener solo espacios.")
    if caso_id in ALERTAS:
        raise ValueError(f"Ya hay una alerta registrada para el caso '{caso_id}'.")

    alerta = {
        "caso_id": caso_id,
        "nivel": nivel,
        "motivo": motivo,
        "estado": "registrada",
    }
    ALERTAS[caso_id] = alerta
    return alerta.copy()


mcp = MCPServer("MCP Detective")


@mcp.tool(name="listar_casos")
def herramienta_listar_casos() -> list[dict[str, Any]]:
    """Lista cada caso con su sistema y cantidad de eventos, sin conclusiones."""
    return listar_casos()


@mcp.tool(name="consultar_eventos")
def herramienta_consultar_eventos(caso_id: str) -> list[dict[str, Any]]:
    """Consulta los eventos exactos de un caso identificado por su id."""
    return consultar_eventos(caso_id)


@mcp.tool(name="registrar_alerta")
def herramienta_registrar_alerta(caso_id: str, nivel: str, motivo: str) -> dict[str, str]:
    """Registra en memoria una alerta válida, como máximo una por caso."""
    return registrar_alerta(caso_id, nivel, motivo)


if __name__ == "__main__":
    mcp.run(transport="stdio")
