/* ================================================================
   CLASE: Boton
   ----------------------------------------------------------------
   - Clase independiente (NO hereda de otra clase).
   - Dependiente del sistema de sonido: requiere GestorSonidos.
   - Usa PVector para manejar la posición del botón.
     Esto facilita movimiento, interpolaciones, físicas y animaciones.
   - Incluye animación de hover (aumento de borde + cambio de color).
   - Diseñada para procesamiento orientado a objetos.
================================================================ */
class Boton {

    /* ============================================================
       BLOQUE 1 — ATRIBUTOS PRIVADOS (ENCAPSULACIÓN)
       ------------------------------------------------------------
       Todos los atributos están en private → ningún otro objeto
       del juego puede modificarlos sin pasar por los métodos públicos.
       ------------------------------------------------------------
       Explicación de variables:
       - posicion: PVector (posición del botón en pantalla).
       - ancho / alto: dimensiones del rectángulo.
       - texto: texto que se mostrará dentro del botón.
       - estaSobre: indica si el mouse está encima.
       - sonidoHover: evita repetir sonido al hacer hover.
       - mezclaColor: transición del color del texto (0→negro, 1→amarillo).
       - sonidos: dependencia → la clase necesita un gestor de sonido.
    ============================================================ */
    private PVector posicion;
    private float ancho, alto;
    private String texto;

    private boolean estaSobre = false;
    private boolean sonidoHover = false;
    private float mezclaColor = 0;

    private GestorSonidos sonidos;


    /* ============================================================
       BLOQUE 2 — CONSTRUCTOR
       ------------------------------------------------------------
       Se inicializan TODAS las variables necesarias para evitar nulos.
       PVector se usa para claridad y posibles animaciones futuras.
       ------------------------------------------------------------
       NOTA:
       Puedes editar todo lo que se envía al constructor, por ejemplo:
       - cambiar dimensiones
       - texto dinámico
       - añadir más parámetros si luego deseas personalizar estilos
    ============================================================ */
    public Boton(float x, float y, float ancho, float alto,
                 String texto, GestorSonidos gestor) {

        this.posicion = new PVector(x, y); 
        this.ancho = ancho;
        this.alto = alto;
        this.texto = texto;

        this.sonidos = gestor; // dependencia externa
    }



    /* ============================================================
       BLOQUE 3 — DIBUJAR EL BOTÓN EN PANTALLA
       ------------------------------------------------------------
       Incluye:
       - detección de hover
       - animación del borde
       - transición de color con lerpColor
       - sonido al pasar por encima
       ------------------------------------------------------------
       Explicación matemática aplicada:
       mezclaColor = min(1, mezclaColor + 0.02);
       → incrementa la mezcla gradualmente hacia 1 (amarillo)

       mezclaColor = max(0, mezclaColor - 0.02);
       → disminuye la mezcla hacia negro
    ============================================================ */
    public void dibujar() {

        /* --------------------------------------------------------
           1) DETECTAR HOVER (mouse dentro del botón)
           --------------------------------------------------------
           Fórmula de inclusión dentro de un rectángulo:
           x < mouseX < x + ancho
           y < mouseY < y + alto
        -------------------------------------------------------- */
        estaSobre = (
            mouseX > posicion.x &&
            mouseX < posicion.x + ancho &&
            mouseY > posicion.y &&
            mouseY < posicion.y + alto
        );


        /* --------------------------------------------------------
           2) SONIDO DE HOVER
           --------------------------------------------------------
           - sonido se activa UNA sola vez al entrar
           - sonido se detiene al salir
        -------------------------------------------------------- */
        if (estaSobre && !sonidoHover) {
            sonidos.reproducirDorado();
            sonidoHover = true;

        } else if (!estaSobre && sonidoHover) {
            sonidos.detenerDorado();
            sonidoHover = false;
        }


        /* --------------------------------------------------------
           3) APARIENCIA DEL BOTÓN
           --------------------------------------------------------
           Si el mouse está encima:
           - se dibuja un borde más grueso
           - se avanza transición hacia amarillo
        -------------------------------------------------------- */
        if (estaSobre) {

            // Borde negro alrededor
            fill(0);
            stroke(255);

            // borde ancho (rectángulo más grande)
            rect(posicion.x - 5, posicion.y - 5,
                 ancho + 10, alto + 10, 10);

            mezclaColor = min(1, mezclaColor + 0.02);

        } else {

            // Botón blanco tradicional
            fill(255);
            stroke(0);
            rect(posicion.x, posicion.y, ancho, alto, 10);

            mezclaColor = max(0, mezclaColor - 0.02);
        }


        /* --------------------------------------------------------
           4) COLOR SUAVE DEL TEXTO
           --------------------------------------------------------
           lerpColor(color1, color2, t):
                t = 0 → color1
                t = 1 → color2
        -------------------------------------------------------- */
        color colorTexto = lerpColor(
            color(0),             // negro
            color(255, 220, 0),   // amarillo dorado
            mezclaColor           // interpolación
        );

        fill(colorTexto);
        textAlign(CENTER, CENTER);
        textSize(20);

        // posición centrada del texto
        text(texto, posicion.x + ancho / 2, posicion.y + alto / 2);
    }




    /* ============================================================
       BLOQUE 4 — DETECTAR SI SE PRESIONÓ EL BOTÓN
       ------------------------------------------------------------
       Regresa true si el mouse está encima *mientras se hace click*.
       Además reproduce un sonido de click.
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
       BLOQUE 5 — GETTERS PÚBLICOS (ENCAPSULACIÓN)
       ------------------------------------------------------------
       Solo se expone lo necesario.
       El texto puede ser leído pero NO modificado desde fuera.
    ============================================================ */
    public String getTexto() {
        return texto;
    }
}
