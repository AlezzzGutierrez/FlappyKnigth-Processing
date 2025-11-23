public abstract class ObstaculoVivo extends Obstaculo {

    protected float duracionSeguimiento;
    protected float tiempoSiguiendo = 0;

    protected PVector ultimaPosicionJugador;

    // Última dirección hacia el jugador (normalizada)
    protected PVector ultimaDireccion = new PVector(0, 0);

    protected float velocidadMovimiento;

    public ObstaculoVivo(
        float x, float y,
        float ancho, float alto,
        float velocidadMovimiento,
        int danio,
        float duracionSeguimiento
    ) {
        super(x, y, ancho, alto, 0, danio);
        this.velocidadMovimiento = velocidadMovimiento;
        this.duracionSeguimiento = duracionSeguimiento;

        ultimaPosicionJugador = new PVector(x, y);
    }

    public void actualizar(float dt, Jugador jugador) {

        tiempoSiguiendo += dt;

        if (tiempoSiguiendo <= duracionSeguimiento) {

            // Guardar coordenadas actuales del jugador
            ultimaPosicionJugador = jugador.getPos().copy();

            // Calcular dirección hacia el jugador
            PVector posActual = new PVector(x, y);
            PVector dir = PVector.sub(ultimaPosicionJugador, posActual);

            if (dir.mag() > 1) {
                dir.normalize();
                ultimaDireccion = dir.copy();
            }

            moverHacia(ultimaPosicionJugador, dt);

        } else {
            // Ya no sigue → seguir moviéndose en la dirección guardada
            moverDireccionFija(dt);
        }
    }

    private void moverHacia(PVector destino, float dt) {

        PVector posActual = new PVector(x, y);
        PVector dir = PVector.sub(destino, posActual);

        if (dir.mag() < 1) return;

        dir.normalize();
        dir.mult(velocidadMovimiento * dt);

        x += dir.x;
        y += dir.y;
    }

    private void moverDireccionFija(float dt) {
        x += ultimaDireccion.x * velocidadMovimiento * dt;
        y += ultimaDireccion.y * velocidadMovimiento * dt;
    }
}
          
