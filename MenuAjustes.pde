/* 
 ======================================================================
   CLASE EscenaAjustes
   ----------------------------------------------------------------------
   • Clase independiente (NO heredada) que representa una pantalla UI.
   • DEPENDE de: 
         - Boton (clase de UI)
         - BotonBoolean (UI con estado ON/OFF)
         - GestorSonidos (control de música / efectos)
         - PImage (Processing)
   • NO usa PVector, pero sería recomendable para manejar posiciones 
     de botones en el futuro. 
 ======================================================================
*/
class EscenaAjustes {

    /* ------------------------------------------------------------------
       🔒 ATRIBUTOS PRIVADOS (Encapsulación)
       ------------------------------------------------------------------ */
    private Boton btnVolver;             // Botón para regresar
    private BotonBoolean btnMusica;      // Botón ON/OFF de música
    private BotonBoolean btnEfectos;     // Botón ON/OFF de efectos

    private GestorSonidos sonidos;       // Controlador general de audio
    private PImage fondo;                // Imagen fondo ajustes
    private PImage tituloAjustes;        // Imagen del título


    /* ------------------------------------------------------------------
       CONSTRUCTOR — Instancia todo lo necesario
       ------------------------------------------------------------------
       • Carga recursos gráficos.
       • Crea botones.
       • Recibe un GestorSonidos como dependencia.
       ------------------------------------------------------------------ */
    public EscenaAjustes(GestorSonidos gestor) {

        this.sonidos = gestor;  // Guardamos el gestor de sonidos recibido

        /* Cargar imágenes del fondo y título */
        fondo = loadImage("menu_ajustes.png");
        tituloAjustes = loadImage("Ajustes.png");

        /* Botón VOLVER — centrado abajo */
        btnVolver = new Boton(
            width/2 - 100, 
            height - 100, 
            200, 
            60, 
            "VOLVER", 
            sonidos
        );

        /* Botón ON/OFF de Música */
        btnMusica = new BotonBoolean(
            width/2 - 100,
            300,
            200,
            60,
            "MÚSICA",
            sonidos
        );

        /* Botón ON/OFF de Efectos */
        btnEfectos = new BotonBoolean(
            width/2 - 100,
            380,
            200,
            60,
            "EFECTOS",
            sonidos
        );
    }


    /* ------------------------------------------------------------------
       MÉTODO DIBUJAR (render de la escena)
       ------------------------------------------------------------------
       Parámetro:
           dt = delta time (NO utilizado aquí pero útil si se agregan 
                animaciones futuras).
       ------------------------------------------------------------------ */
    public void dibujar(float dt) {

        /* --- Dibujar fondo --- */
        imageMode(CORNER);
        image(fondo, 0, 0, width, height);

        /* --- Dibujar título --- */
        imageMode(CENTER);
        image(tituloAjustes, width/2, 150, 450, 250);

        /* --- Botones --- */
        btnVolver.dibujar();

        btnMusica.dibujar();
        btnMusica.detectarClick(); /* detecta clic y alterna estado */

        btnEfectos.dibujar();
        btnEfectos.detectarClick(); /* detecta clic y alterna estado */

        /* ------------------------------------------------------------------
           CONTROL DE AUDIO SEGÚN ESTADO DE LOS BOTONES
           ------------------------------------------------------------------
           - Las operaciones son simples: 
                 botón activo → encender
                 botón inactivo → apagar
           - No requiere cálculos matemáticos complejos.
           ------------------------------------------------------------------ */

        // Control general de la música
        if (btnMusica.estaActivo()) sonidos.encenderTodo();
        else sonidos.apagarTodo();

        // Control de efectos de sonido
        if (btnEfectos.estaActivo()) sonidos.activarEfectos();
        else sonidos.desactivarEfectos();
    }


    /* ------------------------------------------------------------------
       DETECTAR ACCIONES
       ------------------------------------------------------------------
       Retorna:
           "VOLVER" si el botón fue presionado
           null      si no hubo acción
       ------------------------------------------------------------------ */
    public String detectarAccion() {

        if (btnVolver.fuePresionado()) {

            sonidos.reproducirMusicaMenu(); // sonido al volver

            return "VOLVER";
        }

        return null; // No hubo acción relevante
    }
}
