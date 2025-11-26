/* 
=====================================================================
======================== OBSTACULO QUE CAE ==========================
=====================================================================

 • CLASE CONCRETA — Hereda de Obstaculo.
 • Clase dependiente: usa toda la infraestructura del padre
   (posición, tamaño, daño, colisiones y movimiento horizontal).
 • Representa un obstáculo que:
      - Se mueve horizontalmente (heredado del padre)
      - CAE verticalmente a una velocidad fija
      - Está animado mediante sprites cíclicos

 • IMPORTANTE: 
   Esta clase NO usa PVector porque:
      → Su movimiento es puramente horizontal + vertical
      → Las matemáticas son simples (suma de valores escalares)
      → No necesita cálculos vectoriales complejos

=====================================================================
*/

public class ObstaculoQueCae extends Obstaculo {

    /* ============================================================
       ====================== VARIABLES PRIVADAS ===================
       ============================================================ */

    /* Velocidad de caída vertical — EDITABLE */
    private float velocidadCaida = 90;  // px/segundo hacia abajo

    /* Lista de sprites para animación */
    private final ArrayList<PImage> sprites = new ArrayList<>();

    /* Tiempo acumulado para pasar de un frame al siguiente */
    private float tiempoAnim = 0;

    /* Intervalo entre frames — EDITABLE */
    private float velocidadAnim = 0.15f;

    /* Índice del frame actual */
    private int frameActual = 0;


    /* ============================================================
       =========================== CONSTRUCTOR =====================
       ============================================================ */

    /*
     * Parámetros:
     *   x, y              → posición inicial
     *   ancho, alto       → tamaño del sprite (fijo a 40x40)
     *   velocidadX        → velocidad horizontal heredada (210 px/s)
     *   daño              → daño al tocar al jugador
     */
    public ObstaculoQueCae(float x, float y) {

        super(
            x, y,
            40, 40,     // tamaño del sprite
            210,        // velocidad horizontal (izquierda)
            6           // daño infligido
        );

        /* === CARGA DE SPRITES === */
        sprites.add(loadImage("rama1.png"));
        sprites.add(loadImage("rama2.png"));
        sprites.add(loadImage("rama3.png"));

        /* Puedes agregar más sprites si querés */
        // sprites.add(loadImage("rama4.png"));
    }


    /* ============================================================
       ============================ ACTUALIZAR =====================
       ============================================================ */

    /*
     * ACTUALIZA:
     *   1) Animación del sprite
     *   2) Movimiento horizontal (heredado del padre)
     *   3) Caída vertical con física simple
     *
     * dt = deltaTime en segundos.
     */
    @Override
    public void actualizar(float dt) {

        /* -------------------- ANIMACIÓN -------------------------
         * tiempoAnim += dt
         *   → Suma el tiempo pasado
         * 
         * Si excede velocidadAnim:
         *   → Cambia al siguiente frame
         * --------------------------------------------------------*/
        tiempoAnim += dt;

        if (tiempoAnim >= velocidadAnim) {

            tiempoAnim = 0;     // reiniciar el contador
            frameActual++;      // avanzar frame

            /* Si pasa el límite, volver al frame 0 */
            if (frameActual >= sprites.size()) {
                frameActual = 0;
            }
        }


        /* ----------------- MOVIMIENTO HORIZONTAL ----------------
         * super.actualizar(dt) maneja:
         *    x -= velocidad * dt;
         *    (y no afecta el eje Y)
         * --------------------------------------------------------*/
        super.actualizar(dt);


        /* -------------------- CAÍDA VERTICAL --------------------
         * Matemática simple:
         *      y += velocidadCaida * dt
         *
         * Como dt está en segundos:
         *    velocidadCaida * dt = distancia caída este frame
         * --------------------------------------------------------*/
        y += velocidadCaida * dt;
    }


    /* ============================================================
       ============================== DIBUJAR ======================
       ============================================================ */

    @Override
    public void dibujar() {

        /* Si no hay sprites cargados → no dibujar */
        if (sprites.isEmpty()) return;

        PImage actual = sprites.get(frameActual);

        /* Dibujar sprite actual con su tamaño */
        image(actual, x, y, ancho, alto);
    }


    /* ============================================================
       =========================== EDITABLE ========================
       ============================================================ */

    /* Cambiar la velocidad de caída */
    public void setVelocidadCaida(float nuevaVelocidad) {
        this.velocidadCaida = nuevaVelocidad;
    }

    /* Cambiar velocidad de animación */
    public void setVelocidadAnimacion(float nuevaVelocidad) {
        this.velocidadAnim = nuevaVelocidad;
    }
}
