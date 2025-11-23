
public class Caballero extends Jugador {

    public Caballero(String nombre) {
        super(nombre, color(#17DFE8)); // plateado
    }

@Override
protected void habilidadZ() {

    // 1) ¿Tiene stamina suficiente?
    if (getStamina() < 4) return;

    // 2) Consumir stamina
    consumirStamina(4);

    // 3) Calcular rango basado en el tamaño del jugador
    float rango = getAncho() * 3;

    // 4) Pedirle al nivel que borre obstáculos cercanos
    if (nivelActual != null) {
        nivelActual.eliminarObstaculosCercanos(this, rango);
    }

    println(getNombre() + " usa TAJADA PESADA (elimina obstáculos en rango)");
}



@Override
protected void habilidadX() {

    // 1) ¿Tiene stamina suficiente?
    if (getStamina() < 10) return;

    // 2) Consumir stamina
    consumirStamina(10);

    // 3) Ejecutar barrido masivo
    if (nivelActual != null) {
        nivelActual.eliminarObstaculosEnRangoCaballero(this);
    }

    println(getNombre() + " usa GOLPE TERREMOTO (elimina todo adelante en área masiva)");
}

}
