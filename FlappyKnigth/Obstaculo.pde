// ============================================================
// ==================== CLASE ABSTRACTA OBSTÁCULO =============
// ============================================================
public abstract class Obstaculo {

    // =======================
    // ------ ATRIBUTOS ------
    // =======================

    // Posición del obstáculo
    protected float x;
    protected float y;

    // Tamaño del cuadrado
    protected float ancho;
    protected float alto;

    // Velocidad hacia la izquierda
    protected float velocidad;

    // Daño que causa al jugador
    protected int danio;

    // Control de inmunidad del jugador (1 segundo)
    private float tiempoUltimoDaño = -1000; // muy antiguo para permitir daño al inicio

    // =======================
    // ----- CONSTRUCTOR -----
    // =======================
    public Obstaculo(float x, float y, float ancho, float alto, float velocidad, int danio) {
        this.x = x;
        this.y = y;
        this.ancho = ancho;
        this.alto = alto;
        this.velocidad = velocidad;
        this.danio = danio;
    }

    // ============================================================
    // ======================= ACTUALIZAR ==========================
    // ============================================================

    // dt = deltaTime
    public void actualizar(float dt) {
        // Movimiento sencillo hacia la izquierda:
        // nuevaX = x - (vel * dt)
        x -= velocidad * dt;
    }

    // ============================================================
    // ======================= COLISIÓN ============================
    // ============================================================

    // Colisión rectangular simple
    public boolean colisionaConJugador(float jx, float jy, float jw, float jh) {
        return !(jx + jw < x || jx > x + ancho ||
                 jy + jh < y || jy > y + alto);
    }

    // Aplicar daño si corresponde → con inmunidad
    public void aplicarDañoSiCorresponde(Jugador jugador, float tiempoActual) {
        
        // ¿aún está en tiempo de inmunidad?
        if (tiempoActual - tiempoUltimoDaño < 1.0f) {
            return; // todavía es inmune
        }

        // Aplica daño
        jugador.recibirDanio(danio);

        // Guardamos el tiempo del último daño
        tiempoUltimoDaño = tiempoActual;
    }

    // ============================================================
    // =================== ESTADO / GETTERS ========================
    // ============================================================

    public boolean fueraDePantalla() {
        return x + ancho < 0;
    }

    public int getDanio() { return danio; }
    public float getX() { return x; }
    public float getY() { return y; }
    public float getAncho() { return ancho; }
    public float getAlto() { return alto; }

    // ============================================================
    // ================== MÉTODO ABSTRACTO DIBUJAR =================
    // ============================================================
    public abstract void dibujar();
}
