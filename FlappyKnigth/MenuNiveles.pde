/* 
 ================================================================
  CLASE EscenaMenuNiveles
  ---------------------------------------------------------------
  • Clase independiente que funciona como escena del juego.
  • Responsable de mostrar botones, controlar desbloqueos y 
    responder acciones del jugador.
  • Esta clase DEPENDE de:
        - Boton (otra clase UI)
        - GestorSonidos (música/sonidos)
        - PImage (Processing)
  • No utiliza PVector → Se podría migrar más adelante para manejar 
    posiciones de manera más limpia. 
 ================================================================
*/
class EscenaMenuNiveles {

    /* ------------------------------------------------------------
       BOTONES (Encapsulados como private)
       ------------------------------------------------------------ */
    private Boton btnVolver;
    private Boton btnNivel1;
    private Boton btnNivel2;
    private Boton btnNivel3;
    private Boton btnHistoria;
    private Boton btnFinal;

    /* ------------------------------------------------------------
       MANEJO DE SONIDOS Y FONDO
       ------------------------------------------------------------ */
    private GestorSonidos sonidos;
    private PImage fondo;

    /* ------------------------------------------------------------
       ESTADOS DE DESBLOQUEO (persisten toda la sesión)
       ------------------------------------------------------------ 
       • Cada boolean representa un nivel habilitado.
       • El juego los activa secuencialmente.
       • Editable según necesidades del sistema.
    ------------------------------------------------------------ */
    private boolean desbloqueadoInicio  = true;   // siempre visible
    private boolean desbloqueadoNivel1  = false;
    private boolean desbloqueadoNivel2  = false;
    private boolean desbloqueadoNivel3  = false;
    private boolean desbloqueadoFinal   = false;


    /* ------------------------------------------------------------
       CONSTRUCTOR
       ------------------------------------------------------------ 
       • Instancia botones.
       • Carga imágenes.
       • Crea dependencias.
    ------------------------------------------------------------ */
    public EscenaMenuNiveles(GestorSonidos gestor) {
        this.sonidos = gestor;

        fondo = loadImage("menu_niveles.png");  // Imagen de fondo

        // Botón volver
        btnVolver = new Boton(width/2 - 100, 530, 200, 60, "VOLVER", sonidos);

        // Botones de niveles
        btnNivel1 = new Boton(320, 230, 50, 50, "LVL 1", sonidos);
        btnNivel2 = new Boton(550, 170, 50, 50, "LVL 2", sonidos);
        btnNivel3 = new Boton(600, 280, 50, 50, "LVL 3", sonidos);

        // Botones principales (historia y final)
        btnHistoria = new Boton(300, 420, 200, 50, "INICIO", sonidos);
        btnFinal    = new Boton(500, 420, 200, 50, "FINAL", sonidos);
    }


    /* ------------------------------------------------------------
       DIBUJAR ESCENA
       ------------------------------------------------------------
       • Renderiza el fondo.
       • Muestra botones según el progreso desbloqueado.
       • dt NO se usa aquí pero se mantiene por consistencia.
    ------------------------------------------------------------ */
    public void dibujar(float dt) {

        /* Fondo del menú */
        imageMode(CORNER);
        image(fondo, 0, 0, width, height);

        /* Mostrar botones según progreso */
        btnHistoria.dibujar();    // siempre visible

        if (desbloqueadoNivel1) btnNivel1.dibujar();
        if (desbloqueadoNivel2) btnNivel2.dibujar();
        if (desbloqueadoNivel3) btnNivel3.dibujar();
        if (desbloqueadoFinal)  btnFinal.dibujar();

        /* Botón volver */
        btnVolver.dibujar();
    }


    /* ------------------------------------------------------------
       DETECTAR ACCIONES DEL USUARIO
       ------------------------------------------------------------
       Orden de prioridad:
       1. Historia → desbloquea nivel 1
       2. Cada nivel desbloquea el siguiente
       3. Botón Final
       4. Botón Volver
       ------------------------------------------------------------
       Retorna:
           "HISTORIA", "NIVEL1", "NIVEL2", "NIVEL3", "FINAL", "VOLVER"
           o null si no se tocó nada.
    ------------------------------------------------------------ */
    public String detectarAccion() {

        /* --------------------------------------------------------
           BOTÓN HISTORIA (siempre visible)
           -------------------------------------------------------- */
        if (btnHistoria.fuePresionado()) {
            desbloqueadoNivel1 = true;  // desbloqueo permanente
            return "HISTORIA";
        }

        /* --------------------------------------------------------
           NIVEL 1 → desbloquea LVL 2
           -------------------------------------------------------- */
        if (desbloqueadoNivel1 && btnNivel1.fuePresionado()) {
            desbloqueadoNivel2 = true;
            return "NIVEL1";
        }

        /* --------------------------------------------------------
           NIVEL 2 → desbloquea LVL 3
           -------------------------------------------------------- */
        if (desbloqueadoNivel2 && btnNivel2.fuePresionado()) {
            desbloqueadoNivel3 = true;
            return "NIVEL2";
        }

        /* --------------------------------------------------------
           NIVEL 3 → desbloquea FINAL
           -------------------------------------------------------- */
        if (desbloqueadoNivel3 && btnNivel3.fuePresionado()) {
            desbloqueadoFinal = true;
            return "NIVEL3";
        }

        /* --------------------------------------------------------
           FINAL
           -------------------------------------------------------- */
        if (desbloqueadoFinal && btnFinal.fuePresionado()) {
            return "FINAL";
        }

        /* --------------------------------------------------------
           VOLVER AL MENÚ
           -------------------------------------------------------- */
        if (btnVolver.fuePresionado()) {
            sonidos.reproducirMusicaMenu();
            return "VOLVER";
        }

        return null;  // no hubo acción
    }
}
