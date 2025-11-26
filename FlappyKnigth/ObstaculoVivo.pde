/* 
=====================================================================
======================== CLASE OBSTACULOVIVO ========================
=====================================================================

 • CLASE ABSTRACTA — NO puede instanciarse directamente.
 • HEREDA de Obstaculo → depende completamente de su lógica base
   (posición, tamaño, daño, colisión y actualización estándar).
 • Representa obstaculos ENEMIGOS que poseen "inteligencia mínima":
     - Siguen al jugador por un tiempo
     - Luego continúan moviéndose en la última dirección conocida

 • Esta clase SÍ usa PVECTORES porque:
     - Trabaja con direcciones normalizadas y posiciones relativas
     - Facilita el cálculo de movimiento y vectores diferencia

 • Todas las variables están encapsuladas como protected
   porque deben ser accesibles por las subclases.

 • Código dividido EN BLOQUES, limpio, matemáticamente simple y editable.

=====================================================================
*/

public abstract class ObstaculoVivo extends Obstaculo {

    /* ============================================================
       ==================== VARIABLES PROTEGIDAS ==================
       ============================================================ */

    /* Tiempo total que seguirá al jugador — EDITABLE */
    protected float duracionSeguimiento;

    /* Tiempo transcurrido siguiendo al jugador */
    protected float tiempoSiguiendo = 0;

    /* Última posición almacenada del jugador (PVector obligatorio) */
    protected PVector ultimaPosicionJugador;

    /* Dirección hacia la que seguirá moviéndose cuando deje de seguir */
    protected PVector ultimaDireccion = new PVector(0, 0);

    /* Velocidad de movimiento — EDITABLE */
    protected float velocidadMovimiento;


    /* ============================================================
       =========================== CONSTRUCTOR ==================== 
       ============================================================ */

    /*
     * Inicializa un obstáculo con comportamiento de "persecución".
     * Parámetros:
     *  - x, y            → posición inicial
     *  - ancho, alto     → tamaño en pantalla
     *  - velocidadMov    → velocidad en seguimiento y movimiento final
     *  - danio           → daño al jugador
     *  - duracionSeg     → tiempo total de persecución
     */
    public ObstaculoVivo(
        float x, float y,
        float ancho, float alto,
        float velocidadMovimiento,
        int danio,
        float duracionSeguimiento
    ) {
        super(
            x, y,
            ancho, alto,
            0,          /* No usa velocidad horizontal del Obstaculo base */
            danio
        );

        this.velocidadMovimiento    = velocidadMovimiento;
        this.duracionSeguimiento    = duracionSeguimiento;

        /* Se inicializa la última posición del jugador en la posición actual */
        this.ultimaPosicionJugador  = new PVector(x, y);
    }


    /* ============================================================
       =========================== ACTUALIZAR =====================
       ============================================================ */

    /*
     * Lógica principal:
     *   1. Durante "duracionSeguimiento" sigue al jugador.
     *   2. Luego continúa moviéndose en la última dirección normalizada.
     */
    public void actualizar(float dt, Jugador jugador) {

        tiempoSiguiendo += dt;

        if (tiempoSiguiendo <= duracionSeguimiento) {

            /* --- Guardar la posición del jugador --- */
            ultimaPosicionJugador = jugador.getPos().copy();

            /* --- Calcular dirección hacia el jugador --- */
            PVector posActual = new PVector(x, y);
            PVector dir = PVector.sub(ultimaPosicionJugador, posActual);

            /* Evitar normalizar vectores demasiado pequeños */
            if (dir.mag() > 1) {
                dir.normalize();
                ultimaDireccion = dir.copy();   // Guardar para movimiento futuro
            }

            moverHacia(ultimaPosicionJugador, dt);

        } else {
            /* Ya no sigue → continuar en la última dirección guardada */
            moverDireccionFija(dt);
        }
    }


    /* ============================================================
       ====================== MÉTODOS DE MOVIMIENTO ===============
       ============================================================ */

    /*
     * Mueve al obstáculo hacia un destino dado usando PVectors.
     */
    private void moverHacia(PVector destino, float dt) {

        PVector posActual = new PVector(x, y);
        PVector dir = PVector.sub(destino, posActual);

        if (dir.mag() < 1) return;    // objetivo muy cerca → evitar jitter

        dir.normalize();
        dir.mult(velocidadMovimiento * dt);

        x += dir.x;
        y += dir.y;
    }

    /*
     * Movimiento continuo en la última dirección conocida
     * luego de haber terminado la persecución.
     */
    private void moverDireccionFija(float dt) {
        x += ultimaDireccion.x * velocidadMovimiento * dt;
        y += ultimaDireccion.y * velocidadMovimiento * dt;
    }


    /* ============================================================
       ======================== ZONA EDITABLE =====================
       ============================================================ */

    /* Cambiar tiempo de seguimiento */
    public void setDuracionSeguimiento(float nuevaDuracion) {
        this.duracionSeguimiento = nuevaDuracion;
    }

    /* Cambiar la velocidad del enemigo */
    public void setVelocidadMovimiento(float nuevaVelocidad) {
        this.velocidadMovimiento = nuevaVelocidad;
    }
}
