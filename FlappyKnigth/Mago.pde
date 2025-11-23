public class Mago extends Jugador {

    public Mago(String nombre) {
        super(nombre, color(#FE08FF)); 
    }

    @Override
    protected void habilidadZ() {

        // Necesita 5 stamina
        if (getStamina() < 5) return;

        consumirStamina(5);

        // Curar 15 de vida
        curar(15);

        println(getNombre() + 
            " canaliza ENERGÍA ARCANA (+15 vida)");
    }

    @Override
    protected void habilidadX() {

        // Necesita 15 stamina
        if (getStamina() < 15) return;

        consumirStamina(15);

        // Eliminar 20 obstáculos cercanos
        if (nivelActual != null) {
            nivelActual.eliminar20ObstaculosMasCercanos(this);
        }

        println(getNombre() + 
            " desata TORMENTA CÓSMICA (destruye 20 obstáculos cercanos)");
    }
}
