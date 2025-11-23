
public class Nivel1 extends NivelBase {

    // -------- CONFIGURACIÓN DEL SPAWNER ---------
    private boolean usarSpawner = true;
    private float tiempoAparicionSpawner = 30;

    private Spawner spawner = null;
    private boolean spawnerCreado = false;

    // -------- TIMERS GENERALES DE INVOCACIÓN ---------
    private float tiempoGeneralSpawner = 0;
    private float tiempoDesdeUltimaInvocacionGeneral = 0;

    // -------- PACK DE 5 ENEMIGOS ---------
    private boolean invocandoPack = false;
    private int packInvocados = 0;

    // -------- OBSTÁCULO QUE CAE ---------
    private float tiempoObstaculoCae = 0; // cada 8 segundos

    public Nivel1(GestorJugadorActual gestor) {

        super(
            60,       // duración del nivel
            2.0f,     // spawn normal
            gestor,
            "musica_nivel1.mp3"
        );

        this.tiempoEntreObstaculosVivos = 3.0f;

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

        // ----------------- CREAR SPAWNER -----------------
        if (usarSpawner && !spawnerCreado && tiempoTranscurrido >= tiempoAparicionSpawner) {

            spawnerCreado = true;

            spawner = new Spawner(
                800,
                -200,
                500
            );
        }

        // ----------------- ACTUALIZAR SPAWNER -----------------
        if (spawner != null) {

            spawner.actualizar(dt);

            if (spawner.terminoEntrada()) {

                tiempoGeneralSpawner += dt;
                tiempoDesdeUltimaInvocacionGeneral += dt;

                // ----------- CADA 10 SEG → iniciar pack de 5 -----------
                if (!invocandoPack && tiempoGeneralSpawner >= 10.0f) {

                    invocandoPack = true;
                    packInvocados = 0;
                    tiempoGeneralSpawner = 0;
                }

                // ----------- SPAWN DEL PACK DE 5 -----------
                if (invocandoPack) {

                    if (tiempoDesdeUltimaInvocacionGeneral >= 1.0f) {

                        tiempoDesdeUltimaInvocacionGeneral = 0;

                        agregarObstaculo(new ObstaculoVivoBasico(800, 300));
                        packInvocados++;

                        if (packInvocados >= 5) {
                            invocandoPack = false;
                        }
                    }
                }

                // ----------- CADA 15 SEG → invoca 1 solo -----------
                if (tiempoGeneralSpawner >= 15.0f) {

                    agregarObstaculo(new ObstaculoVivoBasico(800, 300));
                    tiempoGeneralSpawner = 0;
                }
            }
        }

        // ============================================================
        // ====== SPAWN DEL OBSTÁCULO QUE CAE DESDE ARRIBA ============
        // ============================================================
        tiempoObstaculoCae += dt;

        if (tiempoObstaculoCae >= 8.0f) {

            tiempoObstaculoCae = 0;

            float xRandom = random(500, 1000);

            agregarObstaculo(new ObstaculoQueCae(xRandom, -100));
        }
    }

    @Override
    public void dibujar() {
        super.dibujar();
        if (spawner != null) spawner.dibujar();
    }

    // ============================================================
    // =============== OBSTÁCULO NORMAL HORIZONTAL ================
    // ============================================================
    @Override
    protected Obstaculo crearObstaculo() {

        float yMin = Jugador.TECHO + 30;
        float yMax = Jugador.PISO - 40;

        return new ObstaculoBasico(width + 60, random(yMin, yMax));
    }

    // ============================================================
    // ==================== OBSTÁCULO VIVO =========================
    // ============================================================
    @Override
    protected Obstaculo crearObstaculoVivo() {

        float yMin = Jugador.TECHO + 30;
        float yMax = Jugador.PISO - 40;

        return new ObstaculoVivoBasico(width + 60, random(yMin, yMax));
    }

    // ============================================================
    // ===================== ÍTEMS ALEATORIOS ======================
    // ============================================================
    @Override
    protected Item crearItem() {

        float yMin = Jugador.TECHO + 40;
        float yMax = Jugador.PISO - 40;

        if (random(1) < 0.5) {
            return new PocionVida(width + 60, random(yMin, yMax));
        } else {
            return new PocionStamina(width + 60, random(yMin, yMax));
        }
    }
}
