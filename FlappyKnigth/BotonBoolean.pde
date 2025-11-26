/* ================================================================
   CLASE BotonBoolean
   ---------------------------------------------------------------
    Clase independiente (NO hereda de ninguna otra).
    Su función es representar un botón ON/OFF interactivo.
    NO usa PVectors → sería útil si deseas trabajar con posiciones
     más complejas, pero aquí no es necesario.
    Incluye animación de "hover" cuando el mouse pasa encima.
================================================================ */
class BotonBoolean {

    /* ------------------------------------------------------------
       ATRIBUTOS PRIVADOS
       ------------------------------------------------------------
       - Se mantiene encapsulación: todos son privados.
       - Las posiciones NO usan PVector (simpleza).
         (Se recomienda PVector si se agregaran físicas o UI compleja)
    ------------------------------------------------------------ */
    private float x, y;             // Posición del botón
    private float ancho, alto;      // Dimensiones del botón
    private boolean activo;         // Estado ON/OFF del botón
    private String texto;           // Etiqueta útil para identificar
    private GestorSonidos sonidos;  // Dependencia: Gestor de sonidos

    // Animación de hover
    private float hoverExtra = 0;   // Expansión visual al pasar el mouse


    /* ------------------------------------------------------------
       CONSTRUCTOR
       ------------------------------------------------------------
       Se inicializan TODOS los atributos necesarios.
       - Verificado: no queda ninguna variable sin asignar.
    ------------------------------------------------------------ */
    public BotonBoolean(float x, float y, float ancho, float alto,
                        String texto, GestorSonidos sonidos) {

        this.x = x;
        this.y = y;
        this.ancho = ancho;
        this.alto = alto;
        this.texto = texto;
        this.sonidos = sonidos;

        this.activo = true; // Estado inicial editable
    }



    /* ------------------------------------------------------------
       DIBUJAR EL BOTÓN
       ------------------------------------------------------------
       - Cambia el color según el estado ON/OFF.
       - Añade una animación cuando el usuario pasa el mouse encima.
       
       Matemática aplicada:
       hoverExtra = lerp(hoverExtra, objetivo, 0.15)
       → interpola suavemente entre el tamaño normal y el ampliado.
    ------------------------------------------------------------ */
    public void dibujar() {

        /* -------- ANIMACIÓN DE HOVER -------- */
        boolean sobreMouse = mouseX > x && mouseX < x + ancho &&
                             mouseY > y && mouseY < y + alto;

        // Si el mouse está encima, expandimos suavemente
        float objetivo = sobreMouse ? 6 : 0;
        hoverExtra = lerp(hoverExtra, objetivo, 0.15f);


        /* -------- COLOR SEGÚN ESTADO -------- */
        if (activo) fill(0, 200, 0);   // Verde ON
        else fill(200, 0, 0);          // Rojo OFF

        /* -------- DIBUJAR EL RECTÁNGULO -------- */
        rect(x - hoverExtra/2, y - hoverExtra/2,
             ancho + hoverExtra, alto + hoverExtra, 10);

        /* -------- DIBUJAR TEXTO -------- */
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(18);

        String estado = activo ? "ON" : "OFF";

        text(texto + ": " + estado,
             x + ancho/2, y + alto/2);
    }



    /* ------------------------------------------------------------
       DETECTAR CLICK
       ------------------------------------------------------------
       - Verifica si el mouse está dentro del botón.
       - Alterna ON ↔ OFF.
       - Reproduce un sonido.
       - delay(150) evita múltiples clicks instantáneos.
       ------------------------------------------------------------ */
    public void detectarClick() {

        boolean dentro = 
          mouseX > x && mouseX < x + ancho &&
          mouseY > y && mouseY < y + alto;

        if (dentro && mousePressed) {

            activo = !activo;         // Cambio de estado
            sonidos.reproducirClick(); // Sonido asociado

            delay(150);              // Evita spam de clicks
        }
    }



    /* ------------------------------------------------------------
       GETTER DEL ESTADO
       ------------------------------------------------------------
       Encapsulación correcta:
       - No se permite modificar el estado desde fuera sin click.
       ------------------------------------------------------------ */
    public boolean estaActivo() {
        return activo;
    }
}
