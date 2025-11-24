
public class Arquero extends Jugador {

    public Arquero(String nombre) {
        super(nombre, color(#FFBE08)); // amarillo
    }

    @Override
    protected void habilidadZ() {

        // 1) stamina suficiente
        if (getStamina() < 1) return;

        // 2) consumir stamina
        consumirStamina(1);

        // 3) eliminar solo 1 obstáculo cercano (uso del método del nivel)
        if (nivelActual != null) {
            nivelActual.eliminarObstaculoMasCercano(this);
        }

        println(getNombre() + 
            " dispara una FLECHA EXACTA (elimina 1 obstáculo cercano)");
    }

    @Override
protected void habilidadX() {

    // stamina necesaria
    if (getStamina() < 5) return;

    // consumir stamina
    consumirStamina(5);

    // eliminar 4 obstáculos más cercanos
    if (nivelActual != null) {
        nivelActual.eliminar4ObstaculosMasCercanos(this);
    }

    println(getNombre() +
        " usa LLUVIA DE FLECHAS (elimina 4 obstáculos cercanos)");
}

}
