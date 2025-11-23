public class Nivel3 extends NivelBase {

    private float tiempoGigante = 0;
    private float tiempoDobleVivo = 0;

    public Nivel3(GestorJugadorActual gestor) {

        super(
            80,          // duración del nivel
            1.5f,        // spawn normal más rápido
            gestor,
            "musica_nivel1.mp3"
        );

        this.tiempoEntreObstaculosVivos = 2.0f;

        cargarFondos(
            new String[]{
                "bosque5.png",
                "bosque4.png",
                "bosque3.png",
                "bosque2.png",
                "bosque1.png"
            },
            new float[]{ -0.3f, -0.6f, -1.0f, -1.3f, -1.5f }
        );
    }

    @Override
    public void actualizar(float dt) {

        super.actualizar(dt);

        tiempoGigante += dt;
        tiempoDobleVivo += dt;

        // --------------------------------------------
        // 🔥 Cada 20s → Obstáculo gigante
        // --------------------------------------------
        if (tiempoGigante >= 20) {
            tiempoGigante = 0;

            agregarObstaculo(new ObstaculoBasico(
                width + 60,
                random(Jugador.TECHO + 40, Jugador.PISO - 40)
            ));
        }

        // --------------------------------------------
        // ⚡ Cada 12s → 2 obstáculos vivos simultáneos
        // --------------------------------------------
        if (tiempoDobleVivo >= 12) {
            tiempoDobleVivo = 0;

            agregarObstaculo(new ObstaculoVivoBasico(width + 60, Jugador.TECHO + 50));
            agregarObstaculo(new ObstaculoVivoBasico(width + 60, Jugador.PISO - 80));
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
            return new PocionVida(width + 60,
                    random(Jugador.TECHO + 40, Jugador.PISO - 40));
        }
        return new PocionStamina(width + 60,
                random(Jugador.TECHO + 40, Jugador.PISO - 40));
    }
}
