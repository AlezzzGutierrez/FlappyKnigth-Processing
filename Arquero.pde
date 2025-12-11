// ============================================================================
// ARQUERO — CLASE HIJA DE Jugador (con animaciones estilo Escudero)
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

public class Arquero extends Jugador {

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
    // CONSTRUCTOR — Inicializa todos los datos importantes del personaje
    // ============================================================================
    public Arquero(String nombre) {
        super(nombre, color(#FFBE08)); // color característico del arquero

        this.ancho = 128;
        this.alto  = 100;

        // Sprites base
        spriteNormal   = loadImage("cabArquero1.png");
        spriteEspecial = loadImage("cabArquero2.png"); // sprite alternativo
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
        for (int i = 1; i <= 6; i++) {
            animacionZ.add(loadImage("cabMagoHabZ" + i + ".png"));
        }

        // Sprites habilidad X (ejemplo: 8 frames)
        for (int i = 1; i <= 8; i++) {
            animacionX.add(loadImage("cabMagoHabX" + i + ".png"));
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
    // HABILIDAD Z — Flecha Exacta
    // ============================================================================
    @Override
    protected void habilidadZ() {
        if (getStamina() < 3) return;
        consumirStamina(3);

        sonidos.reproducirSonidoFlecha();

        if (nivelActual != null) {
            nivelActual.eliminarObstaculoMasCercano(this);
        }

        // Activar animación Z
        animacionActiva = animacionZ;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " dispara una FLECHA EXACTA (elimina 1 obstáculo cercano)");
    }

    // ============================================================================
    // HABILIDAD X — Lluvia de Flechas
    // ============================================================================
    @Override
    protected void habilidadX() {
        if (getStamina() < 9) return;
        consumirStamina(9);

        sonidos.reproducirSonidoFlechas();

        if (nivelActual != null) {
            nivelActual.eliminar4ObstaculosMasCercanos(this);
        }

        // Activar animación X
        animacionActiva = animacionX;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " usa LLUVIA DE FLECHAS (elimina 4 obstáculos cercanos)");
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
