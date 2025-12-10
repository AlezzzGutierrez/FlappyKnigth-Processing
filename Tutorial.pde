/* ======================================================
                   CLASE TUTORIAL (solo imágenes con for)
   ------------------------------------------------------
   • CLASE CONCRETA — No hereda de otras.
   • Función principal:
       - Muestra una secuencia de imágenes adaptadas
       - No usa jugador ni físicas
       - Avanza con la tecla ENTER
       - Cuando termina → vuelve al menú principal
   • Uso típico:
       - Se instancia al inicio del juego
       - Sirve como introducción visual para el jugador
   ====================================================== */

class Tutorial {

    /* ======================================================
       ==================== ATRIBUTOS =======================
       ====================================================== */

    // Lista de imágenes mostradas en secuencia
    private ArrayList<PImage> imagenes;

    // Índice actual de la diapositiva (imagen)
    private int indice = 0;


    /* ======================================================
       ==================== CONSTRUCTOR =====================
       ====================================================== */

    /*
     * Inicializa el tutorial cargando automáticamente
     * las imágenes numeradas TutorialMenu1.png → TutorialMenu7.png.
     * 
     * Parámetros:
     *   gestor → gestor del jugador actual (no usado aquí,
     *             pero se mantiene por consistencia)
     */
    public Tutorial(GestorJugadorActual gestor) {
        imagenes = new ArrayList<PImage>();

        // Cargar automáticamente las 7 imágenes adaptadas
        for (int i = 1; i <= 7; i++) {
            PImage img = loadImage("TutorialMenu" + i + ".png"); 
            imagenes.add(img);
        }
    }


    /* ======================================================
       ==================== REINICIAR =======================
       ====================================================== */

    /*
     * Reinicia el tutorial al primer índice.
     * Útil cuando se vuelve a mostrar desde cero.
     */
    public void reiniciar() {
        indice = 0;
    }


    /* ======================================================
       ==================== AVANZAR =========================
       ====================================================== */

    /*
     * Avanza al siguiente índice de imagen.
     * Devuelve true si ya terminó todas las imágenes
     * y debe volver al menú.
     */
    public boolean avanzar() {
        if (indice < imagenes.size() - 1) {
            indice++;
            return false; // aún quedan imágenes
        } else {
            return true;  // ya terminó el tutorial
        }
    }


    /* ======================================================
       ==================== DIBUJAR =========================
       ====================================================== */

    /*
     * Renderiza en pantalla:
     *   - Imagen central (tal cual su tamaño original)
     *   - Indicador opcional de continuar
     * 
     * Parámetros:
     *   dt → deltaTime (no usado aquí, pero se mantiene
     *         por consistencia con otras clases)
     */
    public void dibujar(float dt) {
        background(0);

        // Mostrar la imagen tal cual su tamaño original
        PImage img = imagenes.get(indice);
        if (img != null) {
            imageMode(CENTER);
            image(img, width/2, height/2);
        }

        // Indicador opcional
        fill(200);
        textAlign(CENTER, CENTER);
        textSize(18);
        text("Presiona ENTER para continuar", width/2, height - 45);
    }
}
