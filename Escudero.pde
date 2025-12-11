// ============================================================================
// ESCUDERO — CLASE HIJA DE Jugador (orientado a objetos, con animaciones estilo Caballero)
// ============================================================================

/*
    INFORMACIÓN IMPORTANTE SOBRE ESTA CLASE
    ---------------------------------------
    • Esta clase ESPECIALIZA a Jugador (herencia directa).
    • Sobrescribe métodos para personalizar habilidades y comportamiento.
    • Usa coordenadas heredadas desde Jugador (pos, vel, etc.).
    • Es independiente de escenas, UI o niveles, pero depende de:
          - sistema de sonido
          - sistema de niveles (nivelActual)
    • Todo su comportamiento visual depende de sprites externos.
    • Ahora incluye animaciones frame a frame para habilidades Z y X.
    • Se agregó un círculo translúcido como escudo visual durante la habilidad X.
*/

public class Escudero extends Jugador {

    // ============================================================================
    // ATRIBUTOS DE ANIMACIÓN
    // ============================================================================
    private ArrayList<PImage> animacionZ;
    private ArrayList<PImage> animacionX;
    private ArrayList<PImage> animacionActiva;
    private int frameActual;
    private float tiempoAnim;
    private float velocidadAnim;
    private boolean volverASpriteNormal;

    // ---------------- ESCUDO VISUAL SIMPLE ----------------
    private boolean mostrarEscudoVisual = false;
    private float tiempoEscudoVisual = 0f;
    
    // --- PARPADEO DEL ESCUDO ---
private float timerColorEscudo = 0f;
private boolean colorAlternado = false;


    // ============================================================================
    // CONSTRUCTOR — Inicializa todos los datos importantes del personaje
    // ============================================================================
    public Escudero(String nombre) {
        super(nombre, color(#1B08FF));

        this.ancho = 128;
        this.alto  = 100;

        spriteNormal   = loadImage("cabEscudero1.png");
        spriteEspecial = loadImage("cabEscudero2.png");
        spriteActual   = spriteNormal;

        animacionZ = new ArrayList<PImage>();
        animacionX = new ArrayList<PImage>();
        animacionActiva = null;
        frameActual = 0;
        tiempoAnim = 0f;
        velocidadAnim = 0.1f;
        volverASpriteNormal = false;

        for (int i = 1; i <= 8; i++) {
            animacionZ.add(loadImage("cabEscuderoHabZ" + i + ".png"));
        }
        for (int i = 1; i <= 7; i++) {
            animacionX.add(loadImage("cabEscuderoHabX" + i + ".png"));
        }
    }

    // ============================================================================
    // SALTO — Cambia al sprite especial durante 1 segundo
    // ============================================================================
    @Override
    public void presionarSpace() {
        super.presionarSpace();
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;
    }

    // ============================================================================
    // HABILIDAD Z — "Golpe Escudado"
    // ============================================================================
    @Override
    protected void habilidadZ() {
        if (getStamina() < 4) return;
        consumirStamina(4);

        sonidos.reproducirSonidoEscudo();
        if (nivelActual != null) {
            nivelActual.eliminarObstaculoMasCercano(this);
        }

        animacionActiva = animacionZ;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " realiza un GOLPE ESCUDADO (elimina 1 obstáculo cercano)");
    }

    // ============================================================================
    // HABILIDAD X — "Escudo Divino" = Inmunidad temporal + círculo visual
    // ============================================================================
    @Override
    protected void habilidadX() {
        if (getStamina() < 11) return;
        consumirStamina(11);

        sonidos.reproducirSonidoEscudos();
        activarInmunidad(8.0f);

        animacionActiva = animacionX;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        // 🔵 Activar escudo visual
        mostrarEscudoVisual = true;
        tiempoEscudoVisual = 8.0f; // mismo tiempo que la inmunidad

        println(getNombre() + " levanta su ESCUDO DIVINO (invulnerable por 8 segundos)");
    }

    // ============================================================================
    // ACTUALIZAR — controla física, animaciones y escudo visual
    // ============================================================================
    @Override
    public void actualizar(float dt) {
        super.actualizar(dt);
        
        // --- Alternar color cada 0.5 segundos ---
if (mostrarEscudoVisual) {
    timerColorEscudo += dt;
    if (timerColorEscudo >= 0.5f) {
        timerColorEscudo = 0f;
        colorAlternado = !colorAlternado; // alternar entre true/false
    }
}


        if (animacionActiva != null && !animacionActiva.isEmpty()) {
            tiempoAnim += dt;
            if (tiempoAnim >= velocidadAnim) {
                tiempoAnim = 0f;
                frameActual++;
                if (frameActual >= animacionActiva.size()) {
                    animacionActiva = null;
                    frameActual = 0;
                    if (volverASpriteNormal) {
                        spriteActual = spriteNormal;
                        volverASpriteNormal = false;
                    }
                }
            }
        }

        // ⏳ Escudo visual countdown
        if (mostrarEscudoVisual) {
            tiempoEscudoVisual -= dt;
            if (tiempoEscudoVisual <= 0f) {
                mostrarEscudoVisual = false;
            }
        }
    }

    // ============================================================================
    // DIBUJAR — muestra sprite/animación + círculo translúcido si escudo activo
    // ============================================================================
    @Override
    public void dibujar() {
        if (animacionActiva != null && !animacionActiva.isEmpty()) {
            image(animacionActiva.get(frameActual), pos.x, pos.y - alto, ancho, alto);
        } else {
            image(spriteActual, pos.x, pos.y - alto, ancho, alto);
        }

        // Escudo visual simple
        // Escudo visual simple
if (mostrarEscudoVisual) {
    pushStyle();
    noStroke();

    if (colorAlternado) {
        fill(0, 120, 255, 120);   // 🔵 azul
    } else {
        fill(80, 200, 255, 120);  // 🔹 celeste
    }

    float diametro = alto + 40;
    ellipse(pos.x + ancho / 2f, pos.y - alto / 2f, diametro, diametro);
    popStyle();
}

    }
}
