/* ============================================================
   CLASE: Nivel1
   Nivel concreto del juego
   Hereda comportamiento base de NivelBase y agrega:
   - Obstáculos básicos
   - Obstáculos vivos
   - Obstáculos que caen desde arriba
   - Items (vida y stamina)
   ============================================================ */
public class Nivel1 extends NivelBase {

    /* ============================================================
       ===================== CONFIGURACIÓN =========================
       ============================================================ */

    /* Intervalo entre obstáculos básicos */
    private float intervaloObstaculos = 5.0f;

    /* Intervalo entre obstáculos con IA (vivos) */
    private float intervaloObstaculosVivos = 8.0f;

    /* Intervalo entre obstáculos que caen verticalmente */
    private float intervaloObstaculosQueCae = 6.0f;

    /* Reloj interno para saber cuándo crear uno que cae */
    private float timerObstaculoCae = 0;


    /* ============================================================
       ======================= CONSTRUCTOR =========================
       ============================================================ */
    public Nivel1(GestorJugadorActual gestor) {

        /* ------------------------------------------------------------
           Llamada a la superclase con parámetros del nivel:
           - duración total
           - intervalo entre obstáculos básicos
           - gestor del jugador actual
           - música del nivel
           ------------------------------------------------------------ */
        super(
            30f,             /* duración del nivel      */
            5.0f,            /* intervalo obst. básico  */
            gestor,
            "musica_nivel1.mp3"
        );

        /* Configurar intervalos heredados del NivelBase */
        this.tiempoEntreObstaculosVivos = intervaloObstaculosVivos;

        /* ------------------------------------------------------------
           Fondos del nivel (parallax)
           El primer parámetro es el archivo
           El segundo es la velocidad relativa del fondo
           ------------------------------------------------------------ */
        cargarFondos(
            new String[]{ "bosque.png" },
            new float[]{ -0.5f }
        );
    }


    /* ============================================================
       ======================= ACTUALIZAR ==========================
       ============================================================ */
    @Override
    public void actualizar(float dt) {

        /* ------------------------------------------------------------
           Lógica principal del nivel:
           - Obstáculos básicos
           - Obstáculos vivos
           - Items
           Esto lo gestiona NivelBase automáticamente.
           ------------------------------------------------------------ */
        super.actualizar(dt);


        /* ============================================================
           ============= OBSTÁCULOS QUE CAEN DESDE ARRIBA ============
           ============================================================ */

        timerObstaculoCae += dt;

        if (timerObstaculoCae >= intervaloObstaculosQueCae) {

            timerObstaculoCae = 0;

            /* --------------------------------------------------------
               Se genera una posición aleatoria usando PVector
               X aleatoria (fuera de la pantalla derecha)
               Y: -100 (arriba del área visible)
               -------------------------------------------------------- */
            PVector pos = new PVector(
                random(500, 1000),
                -100
            );

            agregarObstaculo(new ObstaculoQueCae(pos.x, pos.y));
        }
    }


    /* ============================================================
       ========================= DIBUJAR ===========================
       ============================================================ */
    @Override
    public void dibujar() {
        /* Todo el render del nivel está en la superclase */
        super.dibujar();
    }


    /* ============================================================
       =================== OBSTÁCULOS BASE =========================
       ============================================================ */

    /* Obstáculos normales */
    @Override
    protected Obstaculo crearObstaculo() {

        /* Alturas válidas utilizando PISO y TECHO del jugador */
        float yMin = Jugador.TECHO + 30;
        float yMax = Jugador.PISO - 40;

        /* Posición inicial del obstáculo (fuera de pantalla derecha) */
        PVector pos = new PVector(
            width + 60,
            random(yMin, yMax)
        );

        return new ObstaculoBasico(pos.x, pos.y,1);
    }

    /* Obstáculos vivos */
    @Override
    protected Obstaculo crearObstaculoVivo() {

        float yMin = Jugador.TECHO + 30;
        float yMax = Jugador.PISO - 40;

        PVector pos = new PVector(
            width + 60,
            random(yMin, yMax)
        );

        return new ObstaculoVivoBasico(pos.x, pos.y);
    }


    /* ============================================================
       ========================= ÍTEMS =============================
       ============================================================ */
    @Override
    protected Item crearItem() {

        float yMin = Jugador.TECHO + 40;
        float yMax = Jugador.PISO - 40;

        PVector pos = new PVector(
            width + 60,
            random(yMin, yMax)
        );

        /* 50% probabilidad de cada tipo */
        if (random(1) < 0.5f) {
            return new PocionVida(pos.x, pos.y);
        } else {
            return new PocionStamina(pos.x, pos.y);
        }
    }
}
