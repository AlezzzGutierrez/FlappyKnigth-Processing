// ============================================================================
// CABALLERO — CLASE HIJA DE Jugador (con animaciones estilo Espadachín)
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

public class Caballero extends Jugador {

    // ============================================================================
    // ATRIBUTOS DE ANIMACIÓN
    // ============================================================================
    private ArrayList<PImage> animacionZ;
    private ArrayList<PImage> animacionX;
    private ArrayList<PImage> animacionActiva;
    private int frameActual;
    private float tiempoAnim;
    private float velocidadAnim;
    private boolean volverASpriteNormal; // bandera para resetear al terminar

    // Control de repeticiones
    private int repeticionesAnim;        // cuántas veces repetir la animación activa
    private int repeticionesRealizadas;  // cuántas veces ya se repitió

    // ============================================================================
    // CONSTRUCTOR — Inicializa todos los datos importantes del personaje
    // ============================================================================
    public Caballero(String nombre) {
        super(nombre, color(#17DFE8)); // color característico del caballero

        this.ancho = 128;
        this.alto  = 100;

        // Sprites base
        spriteNormal   = loadImage("cabSword1.png");
        spriteEspecial = loadImage("cabSword2.png");
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

        // Sprites habilidad Z (ejemplo: 6 frames)
        for (int i = 1; i <= 6; i++) {
            animacionZ.add(loadImage("cabSwordHabZ" + i + ".png"));
        }

        // Sprites habilidad X (ejemplo: 12 frames)
        for (int i = 1; i <= 12; i++) {
            animacionX.add(loadImage("cabSwordHabX" + i + ".png"));
        }
    }

    // ============================================================================
    // HABILIDAD Z — Tajada Pesada
    // ============================================================================
    @Override
    protected void habilidadZ() {
        if (getStamina() < 5) return;
        consumirStamina(5);

        sonidos.reproducirCorte();

        float rango = getAncho() + 65;
        if (nivelActual != null) {
            nivelActual.eliminarObstaculosCercanos(this, rango);
        }

        // Activar animación Z (una sola vez)
        animacionActiva = animacionZ;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;
        repeticionesAnim = 1;
        repeticionesRealizadas = 0;

        println(getNombre() + " usa TAJADA PESADA");
    }

    // ============================================================================
    // HABILIDAD X — Golpe Terremoto
    // ============================================================================
    @Override
    protected void habilidadX() {
        if (getStamina() < 15) return;
        consumirStamina(15);

        sonidos.reproducirCortes();

        if (nivelActual != null) {
            nivelActual.eliminarObstaculosEnRangoCaballero(this);
        }

        // Activar animación X (repetida 3 veces)
        animacionActiva = animacionX;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;
        repeticionesAnim = 3;           // repetir 3 veces
        repeticionesRealizadas = 0;

        println(getNombre() + " usa GOLPE TERREMOTO");
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
    // ACTUALIZAR — controla física y animaciones
    // ============================================================================
    public void actualizar(float dt) {
        actualizarFisica(dt);

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

        // 🔴 Debug: dibujar hitbox encima del sprite
        //dibujarHitbox();
    }
}
