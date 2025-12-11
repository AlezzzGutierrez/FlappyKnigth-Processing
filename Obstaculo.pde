/* ============================================================================
   CLASE ABSTRACTA: Obstaculo
   ============================================================================
   Esta clase ES BASE / PADRE de todos los tipos de obstáculos.
   Las subclases (como ObstaculoBasico, ObstaculoVivo, ObstaculoQueCae, etc.)
     dependen de ella completamente.

   Actualmente NO usa PVectors → se recomienda migrar en el futuro
     por claridad y evitar manejo manual de x / y.

   Proporciona:
       - Posición, tamaño, velocidad, daño.
       - Movimiento estándar horizontal.
       - Detección de colisión rectangular.
       - Sistema de inmunidad del jugador (1 seg).
       - Método abstracto dibujar().
   ============================================================================ */

public abstract class Obstaculo {

    /* ---------------------------------------------------------
       BLOQUE: ATRIBUTOS PRINCIPALES
       ---------------------------------------------------------
       Todos se encuentran con protección 'protected' para 
       permitir acceso directo a subclases sin exponerlos públicamente.
       --------------------------------------------------------- */

    // Posición del obstáculo en el eje cartesiano
    protected float x;
    protected float y;

    // Dimensiones del obstáculo
    protected float ancho;
    protected float alto;

    // Velocidad horizontal hacia la izquierda (px/seg)
    protected float velocidad;

    // Cantidad de daño que causa al jugador en colisión
    protected int danio;

    /* ---------------------------------------------------------
       BLOQUE: CONTROL DE DAÑO E INMUNIDAD
       ---------------------------------------------------------
       tiempoUltimoDaño → almacena cuándo fue el último daño 
       infligido al jugador.
       Se inicia en -1000 para forzar que el primer daño 
       siempre sea aplicado correctamente.
       --------------------------------------------------------- */
    private float tiempoUltimoDaño = -1000;


    /* ---------------------------------------------------------
       BLOQUE: CONSTRUCTOR
       ---------------------------------------------------------
       Recibe todas las propiedades esenciales del obstáculo y
       las inicializa. No se requieren más inicializaciones.
       ---------------------------------------------------------
       Matemática: simple asignación (no interviene cálculo).
       --------------------------------------------------------- */
    public Obstaculo(float x, float y, float ancho, float alto, float velocidad, int danio) {
        this.x = x;
        this.y = y;
        this.ancho = ancho;
        this.alto = alto;
        this.velocidad = velocidad;
        this.danio = danio;
    }


    /* ============================================================================
       BLOQUE: ACTUALIZACIÓN (MOVIMIENTO)
       ============================================================================
       dt = deltaTime (tiempo en segundos entre frames)
       
       Movimiento:
       - El obstáculo se desplaza a la izquierda usando:
           
           nuevaX = x - velocidad * dt

       Simplicidad matemática:
         Es una ecuación de movimiento rectilíneo uniforme.
         No hay aceleración, ni interpolación.
       ============================================================================ */
    public void actualizar(float dt) {
        x -= velocidad * dt;
    }


    /* ============================================================================
       BLOQUE: COLISIÓN RECTANGULAR (AABB)
       ============================================================================
       colisionaConJugador() utiliza detección de colisión tipo AABB:
       
       • No colisionan SI uno está completamente a la izquierda/derecha/arriba/abajo
       
       Matemática usada:
           Comprobaciones lógicas de intervalos:
           
           (jx + jw < x) → jugador a la izquierda
           (jx > x + ancho) → jugador a la derecha
           (jy + jh < y) → jugador arriba
           (jy > y + alto) → jugador abajo

       Devolución:
       - true → hay solapamiento
       - false → no hay colisión
       ============================================================================ */
    public boolean colisionaConJugador(float jx, float jy, float jw, float jh) {
        return !(jx + jw < x || jx > x + ancho ||
                 jy + jh < y || jy > y + alto);
    }


    /* ============================================================================
       BLOQUE: APLICAR DAÑO CON SISTEMA DE INMUNIDAD
       ============================================================================
       tiempoActual → proviene del gameLoop.

       Lógica:
         1. Si no pasó al menos 1 segundo desde el último daño,
            no se daña al jugador.
         
         2. Si pasó el tiempo suficiente → se aplica daño.
         
       Matemática:
         tiempoActual - tiempoUltimoDaño < 1.0f
         → comparación directa de tiempos.
       ============================================================================ */
    public void aplicarDañoSiCorresponde(Jugador jugador, float tiempoActual) {
        
        if (tiempoActual - tiempoUltimoDaño < 1.0f) {
            return;
        }

        jugador.recibirDanio(danio);
        tiempoUltimoDaño = tiempoActual;
    }


    /* ============================================================================
       BLOQUE: UTILIDADES Y GETTERS
       ============================================================================ */

    // Saber si ya salió completamente de pantalla por la izquierda
    public boolean fueraDePantalla() {
        return x + ancho < 0;
    }

    // GETTERS (encapsulación correcta — solo lectura)
    public int getDanio() { return danio; }
    public float getX() { return x; }
    public float getY() { return y; }
    public float getAncho() { return ancho; }
    public float getAlto() { return alto; }


    /* ============================================================================
       MÉTODO ABSTRACTO OBLIGATORIO EN SUBCLASES
       ============================================================================
       Cada tipo de obstáculo debe implementar cómo se dibuja.
       Ejemplo: sprite animado, imagen única, forma geométrica, etc.
       ============================================================================ */
    public abstract void dibujar();
}
