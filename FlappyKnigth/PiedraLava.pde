/* ============================================================
   ======================== CLASE PIEDRALAVA ====================
   ============================================================

   • Clase HEREDADA de Obstaculo.
   • Es un objeto dependiente del motor de colisiones y físicas
     definido en la clase padre.

   • NO usa PVectores:
       Actualmente usa (float x, y). Si se desea un sistema más
       robusto de físicas, colisiones o interpolaciones suaves,
       habría que migrar a PVector para posición y velocidad.

   • Maneja animación cuadro por cuadro + caída vertical.
   • Variables encapsuladas y correctamente inicializadas.
   • Todo está dividido por bloques claramente comentados.
   • Parametrizable / editable (velocidad, daño, tamaño, animación).
   ============================================================ */

public class PiedraLava extends Obstaculo {

    /* ============================================================
       ======================= VARIABLES PRIVADAS ==================
       ============================================================ */

    /* Velocidad vertical de caída (px/seg) — EDITABLE */
    private float velocidadCaida;

    /* Lista de sprites para la animación */
    private ArrayList<PImage> sprites;

    /* Control de animación */
    private float tiempoAnim;
    private float velocidadAnim;   // segundos por frame — EDITABLE
    private int frameActual;


    /* ============================================================
       ============================ CONSTRUCTOR ===================
       ============================================================ */

    /*
     * Configura la piedra de lava:
     *  - Llama al constructor de Obstaculo con tamaño, daño y vel. horizontal.
     *  - Inicializa todas las variables internas.
     *  - Carga los sprites animados.
     */
    public PiedraLava(float x, float y) {

        super(
            x, y,        /* posición */
            40, 40,      /* tamaño del sprite */
            210,         /* velocidad horizontal */
            10           /* daño (EDITABLE) */
        );

        /* Inicializar valores propios */
        this.velocidadCaida = 90f;
        this.velocidadAnim = 0.15f;
        this.tiempoAnim = 0f;
        this.frameActual = 0;

        /* Inicializar contenedor de sprites */
        this.sprites = new ArrayList<PImage>();

        /* Carga de sprites — EDITABLE */
        sprites.add(loadImage("piedraLava1.png"));
        sprites.add(loadImage("piedraLava2.png"));
    }


    /* ============================================================
       ============================ ACTUALIZAR ====================
       ============================================================ */

    /*
     * Actualiza animación + movimiento.
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
                frameActual = 0;  /* ciclo infinito */
            }
        }

        /* --------- ACTUALIZACIÓN HORIZONTAL DEL PADRE ---------- */
        super.actualizar(dt);

        /* ---------------- CAÍDA VERTICAL ---------------- */
        y += velocidadCaida * dt;
    }


    /* ============================================================
       ============================== DIBUJAR ======================
       ============================================================ */

    /*
     * Dibuja el frame actual.
     * Si se borran los sprites por error, evita crashear.
     */
    @Override
    public void dibujar() {

        if (sprites.isEmpty()) return;

        PImage actual = sprites.get(frameActual);
        image(actual, x, y, ancho, alto);
    }


    /* ============================================================
       ======================= ZONA EDITABLE ======================
       ============================================================ */

    /* Permite cambiar la velocidad de caída desde afuera */
    public void setVelocidadCaida(float nuevaVel) {
        this.velocidadCaida = nuevaVel;
    }

    /* Permite cambiar la velocidad de animación */
    public void setVelocidadAnim(float nuevaVel) {
        this.velocidadAnim = nuevaVel;
    }
}
