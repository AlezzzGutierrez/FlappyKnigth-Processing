/* ============================================================================================
   CLASE: EscenaPersonalizacion
   --------------------------------------------------------------------------------------------
   - Clase independiente, pero DEPENDIENTE de:
       - Boton
       - GestorSonidos
       - GestorJugadorActual
       - Subclases de Jugador (Caballero, Arquero, Mago, Escudero)

   - Controla:
       - Pantalla de personalización
       - Visualización de clase actual
       - Reroll de clase
       - Información y habilidades por clase

   - NO utiliza PVectors → usa coordenadas float estándar.
     (NOTA: si se planea ampliar con animaciones o interpolaciones, se recomienda migrar a PVectors)

   - Código editable → puedes añadir clases nuevas, cambiar UI, agregar transiciones, etc.
   ============================================================================================ */

class EscenaPersonalizacion {

    /* ============================================================================================
       BLOQUE 1 — ATRIBUTOS PRINCIPALES
       --------------------------------------------------------------------------------------------
       Encapsulados en private.
       Representan botones, sonido, jugador, imágenes y texto dinámico.
       ============================================================================================ */

    private Boton btnVolver;
    private Boton btnReroll;

    private GestorSonidos sonidos;
    private GestorJugadorActual gestorJugador;

    private PImage fondo;
    private PImage tituloPersonalizacion;

    // Texto dinámico que se actualiza cuando el jugador hace reroll
    private String textoClaseObtenida = "";


    /* ============================================================================================
       BLOQUE 2 — CONSTRUCTOR
       --------------------------------------------------------------------------------------------
       Instancia todas las variables necesarias.
       Se asegura de que NO hayan atributos sin inicializar.
       ============================================================================================ */

    public EscenaPersonalizacion(GestorSonidos gestor, GestorJugadorActual gestorJugador) {

        this.sonidos = gestor;
        this.gestorJugador = gestorJugador;

        // — Imágenes principales —
        fondo = loadImage("menu_personalizacion.png");
        tituloPersonalizacion = loadImage("Personalizacion.png");

        // — Botones —
        btnVolver = new Boton(width/2 - 100, 500, 200, 60, "VOLVER", sonidos);
        btnReroll = new Boton(width/2 - 120, 420, 240, 60, "REROLL CLASS", sonidos);
    }


    /* ============================================================================================
       BLOQUE 3 — MÉTODO PRINCIPAL: DIBUJAR ESCENA
       --------------------------------------------------------------------------------------------
       dt → delta time (aunque esta escena no usa animaciones dependientes de dt)
       
       Orden lógico del dibujado:
           1) Fondo
           2) Título
           3) Cuadrado negro + sprite de clase
           4) Texto: clase actual
           5) Cuadro de probabilidades
           6) Cuadro de habilidades
           7) Texto del resultado del último reroll
           8) Botones
       
       NOTA: El sistema no usa PVector → toda posición es calculada por coordenadas directas.
       ============================================================================================ */

    public void dibujar(float dt) {

        /* ---- 1) Fondo ---- */
        imageMode(CORNER);
        image(fondo, 0, 0, width, height);

        /* ---- 2) Título ---- */
        imageMode(CENTER);
        image(tituloPersonalizacion, width/2, 150, 500, 250);


        /* ========================================================================================
           3) SPRITE DE LA CLASE DEL JUGADOR
           ======================================================================================== */

        Jugador j = gestorJugador.getJugador();

        // Cuadrado negro (100×100) centrado
        fill(0);
        noStroke();
        rect(width/2 - 70, 210, 130, 130, 10);

        // — Selección de sprite según la clase —
        PImage spriteClase = null;

        if (j instanceof Caballero) spriteClase = loadImage("iconSword.png");
        if (j instanceof Arquero)   spriteClase = loadImage("iconArco.png");
        if (j instanceof Mago)      spriteClase = loadImage("iconMago.png");
        if (j instanceof Escudero)  spriteClase = loadImage("iconEscudo.png");

        // — Dibujar sprite centrado —
        if (spriteClase != null) {
            imageMode(CENTER);
            image(spriteClase, width/2, 275, 120, 106);
        }


        /* ========================================================================================
           4) TEXTO: CLASE ACTUAL
           ======================================================================================== */
        fill(colorTextoClase(j));  // color dinámico por clase
        textSize(28);
        textAlign(CENTER, CENTER);
        text("Clase actual: " + nombreClase(j), width/2, 390);


        /* ========================================================================================
           5) CUADRADO DE PROBABILIDADES
           ======================================================================================== */
        fill(0);
        rect(width - 150, 200, 120, 140, 10);

        fill(255);
        textSize(16);
        textAlign(LEFT, TOP);
        text("Clases\nDisponibles:\n\n"
           + "- Caballero 25%\n"
           + "- Arquero 25%\n"
           + "- Escudero 25%\n"
           + "- Mago 25%",
           width - 140, 210);


        /* ========================================================================================
           6) CUADRADO IZQUIERDO: HABILIDADES POR CLASE
           ======================================================================================== */
        fill(0);
        rect(30, 200, 150, 150, 10);

        fill(255);
        textSize(13);
        textAlign(LEFT, TOP);

        String habilidades = obtenerTextoHabilidades(j);
        text(habilidades, 40, 210);


        /* ========================================================================================
           7) TEXTO FINAL: REROLL RESULTADO
           ======================================================================================== */
        fill(0);
        rect(width/2 - 150, 360, 300, 40, 8);

        fill(255);
        textSize(20);
        textAlign(CENTER, CENTER);

        if (textoClaseObtenida.equals("")) {
            text("Eres un: Caballero", width/2, 380);
        } else {
            text("Eres un: " + textoClaseObtenida, width/2, 380);
        }


        /* ========================================================================================
           8) BOTONES DE LA ESCENA
           ======================================================================================== */
        btnReroll.dibujar();
        btnVolver.dibujar();
    }


    /* ============================================================================================
       BLOQUE 4 — DETECTAR ACCIONES DEL USUARIO
       --------------------------------------------------------------------------------------------
       Devuelve:
           - "VOLVER" si el usuario presiona el botón volver
           - null si no hay cambio de escena
       ============================================================================================ */

    public String detectarAccion() {

        // Botón REROLL
        if (btnReroll.fuePresionado()) {
            gestorJugador.rerollearClase();
            Jugador j = gestorJugador.getJugador();
            textoClaseObtenida = nombreClase(j);
        }

        // Botón VOLVER
        if (btnVolver.fuePresionado()) {
            sonidos.reproducirMusicaMenu();
            return "VOLVER";
        }

        return null;
    }


    /* ============================================================================================
       BLOQUE 5 — COLOR DEL TEXTO SEGÚN CLASE
       ============================================================================================ */

    private color colorTextoClase(Jugador j) {

        if (j instanceof Caballero) return color(255);               // blanco
        if (j instanceof Arquero)   return color(255, 150, 0);       // naranja
        if (j instanceof Escudero)  return color(0, 150, 255);       // azul
        if (j instanceof Mago)      return color(255, 100, 255);     // rosa

        return color(255);
    }


    /* ============================================================================================
       BLOQUE 6 — TEXTO DE HABILIDADES POR CLASE
       --------------------------------------------------------------------------------------------
       Cada clase tiene su propio texto descriptivo.
       ============================================================================================ */

    private String obtenerTextoHabilidades(Jugador j) {

        if (j instanceof Caballero) {
            return "Habilidades:\n"
                 + "[ Z ] Corte:\n"
                 + "Elimina enemigos\n"
                 + "y obstaculos cercanos\n\n"
                 + "[ X ] Ráfaga:\n"
                 + "Golpea enemigos\n"
                 + "a larga distancia";
        }

        if (j instanceof Arquero) {
            return "Habilidades:\n"
                 + "[ Z ] Disparo:\n"
                 + "Elimina enemigos lejanos\n\n"
                 + "[ X ] Ataque veloz:\n"
                 + "Golpea 4 enemigos\n"
                 + "y obstaculos lejanos";
        }

        if (j instanceof Escudero) {
            return "Habilidades:\n"
                 + "[ Z ] Lanzar escudo:\n"
                 + "Elimina el enemigo\n"
                 + "más cercano\n\n"
                 + "[ X ] Escudo:\n"
                 + "Inmune 8 segundos";
        }

        if (j instanceof Mago) {
            return "Habilidades:\n"
                 + "[ Z ] Curar:\n"
                 + "Recupera 15 de vida\n\n"
                 + "[ X ] Explosión:\n"
                 + "Elimina 20 enemigos";
        }

        return "";
    }


    /* ============================================================================================
       BLOQUE 7 — OBTENER NOMBRE DE LA CLASE
       ============================================================================================ */

    private String nombreClase(Jugador j) {

        if (j instanceof Caballero) return "Caballero";
        if (j instanceof Arquero)   return "Arquero";
        if (j instanceof Mago)      return "Mago";
        if (j instanceof Escudero)  return "Escudero";

        return "Desconocida";
    }
}
