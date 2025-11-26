/* ============================================================
   CLASE: NovelaInicio
   SISTEMA DE "MODO HISTORIA" basado en páginas con imágenes.
   Gestiona:
   - Lista de páginas (imágenes)
   - Botón siguiente
   - Cambio de música al finalizar
   ============================================================ */
class NovelaInicio {

    /* ------------------------------
       Atributos privados
       ------------------------------ */
    private ArrayList<PaginaNovela> paginas;  /* Lista de páginas */
    private int paginaActual;                /* Índice de la página mostrada */
    private Boton btnSiguiente;              /* Botón para avanzar */
    private GestorSonidos sonidos;           /* Referencia al gestor de audio */

    /* ============================================================
       CONSTRUCTOR
       Inicializa sonidos, lista de páginas y el botón.
       ============================================================ */
    public NovelaInicio(GestorSonidos sonidos) {

        this.sonidos = sonidos;
        this.paginaActual = 0;

        paginas = new ArrayList<PaginaNovela>();

        /* ------------------------------
           Cargar todas las páginas
           Cada página es un objeto con su imagen
           ------------------------------ */
        for (int i = 1; i <= 16; i++) {
            PImage img = loadImage("tutorial" + i + ".png");
            paginas.add(new PaginaNovela(img));
        }

        /* ------------------------------
           Crear botón SIGUIENTE
           ------------------------------ */
        btnSiguiente = new Boton(
            width - 180,
            height - 90,
            160,
            60,
            "SIGUIENTE",
            sonidos
        );
    }


    /* ============================================================
       DIBUJAR
       Renderiza página + botón
       ============================================================ */
    public void dibujar() {

        background(0);

        /* Dibujar la página actual */
        paginas.get(paginaActual).dibujar();

        /* Dibujar el botón */
        btnSiguiente.dibujar();
    }


    /* ============================================================
       DETECTAR ACCIÓN
       Avanza entre páginas y retorna un String cuando termina.
       ============================================================ */
    public String detectarAccion() {

        /* Si se presionó SIGUIENTE */
        if (btnSiguiente.fuePresionado()) {

            paginaActual++;

            /* Si terminó la novela → volver a menú niveles */
            if (paginaActual >= paginas.size()) {

                paginaActual = 0;  /* Reiniciar para una futura reproducción */

                /* Cambiar música al menú niveles */
                sonidos.reproducirMusicaNiveles();

                return "VOLVER_MENUNIVELES";
            }
        }

        return null;  /* No pasó nada */
    }
}
