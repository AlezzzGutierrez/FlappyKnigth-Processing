public class Escudero extends Jugador {

    public Escudero(String nombre) {
        super(nombre, color(#1B08FF)); // azul fuerte
    }

    @Override
    protected void habilidadZ() {

        // requiere 3 stamina (ajústalo como quieras)
        if (getStamina() < 3) return;

        consumirStamina(3);

        // ------------ USAR EL MÉTODO DEL NIVEL -------------
        if (nivelActual != null) {

            // elimina solo el obstáculo más cercano al jugador
            nivelActual.eliminarObstaculoMasCercano(this);
        }

        println(getNombre() + 
            " realiza un GOLPE ESCUDADO (elimina 1 obstáculo cercano)");
    }

    @Override
    protected void habilidadX() {

        // necesita 7 stamina
        if (getStamina() < 7) return;

        // gastar stamina
        consumirStamina(7);

        // activar inmunidad por 5 segundos
        activarInmunidad(5.0f);

        println(getNombre() + 
            " levanta su ESCUDO DIVINO (invulnerable por 5 segundos)");
    }
}
