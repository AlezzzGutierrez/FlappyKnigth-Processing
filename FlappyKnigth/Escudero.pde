// ============================================================================
// ESCUDERO — CLASE HIJA DE Jugador (orientado a objetos)
// ============================================================================

/*
    INFORMACIÓN IMPORTANTE SOBRE ESTA CLASE
    ---------------------------------------
    • Esta clase ESPECIALIZA a Jugador (herencia directa).
    • Sobrescribe métodos para personalizar habilidades y comportamiento.
    • NO utiliza PVectores → solo usa coordenadas heredadas desde Jugador.
    • Es independiente de escenas, UI o niveles, pero depende de:
          - sistema de sonido
          - sistema de niveles (nivelActual)
    • Todo su comportamiento visual depende de sprites externos.
*/

public class Escudero extends Jugador {

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
        this.ancho = 110;
        this.alto  = 110;

        /*
            CARGA DE SPRITES
            ----------------
            spriteNormal   → forma estándar
            spriteEspecial → se activa en habilidades y saltos
        */
        spriteNormal   = loadImage("Esc1.png");
        spriteEspecial = loadImage("cab2.png");

        // Sprite inicial (siempre el normal)
        spriteActual = spriteNormal;
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

        // Activar sprite especial temporal
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;

        // Reproducción de sonido (dependencia del GestorSonidos)
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

        println(getNombre() +
            " realiza un GOLPE ESCUDADO (elimina 1 obstáculo cercano)");
    }

    // ============================================================================
    // HABILIDAD X — "Escudo Divino" = Inmunidad temporal
    // ============================================================================
    @Override
protected void habilidadX() {

    if (getStamina() < 11) return;
    consumirStamina(11);

    spriteActual = spriteEspecial;
    tiempoSpriteEspecial = 1.0f;

    sonidos.reproducirSonidoEscudos();

    activarInmunidad(8.0f);

    // ----------------- ACTIVAR ESCUDO VISUAL -----------------
    mostrarEscudoVisual = true;
    tiempoEscudoVisual = 8.0f;  // mismo tiempo que la habilidad

    // Color inicial (azul 75% opacidad)
    colorEscudoActual = color(0, 0, 255, 190);

    // Arranca el timer de cambio de color
    timerColorEscudo = 1.0f;

    println(getNombre() +
        " levanta su ESCUDO DIVINO (invulnerable por 8 segundos)");
}

}
