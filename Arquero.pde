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
    • Incluye animaciones frame a frame para habilidades Z y X.
    • Ahora las animaciones pueden repetirse varias veces (ejemplo: habilidad X se repite 3 veces).
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

    // Control de repeticiones
    private int repeticionesAnim;        // cuántas veces repetir la animación activa
    private int repeticionesRealizadas;  // cuántas veces ya se repitió

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

        repeticionesAnim = 1;
        repeticionesRealizadas = 0;

        // Sprites habilidad Z (ejemplo: 12 frames)
        for (int i = 1; i <= 12; i++) {
            animacionZ.add(loadImage("cabArqueroHabZ" + i + ".png"));
        }

        // Sprites habilidad X (ejemplo: 5 frames)
        for (int i = 1; i <= 5; i++) {
            animacionX.add(loadImage("cabArqueroHabX" + i + ".png"));
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

        // Activar animación Z (una sola vez)
        animacionActiva = animacionZ;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;
        repeticionesAnim = 1;
        repeticionesRealizadas = 0;

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

        // Activar animación X (repetida 3 veces)
        animacionActiva = animacionX;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;
        repeticionesAnim = 3;           // repetir 3 veces
        repeticionesRealizadas = 0;

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
                    frameActual = 0;
                    repeticionesRealizadas++;
                    if (repeticionesRealizadas >= repeticionesAnim) {
                        animacionActiva = null;
                        if (volverASpriteNormal) {
                            spriteActual = spriteNormal;
                            volverASpriteNormal = false;
                        }
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
