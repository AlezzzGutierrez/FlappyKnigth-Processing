/* ================================================================
   CLASE BotonBoolean (versión mejorada)
   ---------------------------------------------------------------
   - Misma funcionalidad que antes (NO se tocó nada de sonido).
   - Se elimina delay() y se usa cooldown no bloqueante.
   - Se añade método contiene() y esClick().
   - Animación hover más limpia.
================================================================ */
class BotonBoolean {

    // ------------------------------------------------------------
    //  ATRIBUTOS PRIVADOS
    // ------------------------------------------------------------
    private float x, y;
    private float ancho, alto;
    private boolean activo;
    private String texto;
    private GestorSonidos sonidos;

    private float hoverExtra = 0;

    // Cooldown no bloqueante
    private int ultimoClick = 0;
    private int cooldown = 150; // ms


    // ------------------------------------------------------------
    //  CONSTRUCTOR
    // ------------------------------------------------------------
    public BotonBoolean(float x, float y, float ancho, float alto,
                        String texto, GestorSonidos sonidos) {

        this.x = x;
        this.y = y;
        this.ancho = ancho;
        this.alto = alto;
        this.texto = texto;
        this.sonidos = sonidos;

        this.activo = true;
    }


    // ------------------------------------------------------------
    //  MÉTODO NUEVO: contiene(mx, my)
    //  Evita repetir condiciones del mouse
    // ------------------------------------------------------------
    private boolean contiene(int mx, int my) {
        return mx > x && mx < x + ancho &&
               my > y && my < y + alto;
    }


    // ------------------------------------------------------------
    //  MÉTODO NUEVO: esClick()
    //  Detecta clic real sin delay()
    // ------------------------------------------------------------
    private boolean esClick() {

        if (!mousePressed) return false;

        if (!contiene(mouseX, mouseY)) return false;

        int ahora = millis();

        if (ahora - ultimoClick < cooldown) return false;

        ultimoClick = ahora;
        return true;
    }


    // ------------------------------------------------------------
    //  DIBUJAR BOTÓN
    // ------------------------------------------------------------
    public void dibujar() {

        // HOVER
        float objetivo = contiene(mouseX, mouseY) ? 6 : 0;
        hoverExtra = lerp(hoverExtra, objetivo, 0.15f);

        // COLOR
        if (activo) fill(0, 200, 0);
        else fill(200, 0, 0);

        rect(x - hoverExtra/2, y - hoverExtra/2,
             ancho + hoverExtra, alto + hoverExtra, 10);

        // TEXTO
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(18);

        text(texto + ": " + (activo ? "ON" : "OFF"),
             x + ancho/2, y + alto/2);
    }


    // ------------------------------------------------------------
    //  DETECTAR CLICK (usando esClick())
    // ------------------------------------------------------------
    public void detectarClick() {

        if (esClick()) {

            activo = !activo;      // Cambiar estado
            sonidos.reproducirClick(); // Sonido mantenido
        }
    }


    // ------------------------------------------------------------
    //  GETTER
    // ------------------------------------------------------------
    public boolean estaActivo() {
        return activo;
    }
}
