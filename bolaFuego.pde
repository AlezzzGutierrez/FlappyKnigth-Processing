/* 
============================================================
====================== BOLA DE FUEGO =======================
============================================================

 Objeto enemigo vivo que persigue al jugador durante un tiempo,
 animado mediante sprites que cambian cada cierto intervalo.

 Usa:
 - PVector para posición
 - PVector para tamaño
 - PVector para velocidad
 - Animación basada en tiempo (deltaTime)
 - Encapsulación en variables privadas
 
 Todo está comentado y organizado por bloques.
 Puede modificarse sin romper el comportamiento general.
============================================================
*/

public class BolaFuego extends ObstaculoVivo {

    /* ============================================================
       =============== VARIABLES INTERNAS Y ANIMACIÓN ==============
       ============================================================ */

    /* Lista de sprites para animación */
    private final ArrayList<PImage> sprites = new ArrayList<>();

    /* Control del tiempo entre frames */
    private float tiempoAnimacion = 0f;

    /* Tiempo entre frames (EDITABLE: velocidad de animación) */
    private float velocidadFrame = 0.12f;

    /* Frame actual de la animación */
    private int frameActual = 0;


    /* ============================================================
       ========================= CONSTRUCTOR =======================
       ============================================================ */

    public BolaFuego(float x, float y) {
        super(
            x, y,
            55, 55,         /* Tamaño editable */
            180,            /* Velocidad editable */
            25,             /* Daño editable */
            2.5f            /* Tiempo siguiendo al jugador editable */
        );

        /* Cargar sprites de la animación 
           (puedes agregar más cuadros si deseas) */
        sprites.add(loadImage("bolaLava1.png"));
        sprites.add(loadImage("bolaLava2.png"));
    }


    /* ============================================================
       ======================= ACTUALIZAR =========================
       ============================================================ */

    @Override
    public void actualizar(float dt, Jugador jugador) {
        /* Actualiza movimiento y seguimiento del padre */
        super.actualizar(dt, jugador);

        /* ------ Actualizar animación con deltaTime ------ */
        tiempoAnimacion += dt;

        if (tiempoAnimacion >= velocidadFrame) {

            tiempoAnimacion = 0;

            /* Avanza al siguiente frame */
            frameActual++;

            /* Si pasa el límite → volver al inicio (loop) */
            if (frameActual >= sprites.size()) {
                frameActual = 0;
            }
        }
    }


    /* ============================================================
       =========================== DIBUJAR ========================
       ============================================================ */


@Override
public void dibujar() {

    /* Si no hay sprites cargados, no dibujar */
    if (sprites.isEmpty()) return;

    /* Sprite actual de la animación */
    PImage frame = sprites.get(frameActual);

    /* Dibujar usando la posición REAL heredada del padre */
    image(frame, x, y, ancho, alto);
}



    /* ============================================================
       ===================== MÉTODOS EDITABLES ====================
       ============================================================ */

    /* Cambiar velocidad de animación */
    public void setVelocidadAnimacion(float nuevaVelocidad) {
        this.velocidadFrame = nuevaVelocidad;
    }

    /* Reemplazar sprites desde afuera (si deseas usar otros) */
    public void setSprites(ArrayList<PImage> nuevosSprites) {
        sprites.clear();
        sprites.addAll(nuevosSprites);
        frameActual = 0;
    }
}
