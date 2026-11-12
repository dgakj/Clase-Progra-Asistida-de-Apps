"""Pruebas unitarias para la lógica del servidor MCP Detective."""

import pytest

from server import ALERTAS, consultar_eventos, listar_casos, registrar_alerta


@pytest.fixture(autouse=True)
def alertas_aisladas():
    """Limpia el almacenamiento en memoria antes y después de cada prueba."""
    ALERTAS.clear()
    yield
    ALERTAS.clear()


def test_listar_casos_devuelve_los_tres_casos_y_sus_cantidades():
    casos = listar_casos()

    assert {caso["id"] for caso in casos} == {"INC-001", "INC-002", "INC-003"}
    assert {caso["id"]: caso["cantidad_eventos"] for caso in casos} == {
        "INC-001": 2,
        "INC-002": 6,
        "INC-003": 5,
    }


def test_consultar_eventos_de_caso_desconocido_lanza_error_explicito():
    with pytest.raises(ValueError, match="No existe un caso con id 'INC-999'"):
        consultar_eventos("INC-999")


def test_consultar_eventos_de_inc_002_devuelve_seis_fallos_de_admin():
    eventos = consultar_eventos("INC-002")

    assert len(eventos) == 6
    assert all(evento["evento"] == "LOGIN_FAILED" for evento in eventos)
    assert all(evento["usuario"] == "admin" for evento in eventos)


def test_registrar_alerta_valida_devuelve_confirmacion_y_la_guarda():
    alerta = registrar_alerta(
        "INC-003",
        "alto",
        "Cuatro fallos y un acceso exitoso desde la misma IP; requiere investigación",
    )

    assert alerta == {
        "caso_id": "INC-003",
        "nivel": "alto",
        "motivo": "Cuatro fallos y un acceso exitoso desde la misma IP; requiere investigación",
        "estado": "registrada",
    }
    assert ALERTAS["INC-003"] == alerta


def test_segunda_alerta_para_el_mismo_caso_se_rechaza():
    registrar_alerta("INC-003", "alto", "Primera alerta")

    with pytest.raises(ValueError, match="Ya hay una alerta registrada.*INC-003"):
        registrar_alerta("INC-003", "medio", "Alerta duplicada")


def test_nivel_critico_se_rechaza():
    with pytest.raises(ValueError, match="El nivel debe ser 'bajo', 'medio' o 'alto'"):
        registrar_alerta("INC-002", "critico", "Intentos repetidos")


def test_motivo_de_solo_espacios_se_rechaza():
    with pytest.raises(ValueError, match="El motivo no puede estar vacío"):
        registrar_alerta("INC-002", "medio", " ")
