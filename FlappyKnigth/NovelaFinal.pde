/* ============================================================
   CLASE: NovelaFinal
   ============================================================ */
class NovelaFinal {

    /* ------------------------------------------------------------
       ATRIBUTOS PRIVADOS
       ------------------------------------------------------------ */
    private ArrayList<PaginaNovela> paginas;
    private int paginaActual;
    private Boton btnSiguiente;
    private Boton btnSaltear;    // <<--- NUEVO BOTÓN
    private GestorSonidos sonidos;

    /* ============================================================
       CONSTRUCTOR
       ============================================================ */
    public NovelaFinal(GestorSonidos sonidos) {

        this.sonidos = sonidos;
        this.paginaActual = 0;

        paginas = new ArrayList<PaginaNovela>();

        /* Cargar imágenes del final */
        for (int i = 1; i <= 14; i++) {
            PImage img = loadImage("fin" + i + ".jpg");
            paginas.add(new PaginaNovela(img));
        }

        /* Botón SIGUIENTE */
        btnSiguiente = new Boton(
            width - 180,
            height - 90,
            160,
            60,
            "SIGUIENTE",
            sonidos
        );

        /* ------------------------------------------------------------
           Botón SALTEAR (nuevo)
           Más pequeño y en la parte superior derecha
           ------------------------------------------------------------ */
        btnSaltear = new Boton(
            width - 150,   // X
            20,            // Y
            130,           // ancho
            45,            // alto
            "SALTEAR",
            sonidos
        );
    }

    /* ============================================================
       MÉTODO: dibujar
       ============================================================ */
    public void dibujar() {

        background(0);

        paginas.get(paginaActual).dibujar();

        btnSiguiente.dibujar();
        btnSaltear.dibujar();   // <<--- NUEVO
    }

    /* ============================================================
       MÉTODO: detectarAccion
       ============================================================ */
    public String detectarAccion() {

        /* Botón SIGUIENTE */
        if (btnSiguiente.fuePresionado()) {

            paginaActual++;

            if (paginaActual >= paginas.size()) {

                paginaActual = 0;

                sonidos.reproducirMusicaNiveles();

                return "VOLVER_MENUNIVELES";
            }
        }

        /* ------------------------------------------------------------
           Botón SALTEAR
           Va directo a la última página del final
           ------------------------------------------------------------ */
        if (btnSaltear.fuePresionado()) {

            paginaActual = paginas.size() - 1;

            return null; // Solo muestra la última, no finaliza aún
        }

        return null;
    }
}
