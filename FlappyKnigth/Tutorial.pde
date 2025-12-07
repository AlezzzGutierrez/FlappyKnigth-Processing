/* ======================================================
                   CLASE TUTORIAL
   ------------------------------------------------------
   • Muestra imágenes + textos
   • No usa jugador
   • Avanza con ENTER
   • Cuando termina → vuelve al menú
   ====================================================== */

class Tutorial {

    private ArrayList<String> textos;
    private ArrayList<PImage> imagenes;

    private int indice = 0;

    /* ----------- CONSTRUCTOR ----------- */
    public Tutorial(GestorJugadorActual gestor) {

        textos = new ArrayList<String>();
        imagenes = new ArrayList<PImage>();

        // -------------------------------
        // 👇 AGREGA TUS TEXTOS AQUÍ
        // -------------------------------
        textos.add("¡Bienvenido al Tutorial!");
        textos.add("Usa SPACE para saltar.");
        textos.add("Usa Z y X para tus habilidades.");
        textos.add("Evita los obstáculos y administra tu stamina.");
        textos.add("Cuando estés listo, vuelve al menú y comienza tu aventura.");

        // -------------------------------
        // 👇 CARGA LAS IMÁGENES AQUÍ 
        // (Debe haber tantas imágenes como textos)
        // -------------------------------
        imagenes.add(loadImage("TutorialMenu.jpeg"));
        imagenes.add(loadImage("TutorialMenu2.jpeg"));
        imagenes.add(loadImage("TutorialMenu3.jpeg"));
        imagenes.add(loadImage("TutorialMenu4.jpeg"));
        imagenes.add(loadImage("TutorialMenu5.png"));
    }

    /* ----------- REINICIAR ----------- */
    public void reiniciar() {
        indice = 0;
    }

    /* ----------- AVANZAR TEXTO ----------- */
    public boolean avanzarTexto() {
        indice++;

        // Si terminó todas las diapositivas → volver al menú
        return indice >= textos.size();
    }

    /* ----------- DIBUJAR ----------- */
    public void dibujar(float dt) {

        background(0);  

        // -------------------------------------------------
        // DIBUJAR IMAGEN 400x500 EN EL CENTRO
        // -------------------------------------------------
        PImage img = imagenes.get(indice);

        if (img != null) {
            imageMode(CENTER);
            image(img, width/2, height/2 - 40, 400, 500);
        }

        // -------------------------------------------------
        // RECTÁNGULO INFERIOR PARA EL TEXTO
        // -------------------------------------------------
        fill(0, 180);
        noStroke();
        rect(0, height - 150, width, 150);

        // -------------------------------------------------
        // TEXTO ACTUAL
        // -------------------------------------------------
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(26);

        String t = textos.get(indice);
        text(t, width/2, height - 105);

        // -------------------------------------------------
        // INDICADOR DE CONTINUAR
        // -------------------------------------------------
        fill(200);
        textSize(18);
        text("Presiona ENTER para continuar", width/2, height - 45);
    }
}
