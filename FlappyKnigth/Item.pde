// ============================================================
// ========================== ITEM BASE ========================
// ============================================================
//
// Clase abstracta para cualquier ítem del juego.
//
// Un ítem funciona igual que un obstáculo básico:
//     - Se mueve hacia la izquierda
//     - Tiene tamaño y velocidad
//     - Desaparece al llegar al borde
//     - Detecta colisión rectangular simple
//
// Además tiene efectos configurables:
//     - puntosVida (puede ser + o -)
//     - puntosStamina (puede ser + o -)
//
// ============================================================

public abstract class Item {

    // ----- Posición -----
    protected float x;
    protected float y;

    // ----- Tamaño -----
    protected float ancho;
    protected float alto;

    // ----- Movimiento -----
    protected float velocidad;  // px por segundo hacia la izquierda

    // ----- Efectos -----
    protected int puntosVida;      // positivo o negativo
    protected int puntosStamina;   // positivo o negativo
    // ----- Imagen ----
    protected PImage sprite;

    public Item(
        float x, float y,
        float ancho, float alto,
        float velocidad,
        int puntosVida,
        int puntosStamina,
        String rutaImagen
        
    ) {
        this.x = x;
        this.y = y;
        this.ancho = ancho;
        this.alto = alto;

        this.velocidad = velocidad;

        this.puntosVida = puntosVida;
        this.puntosStamina = puntosStamina;
        if(rutaImagen!=null){
          sprite =loadImage(rutaImagen);
        }
    }

    // ============================================================
    // ------------------------ ACTUALIZAR ------------------------
    // ============================================================
    public void actualizar(float dt) {
        x -= velocidad * dt;  // igual que obstáculo
    }

    // ============================================================
    // ------------------------- COLISIÓN --------------------------
    // ============================================================
    public boolean colisionaConJugador(float jx, float jy, float jw, float jh) {
        return !(jx + jw < x || jx > x + ancho ||
                 jy + jh < y || jy > y + alto);
    }

    // ============================================================
    // ------------------------ APLICAR EFECTO ---------------------
    // ============================================================
    public void aplicarEfecto(Jugador jugador) {

        if (puntosVida != 0) {
            if (puntosVida > 0) jugador.curar(puntosVida);
            else jugador.recibirDanio(-puntosVida);
        }

        if (puntosStamina != 0) {
            jugador.setStamina(jugador.stamina + puntosStamina);
        }
    }

    // ============================================================
    // --------------------------- ESTADO --------------------------
    // ============================================================
    public boolean fueraDePantalla() {
        return x + ancho < 0;
    }

    // ============================================================
    // ---------------------- MÉTODO ABSTRACTO --------------------
    // ============================================================
    public abstract void dibujar();
}
