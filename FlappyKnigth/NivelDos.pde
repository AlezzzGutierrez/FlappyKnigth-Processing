public class Nivel2 extends NivelBase {

    // Ejemplo: algún timer base del nivel 2
    private float tiempoEnemigosEspeciales = 0;

    public Nivel2(GestorJugadorActual gestor) {

        super(
            70,       // duración del nivel
            1.8f,     // spawn normal
            gestor,
            "musica_nivel1.mp3"
        );

        this.tiempoEntreObstaculosVivos = 10;

        cargarFondos(
            new String[]{
              "Zona Cueva.png"
              /*  "bosque5.png",
                "bosque4.png",
                "bosque3.png",
                "bosque2.png",
                "bosque1.png"**/
            },
            new float[]{ -0.3f/*, -0.6f, -1.0f, -1.3f, -1.5f **/}
             );
    }

    @Override
    public void actualizar(float dt) {

        super.actualizar(dt);

        tiempoEnemigosEspeciales += dt;

        // Ejemplo: cada 12s aparece un enemigo especial
        if (tiempoEnemigosEspeciales >= 30) {
            tiempoEnemigosEspeciales = 0;

            agregarObstaculo(new ObstaculoVivoBasico(
                width + 60,
                random(Jugador.TECHO + 40, Jugador.PISO - 40)
            ));
        }
    }

    @Override
    protected Obstaculo crearObstaculo() {
        return new ObstaculoBasico(
            width + 60,
            random(Jugador.TECHO + 30, Jugador.PISO - 40)
        );
    }

    @Override
    protected Obstaculo crearObstaculoVivo() {
        return new ObstaculoVivoBasico(
            width + 60,
            random(Jugador.TECHO + 30, Jugador.PISO - 40)
        );
    }

    @Override
    protected Item crearItem() {

        if (random(1) < 0.5) {
            return new PocionVida(
                width + 60,
                random(Jugador.TECHO + 40, Jugador.PISO - 40)
            );
        }

        return new PocionStamina(
            width + 60,
            random(Jugador.TECHO + 40, Jugador.PISO - 40)
        );
    }
}
