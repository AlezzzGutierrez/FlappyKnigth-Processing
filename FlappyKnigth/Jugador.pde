// ============================================================
// =============== CLASE BASE PARA TODOS LOS JUGADORES ========
// ============================================================

/*
   Esta clase es:
   ✔ Abstracta (no se puede instanciar)
   ✔ Base / Padre para jugadores específicos
   ✔ Dependiente de Processing (usa PImage, PVector, keyPressed, etc.)
   ✔ Usa PVectors (IMPORTANTE: ya trabaja en sistema vectorial)
   ✔ Editada para documentar matemáticas, comportamiento y atributos
*/

public abstract class Jugador {

    // ============================================================
    // ---------------------- ATRIBUTOS ----------------------------
    // ============================================================

    /* ----------- ESTADÍSTICAS PRINCIPALES ----------- */
    private int vida = 100;  // vida actual del jugador

    /* ----------- CONTROL DE SPRITES ----------- */
    protected PImage spriteNormal;
    protected PImage spriteEspecial;
    protected PImage spriteActual;

    protected float tiempoSpriteEspecial = 0; // duración del sprite temporal
    
    // ---------------- ESCUDO VISUAL (PARA CLASE ESCUDERO) ----------------
protected boolean mostrarEscudoVisual = false;
protected float tiempoEscudoVisual = 0;
protected float timerColorEscudo = 0;
protected int colorEscudoActual;


    /* ----------- STAMINA ----------- */
    private int stamina = 60;
    private int staminaMax = 60;
    private float tiempoParaRegenerar = 0;

    /* ----------- IDENTIDAD ----------- */
    private String nombre;
    protected int colorJugador;

    /* ----------- MOVIMIENTO (USA PVECTORES) ----------- */
    /* 
       pos:    posición del jugador (coord. de piso)
       vel:    velocidad aplicada cada frame
       empujeAbajo: gravedad simplificada en px/s
    */
    protected PVector pos;
    private PVector vel;
    private PVector empujeAbajo;

    private float fuerzaSalto = 12; // salto simple
    private boolean teclaSpacePresionada = false;

    /* ----------- TAMAÑO FÍSICO ----------- */
    protected float ancho = 20;
    protected float alto  = 20;

    /* ----------- LÍMITES ESCENA ----------- */
    public static final float TECHO = 100;
    public static final float PISO  = 500;

    /* ----------- NIVEL ASIGNADO ----------- */
    protected NivelBase nivelActual;

    /* ----------- INVULNERABILIDAD ----------- */
    private boolean esInvulnerable = false;
    private float tiempoInvulnerableRestante = 0;

    /* ----------- CONTROLES Z/X ----------- */
    private boolean zPresionada = false;
    private boolean xPresionada = false;


    // ============================================================
    // ----------------------- CONSTRUCTOR -------------------------
    // ============================================================

    public Jugador(String nombre, int colorJugador) {

        this.nombre = nombre;
        this.colorJugador = colorJugador;

        /* PVectors inicializados en el constructor (correcto OOP) */
      
        pos = new PVector(10, height/2);
vel = new PVector(0, 0);
        empujeAbajo = new PVector(0, 10); // gravedad simple (px/s)
    }


    // ============================================================
    // ----------------------- GETTERS -----------------------------
    // ============================================================

    public int getVida() { return vida; }
    public String getNombre() { return nombre; }
    public int getColor() { return colorJugador; }

    /* Hitbox dependiente de la posición */
// Reducido arriba 30px y derecha 15px
public float getHitboxX() { 
    return pos.x + 30; 
}

public float getHitboxY() { 
    return pos.y - alto + 30; 
}

public float getHitboxW() { 
    return ancho - 35; 
}

public float getHitboxH() { 
    return alto - 70; 
}



    public PVector getPos() { return pos.copy(); }
    public float getAncho() { return ancho; }
    public float getAlto() { return alto; }


    // ============================================================
    // ---------------- MATEMÁTICA BÁSICA (DAÑO/CURA) -------------
    // ============================================================

    public void recibirDanio(int d) {

        if (esInvulnerable) return;

        vida -= d;
        if (vida < 0) vida = 0;

        activarInmunidad(1.0f); // matemáticamente: tiempo en segundos
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

        /* dt = tiempo en segundos → regeneración 1 por segundo */
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
          
          vel.y = -fuerzaSalto; // salto simple

            teclaSpacePresionada = true;
        }
    }

    public void soltarSpace() {
        teclaSpacePresionada = false;
    }


    // ============================================================
    // ------------------ ACTUALIZAR FÍSICA ------------------------
    // ============================================================

    /*
       Matemática usada:
       - empujeAbajo (px/s) * dt → desplazamiento en px/frame
       - vel += empuje
       - pos += vel
       - vel *= 0.9 (fricción/apagado)
    */

    public void actualizarFisica(float dt) {

        // 1) gravedad real escalada por dt
        PVector downStep = empujeAbajo.copy();
        downStep.mult(dt);
        vel.add(downStep);

        // 2) movimiento
        pos.add(vel);

        // 3) fricción simple
        vel.mult(0.9f);

        // 4) límites físicos
        if (pos.y > PISO) { pos.y = PISO; vel.y = 0; }
        if (pos.y - alto < TECHO) { pos.y = TECHO + alto; vel.y = 0; }

        // 5) sprite especial
        if (tiempoSpriteEspecial > 0) {
            tiempoSpriteEspecial -= dt;
            if (tiempoSpriteEspecial <= 0) spriteActual = spriteNormal;
        }
        
        // ESCUDO VISUAL TEMPORAL
if (mostrarEscudoVisual) {
    tiempoEscudoVisual -= dt;
    if (tiempoEscudoVisual <= 0) {
        mostrarEscudoVisual = false;
    }
}

    }


    // ============================================================
    // ------------------ DIBUJAR BARRAS ---------------------------
    // ============================================================

    public void dibujarBarras() {

        /* Marco gris */
        noStroke();
        fill(40);
        rect(12, 12, 220, 70, 6);   // ← aumentado a 70px para agregar textos

        /* ---------------- VIDA ---------------- */
        fill(255, 0, 0);
        rect(20, 20, vida * 2, 15);

        fill(255);
        textSize(14);
        text("Vida: " + vida, 50, height - 60);  // ← texto dentro del rect

        /* ---------------- STAMINA ---------------- */
        fill(0, 150, 255);
        float anchoStamina = map(stamina, 0, staminaMax, 0, 180);
        rect(20, 40, anchoStamina, 12);

        fill(255);
        text("Stamina: " + stamina, 50, height - 30);   // ← debajo de Vida

        /* ---------------- CONTROLES ---------------- */
        text("Controles: Z, X, SPACE", width - 100, height - 30);
    }


    // ============================================================
    // ------------------ DIBUJAR JUGADOR --------------------------
    // ============================================================

public void dibujar() {

    // ----------------- DIBUJAR SPRITE -----------------
    if (spriteActual != null) {
        image(spriteActual, pos.x, pos.y - alto, ancho, alto);
    } else {
        fill(colorJugador);
        rect(pos.x, pos.y - alto, ancho, alto);
    }

    // ----------------- DIBUJAR ESCUDO VISUAL -----------------
    if (mostrarEscudoVisual) {

        // Cambiar color cada 1 segundo
        timerColorEscudo -= 1.0 / frameRate;
        if (timerColorEscudo <= 0) {
            timerColorEscudo = 0.2;
            if (colorEscudoActual == color(0, 0, 255, 190))
                colorEscudoActual = color(100, 200, 255, 190);
            else
                colorEscudoActual = color(0, 0, 255, 190);
        }

        float diametro = alto + 35;

        noStroke();
        fill(colorEscudoActual);
        ellipse(pos.x + ancho/2, pos.y - alto/2, diametro, diametro);
    }
}


    // ============================================================
    // -------- MÉTODOS ABSTRACTOS DE HABILIDADES -----------------
    // ============================================================

    protected abstract void habilidadZ();
    protected abstract void habilidadX();


    // ============================================================
    // ---------------------- SETTERS EXTRA ------------------------
    // ============================================================

    public void setVida(int v) { vida = v; }
    public void setStamina(int s) { stamina = s; }

  public void resetearPosicion() {
   pos = new PVector(10, height/2);
    vel = new PVector(0, 0);
}

    public int getStamina() { return stamina; }

    public void consumirStamina(int c) {
        stamina -= c;
        if (stamina < 0) stamina = 0;
    }


    // ============================================================
    // ------------------- INVULNERABILIDAD -------------------------
    // ============================================================

    public void activarInmunidad(float segundos) {
        esInvulnerable = true;
        tiempoInvulnerableRestante = segundos;
    }

    public void actualizarInmunidad(float dt) {
        if (!esInvulnerable) return;
        tiempoInvulnerableRestante -= dt;
        if (tiempoInvulnerableRestante <= 0) {
            esInvulnerable = false;
            tiempoInvulnerableRestante = 0;
        }
    }

    public boolean estaInvulnerable() { return esInvulnerable; }


    // ============================================================
    // ------------------ CONTROLES JUGADOR ------------------------
    // ============================================================

    public void actualizarControles() {

        // SALTO
        if (keyPressed && key == ' ') presionarSpace();
        else soltarSpace();

        // HABILIDAD Z
        if (keyPressed && (key == 'z' || key == 'Z')) {
            if (!zPresionada) { habilidadZ(); zPresionada = true; }
        } else zPresionada = false;

        // HABILIDAD X
        if (keyPressed && (key == 'x' || key == 'X')) {
            if (!xPresionada) { habilidadX(); xPresionada = true; }
        } else xPresionada = false;
    }

}
