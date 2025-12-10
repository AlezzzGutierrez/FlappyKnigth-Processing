// ============================================================================
// MAGO — CLASE HIJA DE Jugador (con animaciones estilo Escudero)
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
*/

public class Mago extends Jugador {

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

    // ============================================================================
    // CONSTRUCTOR
    // ============================================================================
    public Mago(String nombre) {
        super(nombre, color(#FE08FF)); // color rosado característico

        this.ancho = 128;
        this.alto  = 100;

        // Sprites base
        spriteNormal   = loadImage("cabMago1.png");
        spriteEspecial = loadImage("cabMago2.png"); // usa otro sprite para especial
        spriteActual   = spriteNormal;

        // Inicialización de animaciones
        animacionZ = new ArrayList<PImage>();
        animacionX = new ArrayList<PImage>();
        animacionActiva = null;
        frameActual = 0;
        tiempoAnim = 0f;
        velocidadAnim = 0.1f;
        volverASpriteNormal = false;

        // Sprites habilidad Z (ejemplo: 6 frames)
        for (int i = 1; i <= 9; i++) {
            animacionZ.add(loadImage("cabMagoHabX" + i + ".png"));
        }

        // Sprites habilidad X (ejemplo: 10 frames)
        for (int i = 1; i <= 15; i++) {
            animacionX.add(loadImage("cabMagoHabZ" + i + ".png"));
        }
    }

    // ============================================================================
    // SALTO — activa sprite especial temporal
    // ============================================================================
    @Override
    public void presionarSpace() {
        super.presionarSpace();
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;
    }

    // ============================================================================
    // HABILIDAD Z — Curación Arcana
    // ============================================================================
    @Override
    protected void habilidadZ() {
        if (getStamina() < 5) return;
        consumirStamina(5);

        sonidos.reproducirSonidoCurar();
        curar(15);

        // Activar animación Z
        animacionActiva = animacionZ;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " canaliza ENERGÍA ARCANA (+15 vida)");
    }

    // ============================================================================
    // HABILIDAD X — Tormenta Cósmica
    // ============================================================================
    @Override
    protected void habilidadX() {
        if (getStamina() < 15) return;
        consumirStamina(15);

        sonidos.reproducirSonidoCurar2();

        if (nivelActual != null) {
            nivelActual.eliminar20ObstaculosMasCercanos(this);
        }

        // Activar animación X
        animacionActiva = animacionX;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " desata TORMENTA CÓSMICA (destruye 20 obstáculos)");
    }

    // ============================================================================
    // ACTUALIZAR — controla física y animaciones
    // ============================================================================
    @Override
    public void actualizar(float dt) {
        super.actualizar(dt); // física + controles + inmunidad

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
    }

    // ============================================================================
    // DIBUJAR — muestra sprite o animación activa
    // ============================================================================
    @Override
    public void dibujar() {
        if (animacionActiva != null && !animacionActiva.isEmpty()) {
            image(animacionActiva.get(frameActual), pos.x, pos.y - alto, ancho, alto);
        } else {
            image(spriteActual, pos.x, pos.y - alto, ancho, alto);
        }

        // 🔴 Debug: dibujar hitbox encima
        //dibujarHitbox();
    }
}
