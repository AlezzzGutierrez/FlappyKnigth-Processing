/* ============================================================
   CLASE: NovelaFinal
   DESCRIPCIÓN:
   Controla el epílogo del juego, mostrando una secuencia de
   imágenes a modo de historia y permitiendo avanzar con un botón.

   DEFINICIÓN OOP:
   - Encapsula su estado (páginas, índice actual, sonido, botón)
   - Cada elemento es una clase independiente (PaginaNovela, Boton)
   - Delegación correcta: cada página se dibuja sola
   ============================================================ */
class NovelaFinal {

    /* ------------------------------------------------------------
       ATRIBUTOS PRIVADOS
       (Encapsulación: nada queda público)
       ------------------------------------------------------------ */
    private ArrayList<PaginaNovela> paginas; /* Lista de imágenes finales */
    private int paginaActual;                /* Índice de la página activa */
    private Boton btnSiguiente;              /* Botón que avanza la historia */
    private GestorSonidos sonidos;           /* Control de música */

    /* ============================================================
       CONSTRUCTOR
       - Inicializa lista de páginas
       - Carga imágenes del final
       - Crea botón SIGUIENTE
       - Asegura que todas las variables están correctamente
         inicializadas (mejor práctica OOP)
       ============================================================ */
    public NovelaFinal(GestorSonidos sonidos) {

        this.sonidos = sonidos;
        this.paginaActual = 0;

        /* Crear contenedor de páginas */
        paginas = new ArrayList<PaginaNovela>();

        /* ------------------------------------------------------------
           AGREGAR PÁGINAS DEL FINAL
           ► EDITABLE: acá podés agregar, sacar o cambiar imágenes
           ------------------------------------------------------------ */
        for (int i = 1; i <= 14; i++) {
            PImage img = loadImage("fin" + i + ".jpg");
            paginas.add(new PaginaNovela(img));
        }

        /* ------------------------------------------------------------
           CREAR BOTÓN SIGUIENTE
           ► EDITABLE: podés cambiar tamaño o posición
           ------------------------------------------------------------ */
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
       MÉTODO: dibujar
       - Limpia la pantalla
       - Dibuja la página actual
       - Dibuja el botón
       ============================================================ */
    public void dibujar() {

        background(0);                  /* Fondo negro simple */
        paginas.get(paginaActual).dibujar();  /* Página actual */
        btnSiguiente.dibujar();               /* Botón */
    }

    /* ============================================================
       MÉTODO: detectarAccion
       - Detecta si el botón fue presionado
       - Avanza a la siguiente página
       - Si termina la historia: devuelve evento para cambiar de estado
       ============================================================ */
    public String detectarAccion() {

        if (btnSiguiente.fuePresionado()) {

            paginaActual++;

            /* --------------------------------------------------------
               Si ya no hay más páginas:
               - Restablecer a primera página (por si se vuelve a entrar)
               - Cambiar música
               - Devolver evento al sistema de estados
               -------------------------------------------------------- */
            if (paginaActual >= paginas.size()) {

                paginaActual = 0;

                sonidos.reproducirMusicaNiveles();

                return "VOLVER_MENUNIVELES";
            }
        }

        return null;  /* No hubo acción relevante */
    }
}
