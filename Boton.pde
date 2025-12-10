/* ================================================================
   CLASE: Boton (versión con animación de barra)
   ----------------------------------------------------------------
   Cambios:
   - Botón rectangular negro con borde negro grueso.
   - Texto blanco.
   - Al hacer hover:
       · El botón se expande en X (animación suave).
       · Una barra interna de color aleatorio crece en X.
   - Sonidos NO fueron modificados.
================================================================ */
class Boton {

    private PVector posicion;
    private float ancho, alto;
    private String texto;

    private boolean estaSobre = false;
    private boolean sonidoHover = false;

    private GestorSonidos sonidos;

    // --- Animación nueva ---
    private float expansion = 0;        // cuánto se agranda en X
    private float progresoBarra = 0;    // cuánto crece la barra interna
    private int colorBarra;             // color aleatorio generado al hacer hover

    public Boton(float x, float y, float ancho, float alto,
                 String texto, GestorSonidos gestor) {

        this.posicion = new PVector(x, y);
        this.ancho = ancho;
        this.alto = alto;
        this.texto = texto;

        this.sonidos = gestor;

      colorBarra = color(255, 215, 0); // dorado clásico (RGB)

    }


    /* ============================================================
       DIBUJAR EL BOTÓN
    ============================================================ */
    public void dibujar() {

        /* ------------------------------
           DETECTAR HOVER
        ------------------------------ */
        estaSobre = (
            mouseX > posicion.x &&
            mouseX < posicion.x + ancho &&
            mouseY > posicion.y &&
            mouseY < posicion.y + alto
        );

        /* ------------------------------
           SONIDO DE HOVER
        ------------------------------ */
        if (estaSobre && !sonidoHover) {
            sonidos.reproducirDorado();
            sonidoHover = true;

            // Reiniciamos la animación al entrar
            progresoBarra = 0;
           colorBarra = color(255, 215, 0); // dorado clásico (RGB)

        }
        else if (!estaSobre && sonidoHover) {
            sonidos.detenerDorado();
            sonidoHover = false;
        }

        /* ------------------------------
           ANIMACIÓN DE EXPANSIÓN
        ------------------------------ */
        if (estaSobre) {
            expansion = lerp(expansion, 20, 0.15); // se agranda +20px aprox
            progresoBarra = min(progresoBarra + 25, ancho + expansion);
        } else {
            expansion = lerp(expansion, 0, 0.15);
            progresoBarra = lerp(progresoBarra, 0, 0.1);
        }

        float xAnim = posicion.x - expansion/2;
        float wAnim = ancho + expansion;

        /* ------------------------------
           DIBUJAR CUERPO DEL BOTÓN
        ------------------------------ */
        stroke(0);
        strokeWeight(4);
        fill(0);
        rect(xAnim, posicion.y, wAnim, alto, 4);

        /* ------------------------------
           BARRA INTERNA (solo en hover)
        ------------------------------ */
        if (estaSobre) {
            noStroke();
            fill(colorBarra);
            rect(xAnim, posicion.y, progresoBarra, alto);
        }

        /* ------------------------------
           TEXTO
        ------------------------------ */
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(20);
        text(texto, xAnim + wAnim/2, posicion.y + alto/2);
    }



    /* ============================================================
       DETECTAR CLIC
    ============================================================ */
    public boolean fuePresionado() {

        if (estaSobre && mousePressed) {
            sonidos.reproducirClick();
            sonidos.sonidoDorado.stop();
            return true;
        }
        return false;
    }


    /* ============================================================
       GETTERS
    ============================================================ */
    public String getTexto() { return texto; }
}
