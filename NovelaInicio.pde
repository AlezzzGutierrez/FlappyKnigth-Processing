/* ============================================================
   CLASE: NovelaInicio
   SISTEMA DE "MODO HISTORIA" basado en páginas con imágenes.
   Gestiona:
   - Lista de páginas (imágenes)
   - Botón siguiente
   - Botón saltear (ir a la última página)
   - Cambio de música al finalizar
   ============================================================ */
class NovelaInicio {

    /* ------------------------------
       Atributos privados
       ------------------------------ */
    private ArrayList<PaginaNovela> paginas;
    private int paginaActual;
    private Boton btnSiguiente;
    private Boton btnSaltear;        // <<--- NUEVO BOTÓN
    private GestorSonidos sonidos;

    /* ============================================================
       CONSTRUCTOR
       ============================================================ */
    public NovelaInicio(GestorSonidos sonidos) {

        this.sonidos = sonidos;
        this.paginaActual = 0;

        paginas = new ArrayList<PaginaNovela>();

        /* Cargar páginas */
        for (int i = 1; i <= 14; i++) {
            PImage img = loadImage("tutorial" + i + ".jpg");
            paginas.add(new PaginaNovela(img));
        }

        /* ------------------------------
           Botón SIGUIENTE
           ------------------------------ */
        btnSiguiente = new Boton(
            width - 180,
            height - 90,
            160,
            60,
            "SIGUIENTE",
            sonidos
        );

        /* ------------------------------
           Botón SALTEAR (nuevo)
           Más pequeño y arriba
           ------------------------------ */
        btnSaltear = new Boton(
            width - 150,   // X (pegado arriba a la derecha)
            20,            // Y
            130,           // ancho
            45,            // alto
            "SALTEAR",
            sonidos
        );
    }


    /* ============================================================
       DIBUJAR
       ============================================================ */
    public void dibujar() {

        background(0);

        paginas.get(paginaActual).dibujar();

        btnSiguiente.dibujar();
        btnSaltear.dibujar();   // <<--- NUEVO
    }


    /* ============================================================
       DETECTAR ACCIÓN
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

        /* ------------------------------
           Botón SALTEAR (nuevo)
           Va directo a la ÚLTIMA página
           ------------------------------ */
        if (btnSaltear.fuePresionado()) {

            paginaActual = paginas.size() - 1;  // última imagen

            return null;  // simplemente muestra la última, sin cerrar
        }

        return null;
    }
}
