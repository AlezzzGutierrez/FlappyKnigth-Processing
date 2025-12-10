/* 
 ================================================================
  CLASE EscenaMenuNiveles
  ---------------------------------------------------------------
  • Maneja la escena del menú donde se eligen los niveles.
  • Muestra botones, controla desbloqueos y dibuja el cartel de progreso.
 ================================================================
*/
class EscenaMenuNiveles {

    /* ------------------------------------------------------------
       BOTONES PRINCIPALES
    ------------------------------------------------------------ */
    private Boton btnVolver;
    private Boton btnNivel1;
    private Boton btnNivel2;
    private Boton btnNivel3;
    private Boton btnHistoria;
    private Boton btnFinal;

    /* ------------------------------------------------------------
       DEPENDENCIAS Y RECURSOS
    ------------------------------------------------------------ */
    private GestorSonidos sonidos;
    private PImage fondo;

    /* ------------------------------------------------------------
       ESTADOS DE DESBLOQUEO DE NIVELES
       Se activan en orden dependiendo de qué nivel jugó el usuario.
    ------------------------------------------------------------ */
    private boolean desbloqueadoInicio  = true;
    private boolean desbloqueadoNivel1  = false;
    private boolean desbloqueadoNivel2  = false;
    private boolean desbloqueadoNivel3  = false;
    private boolean desbloqueadoFinal   = false;


    /* ------------------------------------------------------------
       CONSTRUCTOR → Inicializa botones, fondo y sonidos
    ------------------------------------------------------------ */
    public EscenaMenuNiveles(GestorSonidos gestor) {
        this.sonidos = gestor;

        fondo = loadImage("menu_niveles.png");

        btnVolver  = new Boton(width/2 - 100, 530, 200, 60, "VOLVER", sonidos);
        btnNivel1  = new Boton(320, 230, 50, 50, "LVL 1", sonidos);
        btnNivel2  = new Boton(550, 170, 50, 50, "LVL 2", sonidos);
        btnNivel3  = new Boton(600, 280, 50, 50, "LVL 3", sonidos);

        btnHistoria = new Boton(300, 420, 200, 50, "INICIO", sonidos);
        btnFinal    = new Boton(500, 420, 200, 50, "FINAL", sonidos);
    }


    /* ------------------------------------------------------------
       MÉTODO DIBUJAR
       - Renderiza fondo
       - Muestra barra de progreso (nuevo)
       - Renderiza botones visibles
    ------------------------------------------------------------ */
    public void dibujar(float dt) {

        /* Dibujar fondo del menú */
        imageMode(CORNER);
        image(fondo, 0, 0, width, height);


        /* ============================================================
           ============================================================
               *** ZONA EDITABLE DEL CARTEL DE PROGRESO ***
           ------------------------------------------------------------
               En este bloque puedes cambiar:
               • Tamaño del rectángulo negro
               • Colores
               • Tamaño y texto del título
               • Cantidad, tamaño y posición de los rectángulos de progreso
               • Condiciones que los encienden
           ============================================================
           ============================================================ */

        // Rectángulo negro del cartel superior
        fill(0, 180);
        noStroke();
        rect(20, 20, 230, 100, 15);

        // Determinar si el progreso está completado
        boolean completo = desbloqueadoNivel2 && desbloqueadoNivel3 && desbloqueadoFinal;

        // Texto del cartel
        fill(255);
        textSize(18);
        textAlign(CENTER, CENTER);
        text(completo ? "COMPLETADO" : "Progreso Completado", 260/2, 45);

        // Posiciones y tamaño de los indicadores de progreso
        float rx = 55;   // Posición del primer rectángulo
        float ry = 80;
        float rw = 40;
        float rh = 25;
        float sep = 60;  // Separación entre rectángulos

        // Indicador 1 → completado al desbloquear Nivel 2
        fill(desbloqueadoNivel2 ? color(255, 230, 0) : color(180));
        rect(rx, ry, rw, rh, 5);

        // Indicador 2 → completado al desbloquear Nivel 3
        fill(desbloqueadoNivel3 ? color(255, 230, 0) : color(180));
        rect(rx + sep, ry, rw, rh, 5);

        // Indicador 3 → completado al desbloquear FINAL
        fill(desbloqueadoFinal ? color(255, 230, 0) : color(180));
        rect(rx + sep*2, ry, rw, rh, 5);

        /* ============================================================
           FIN DE LA ZONA EDITABLE DEL CARTEL DE PROGRESO
        ============================================================ */


        /* ------------------------------------------------------------
           BOTONES NORMALES DEL MENÚ
        ------------------------------------------------------------ */

        // Botón INICIO (siempre visible)
        btnHistoria.dibujar();

        // Mostrar niveles según desbloqueo
        if (desbloqueadoNivel1) btnNivel1.dibujar();
        if (desbloqueadoNivel2) btnNivel2.dibujar();
        if (desbloqueadoNivel3) btnNivel3.dibujar();
        if (desbloqueadoFinal)  btnFinal.dibujar();

        // Botón volver
        btnVolver.dibujar();
    }


    /* ------------------------------------------------------------
       DETECTAR ACCIONES DEL USUARIO
       Controla qué nivel se desbloquea al tocar qué botón
    ------------------------------------------------------------ */
    public String detectarAccion() {

        if (btnHistoria.fuePresionado()) {
            desbloqueadoNivel1 = true;  // Se habilita nivel 1
            return "HISTORIA";
        }

        if (desbloqueadoNivel1 && btnNivel1.fuePresionado()) {
            desbloqueadoNivel2 = true;
            return "NIVEL1";
        }

        if (desbloqueadoNivel2 && btnNivel2.fuePresionado()) {
            desbloqueadoNivel3 = true;
            return "NIVEL2";
        }

        if (desbloqueadoNivel3 && btnNivel3.fuePresionado()) {
            desbloqueadoFinal = true;
            return "NIVEL3";
        }

        if (desbloqueadoFinal && btnFinal.fuePresionado()) {
            return "FINAL";
        }

        if (btnVolver.fuePresionado()) {
            sonidos.reproducirMusicaMenu();
            return "VOLVER";
        }

        return null;
    }
}
