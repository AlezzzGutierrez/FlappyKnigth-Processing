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

    // ============================================================================
    // CONSTRUCTOR — Inicializa todos los datos importantes del personaje
    // ============================================================================
    public Escudero(String nombre) {

        /*
           super(...) llama al constructor de Jugador
           ------------------------------------------
           • nombre del jugador
           • color identificatorio (azul intenso)
           • Este color puede usarse para barras, UI, glow, etc.
        */
        super(nombre, color(#1B08FF));

        // Tamaño visible del personaje
        this.ancho = 128;
        this.alto  = 100;

        /*
            CARGA DE SPRITES
            ----------------
            spriteNormal   → forma estándar
            spriteEspecial → se activa en habilidades y saltos
        */
        spriteNormal   = loadImage("cabEscudero1.png");
        spriteEspecial = loadImage("cabEscudero2.png");
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
        for (int i = 1; i <= 8; i++) {
            animacionZ.add(loadImage("cabEscuderoHabZ" + i + ".png"));
        }

        // Sprites habilidad X (ejemplo: 10 frames)
        for (int i = 1; i <= 7; i++) {
            animacionX.add(loadImage("cabEscuderoHabX" + i + ".png"));
        }
    }

    // ============================================================================
    // SALTO — Cambia al sprite especial durante 1 segundo
    // ============================================================================
    @Override
    public void presionarSpace() {
        // Ejecuta la lógica base del salto (de Jugador)
        super.presionarSpace();

        /*
           Activar sprite especial:
           ------------------------
           spriteActual cambia SOLO TEMPORALMENTE.

           tiempoSpriteEspecial:
           ---------------------
           Un temporizador en Jugador va restando dt.
           Cuando llega a 0, vuelve al spriteNormal.
        */
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;  // EDITABLE (duración del glow)
    }

    // ============================================================================
    // HABILIDAD Z — "Golpe Escudado"
    // ============================================================================
    @Override
    protected void habilidadZ() {
        // Chequeo simple: stamina insuficiente → no ejecutar
        if (getStamina() < 4) return;
        consumirStamina(4);

        sonidos.reproducirSonidoEscudo();

        /*
            Interacción con niveles
            -----------------------
            nivelActual.eliminarObstaculoMasCercano(this);

            • Busca el obstáculo más cercano al jugador.
            • Lo elimina del nivel.
            • Este método usa distancias matemáticas internas del nivel.
        */
        if (nivelActual != null) {
            nivelActual.eliminarObstaculoMasCercano(this);
        }

        // Activar animación Z
        animacionActiva = animacionZ;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " realiza un GOLPE ESCUDADO (elimina 1 obstáculo cercano)");
    }

    // ============================================================================
    // HABILIDAD X — "Escudo Divino" = Inmunidad temporal
    // ============================================================================
    @Override
    protected void habilidadX() {
        if (getStamina() < 11) return;
        consumirStamina(11);

        sonidos.reproducirSonidoEscudos();

        /*
            activarInmunidad(tiempo)
            ------------------------
            • Habilita un FLAG interno en Jugador que evita recibir daño.
            • El tiempo se descuenta con dt.
        */
        activarInmunidad(8.0f);   // EDITABLE (8 segundos)

        // Activar animación X
        animacionActiva = animacionX;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " levanta su ESCUDO DIVINO (invulnerable por 8 segundos)");
    }

    // ============================================================================
    // ACTUALIZAR — controla física y animaciones
    // ============================================================================
   @Override
public void actualizar(float dt) {
    super.actualizar(dt);  // física + controles + inmunidad

    // Animaciones propias del Escudero
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
