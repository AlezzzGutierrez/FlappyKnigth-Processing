/* ============================================================
   =========================== CLASE PICO ======================
   ============================================================

   • Clase HEREDADA de Obstaculo.
   • Objeto dependiente del sistema de físicas, colisiones y 
     movimiento definido en la clase padre.

   • NO usa PVectores:
       Actualmente funciona con floats (x, y). Si se quiere una
       física más precisa o interpolación suave, debería migrar
       a PVector (comentado para que el programador lo note).

   • Contiene animación cuadro por cuadro + movimiento horizontal
     + caída vertical.

   • Animación, daño, tamaño y velocidad EDITABLES.

   • Encapsulación aplicada en variables modificables.

   ============================================================ */

public class Pico extends Obstaculo {

    /* ============================================================
       ==================== VARIABLES PRIVADAS =====================
       ============================================================ */

    /* Velocidad vertical de caída (px/seg) — EDITABLE */
    private float velocidadCaida;

    /* Lista de frames animados */
    private ArrayList<PImage> sprites;

    /* Control de animación */
    private float tiempoAnim;
    private float velocidadAnim;   // Segundos por frame — EDITABLE
    private int frameActual;


    /* ============================================================
       ============================ CONSTRUCTOR ===================
       ============================================================ */

    /*
     * Inicializa un Pico:
     *  - Llama al constructor del Obstaculo.
     *  - Asigna velocidad, daño y tamaño.
     *  - Prepara animación.
     *  - Carga sprites.
     */
    public Pico(float x, float y) {

        super(
            x, y,        /* posición base */
            40, 40,      /* tamaño del sprite */
            210,         /* velocidad horizontal hacia la izquierda */
            8            /* daño (EDITABLE) */
        );

        /* Inicialización de variables internas */
        this.velocidadCaida = 90f;
        this.velocidadAnim = 0.15f;
        this.tiempoAnim = 0f;
        this.frameActual = 0;

        /* Contenedor de sprites */
        this.sprites = new ArrayList<PImage>();

        /* --------- Cargar sprites del Pico — EDITABLE ---------- */
        sprites.add(loadImage("pico1.png"));
        sprites.add(loadImage("pico2.png"));
        sprites.add(loadImage("pico3.png"));
    }


    /* ============================================================
       ============================ ACTUALIZAR ====================
       ============================================================ */

    /*
     * Maneja animación + movimiento horizontal + caída vertical.
     * dt = delta time en segundos.
     */
    @Override
    public void actualizar(float dt) {

        /* ---------------- ANIMACIÓN ---------------- */
        tiempoAnim += dt;
        if (tiempoAnim >= velocidadAnim) {
            tiempoAnim = 0;

            frameActual++;
            if (frameActual >= sprites.size()) {
                frameActual = 0; /* vuelta al inicio del ciclo */
            }
        }

        /* ----------- ACTUALIZACIÓN HORIZONTAL ----------- */
        super.actualizar(dt);

        /* ---------------- CAÍDA VERTICAL ---------------- */
        y += velocidadCaida * dt;
    }


    /* ============================================================
       ============================== DIBUJAR ======================
       ============================================================ */

    /*
     * Dibuja el frame actual en pantalla.
     * Previene errores si la lista de sprites queda vacía.
     */
    @Override
    public void dibujar() {

        if (sprites.isEmpty()) return;

        PImage actual = sprites.get(frameActual);
        image(actual, x, y, ancho, alto);
    }


    /* ============================================================
       ========================= ZONA EDITABLE ====================
       ============================================================ */

    /* Cambiar la velocidad de caída en tiempo real */
    public void setVelocidadCaida(float nuevaVel) {
        this.velocidadCaida = nuevaVel;
    }

    /* Cambiar la velocidad de la animación */
    public void setVelocidadAnim(float nuevaVel) {
        this.velocidadAnim = nuevaVel;
    }
}
