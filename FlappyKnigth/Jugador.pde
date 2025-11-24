
// ============================================================
// =============== CLASE BASE PARA TODOS LOS JUGADORES ========
// ============================================================
public abstract class Jugador {

    // ============================================================
    // ---------------------- ATRIBUTOS ----------------------------
    // ============================================================

    // --- Estadísticas ---
    private int vida = 100;

    // STAMINA configurada en 60
    private int stamina = 60;
    private int staminaMax = 60;

    private float tiempoParaRegenerar = 0;

    private String nombre;
    protected int colorJugador;

    // --- Movimiento (usando PVector simple) ---
    private PVector pos;       // posición (punto de contacto / suelo)
    private PVector vel;       // velocidad aplicada cada frame

    // fuerza simple de salto (valor intuitivo)
    private float fuerzaSalto = 12;

    // empuje constante hacia abajo (pvector simplificado -> pixels por segundo)
    private PVector empujeAbajo;

    private boolean teclaSpacePresionada = false;

    private float ancho = 40;
    private float alto  = 40;

    // límites de la escena
    public static final float TECHO = 100;
    public static final float PISO  = 500;
    
    protected NivelBase nivelActual;
    
    // ======================
// ------ INMUNIDAD -----
// ======================
private boolean esInvulnerable = false;
private float tiempoInvulnerableRestante = 0;

    
    // ---------------------- ATRIBUTOS ----------------------------

// ... (otros atributos)
private boolean zPresionada = false;
private boolean xPresionada = false;




    // ============================================================
    // ----------------------- CONSTRUCTOR -------------------------
    // ============================================================
    public Jugador(String nombre, int colorJugador) {

        this.nombre = nombre;
        this.colorJugador = colorJugador;

        // posición inicial en el "suelo"
        pos = new PVector(50, PISO);

        // velocidad inicial en 0
        vel = new PVector(0, 0);

        // empuje hacia abajo: pequeño valor constante que baja al jugador suavemente
        // interpretamos este vector como "pixels/segundo" hacia abajo.
        empujeAbajo = new PVector(0, 20); // 40 px/s hacia abajo — ajustable
    }

    // ============================================================
    // ----------------------- GETTERS -----------------------------
    // ============================================================
    public int getVida() { return vida; }
    public String getNombre() { return nombre; }
    public int getColor() { return colorJugador; }

    // hitbox de colisión (pos representa el "piso" del jugador)
    public float getHitboxX() { return pos.x; }
    public float getHitboxY() { return pos.y - alto; }
    public float getHitboxW() { return ancho; }
    public float getHitboxH() { return alto; }

    public PVector getPos() { return pos.copy(); }
    public float getAncho() { return ancho; }
    public float getAlto() { return alto; }


    // ============================================================
    // ---------------- MATEMÁTICA BÁSICA --------------------------
    // ============================================================
    public void recibirDanio(int d) {

    if (esInvulnerable) return; // NO recibe daño

    vida -= d;
    if (vida < 0) vida = 0;

    // Inmunidad natural de 1 segundo después de recibir daño
    activarInmunidad(1.0f);
}


    public void curar(int c) {
        vida += c;
        if (vida > 100) vida = 100;
    }
    
    public void asignarNivel(NivelBase nivel) {
    this.nivelActual = nivel;
}


    // ============================================================
    // ---------------- REGENERAR STAMINA --------------------------
    // ============================================================
    public void regenerarStamina(float dt) {

        tiempoParaRegenerar += dt;

        if (tiempoParaRegenerar >= 1.0f) {
            tiempoParaRegenerar = 0;

            stamina++;
            if (stamina > staminaMax) stamina = staminaMax;
        }
    }


    // ============================================================
    // ------------------ SALTAR (CONTROL) -------------------------
    // ============================================================
public void presionarSpace() {

    if (!teclaSpacePresionada) {

        if (stamina > 0) {

            stamina--;            // gasta 1 de verdad
            vel.y = -fuerzaSalto; // salto
        }

        teclaSpacePresionada = true;
    }
}


    public void soltarSpace() {
        teclaSpacePresionada = false;
    }


    // ============================================================
    // ------------------ ACTUALIZAR FÍSICA ------------------------
    // ============================================================
    // dt en segundos. Aquí aplicamos:
    //  1) el empujeAbajo constante (pvector),
    //  2) la velocidad actual (vel) que contiene el salto,
    //  3) límites de techo y piso,
    //  4) atenuación simple de la velocidad para que no quede "pegada".
    public void actualizarFisica(float dt) {

        // 1) aplicar empuje abajo (empuje * dt como desplazamiento)
        // usamos add( empujeAbajo * dt ) al vector de velocidad para integrarlo
        // de forma simple (como si sumaras un pequeño desplazamiento hacia abajo cada frame).
        PVector downStep = empujeAbajo.copy();
        downStep.mult(dt);         // convertimos px/s -> px para este frame
        // sumarlo directamente a la posición produce un "arrastre" constante,
        // pero lo hacemos a la velocidad para conservar la coherencia con el salto:
        vel.add(downStep);

        // 2) aplicar velocidad a la posición (vel es px para este frame si vel ya fue escalada, aquí vel representa px)
        // Para mantenerlo sencillo: interpretamos vel como px/frame ya que empuje se escaló por dt.
        pos.add(vel);

        // 3) atenuar un poco la velocidad para evitar acumulaciones infinitas
        vel.mult(0.9f);

        // 4) límites: piso y techo (no permitir salir)
        if (pos.y > PISO) {
            pos.y = PISO;
            vel.y = 0;
        }

        if (pos.y - alto < TECHO) {
            pos.y = TECHO + alto;
            vel.y = 0;
        }
    }


    // ============================================================
    // ------------------ DIBUJAR BARRAS ---------------------------
    // ============================================================
    // dibuja arriba a la izquierda: vida encima, stamina debajo
    public void dibujarBarras() {

        // fondo gris para que se vea mejor (opcional)
        noStroke();
        fill(40);
        rect(12, 12, 220, 44, 6);

        // Vida (rojo)
        fill(255, 0, 0);
        rect(20, 20, vida * 2, 15);   // ancho proporcional a vida (0-100) -> 0-200px

        // Stamina (azul) justo debajo
        fill(0, 150, 255);
        // como staminaMax = 60, escalamos para que la barra tenga un tamaño razonable
        float anchoStamina = map(stamina, 0, staminaMax, 0, 180); // 180px ancho máximo
        rect(20, 40, anchoStamina, 12);
    }


    // ============================================================
    // ------------------ DIBUJAR JUGADOR --------------------------
    // ============================================================
    public void dibujar() {
        fill(colorJugador);
        rect(pos.x, pos.y - alto, ancho, alto);
    }


    // ============================================================
    // ---------- MÉTODOS ABSTRACTOS DE HABILIDADES ----------------
    // ============================================================
    protected abstract void habilidadZ();
    protected abstract void habilidadX();
    
    public void setVida(int v) {
    vida = v;
}

public void setStamina(int s) {
    stamina = s;
}

public void resetearPosicion() {
    pos = new PVector(50, PISO);
    vel = new PVector(0, 0);
}

public int getStamina() {
    return stamina;
}

public void consumirStamina(int cantidad) {
    stamina -= cantidad;
    if (stamina < 0) stamina = 0;
}


// ============================================================
// ACTIVAR INMUNIDAD POR "segundos"
// ============================================================
public void activarInmunidad(float segundos) {
    esInvulnerable = true;
    tiempoInvulnerableRestante = segundos;
}

// ============================================================
// ACTUALIZAR INMUNIDAD CADA FRAME
// ============================================================
public void actualizarInmunidad(float dt) {

    if (!esInvulnerable) return;

    tiempoInvulnerableRestante -= dt;

    if (tiempoInvulnerableRestante <= 0) {
        esInvulnerable = false;
        tiempoInvulnerableRestante = 0;
    }
}

public boolean estaInvulnerable() {
    return esInvulnerable;
}


    // ============================================================
    // ------------------ CONTROLES JUGADOR ------------------------
    // ============================================================
public void actualizarControles() {

    // ----------------------- SALTO ------------------------
    if (keyPressed && key == ' ') {
        presionarSpace();
    } else {
        soltarSpace();
    }

    // --------------------- HABILIDAD Z ---------------------
    if (keyPressed && (key == 'z' || key == 'Z')) {

        if (!zPresionada) { 
            // Se ejecuta una sola vez al presionar
            habilidadZ();  
            zPresionada = true;
        }

    } else {
        // Se libera cuando la tecla Z deja de estar presionada
        zPresionada = false;
    }

    // --------------------- HABILIDAD X ---------------------
    if (keyPressed && (key == 'x' || key == 'X')) {

        if (!xPresionada) { 
            // Se ejecuta una sola vez al presionar
            habilidadX();
            xPresionada = true;
        }

    } else {
        // Se libera cuando se suelta la tecla X
        xPresionada = false;
    }
}


}
