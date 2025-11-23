// ====================================================
// CLASE BOTON – SIMPLE, ORIENTADA A OBJETOS Y COMENTADA
// ====================================================
class Boton {

  // ===============================
  // 🔹 VARIABLES PRIVADAS
  // ===============================
  private PVector posicion;      // posición del botón
  private float ancho, alto;     // tamaño del botón
  private String texto;          // texto que muestra el botón

  private boolean estaSobre;     // indica si el mouse está encima
  private boolean sonidoHover;   // evita que el sonido se repita
  private float mezclaColor = 0; // transición de negro → amarillo

  private GestorSonidos sonidos; // referencia al gestor de sonidos


  // ===============================
  // 🔹 CONSTRUCTOR
  // ===============================
  public Boton(float x, float y, float ancho, float alto, String texto, GestorSonidos gestor) {

    this.posicion = new PVector(x, y); // guardamos posición
    this.ancho = ancho;                // ancho del botón
    this.alto = alto;                  // alto del botón
    this.texto = texto;                // texto del botón

    this.sonidos = gestor;             // referencia a sonidos
  }


  // ===============================
  // 🔹 DIBUJAR EL BOTÓN
  // ===============================
  public void dibujar() {

    // ----------------------------------------------
    // 1) Detectar si el mouse está dentro del botón
    // ----------------------------------------------
    estaSobre = (
      mouseX > posicion.x &&
      mouseX < posicion.x + ancho &&
      mouseY > posicion.y &&
      mouseY < posicion.y + alto
    );

    // ----------------------------------------------
    // 2) Reproducir o detener sonido al hacer hover
    // ----------------------------------------------
    if (estaSobre && !sonidoHover) {
      sonidos.reproducirDorado();  // sonido cuando entras
      sonidoHover = true;

    } else if (!estaSobre && sonidoHover) {
      sonidos.detenerDorado();     // sonido se desvanece
      sonidoHover = false;
    }

    // ----------------------------------------------
    // 3) Aspecto visual según hover
    // ----------------------------------------------
    if (estaSobre) {

      // Dibujar un borde más grande
      fill(0);
      stroke(255);
      rect(posicion.x - 5, posicion.y - 5, ancho + 10, alto + 10, 10);

      // Aumentar color hacia amarillo
      mezclaColor = min(1, mezclaColor + 0.02);

    } else {

      // Cuadro simple blanco
      fill(255);
      stroke(0);
      rect(posicion.x, posicion.y, ancho, alto, 10);

      // Volver a negro
      mezclaColor = max(0, mezclaColor - 0.02);
    }

    // ----------------------------------------------
    // 4) Color del texto (negro → amarillo)
    // ----------------------------------------------
    color colorTexto = lerpColor(color(0), color(255, 220, 0), mezclaColor);

    fill(colorTexto);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(texto, posicion.x + ancho / 2, posicion.y + alto / 2);
  }


  // ===============================
  // 🔹 DETECTAR SI SE HACKEÓ CLICK
  // ===============================
  public boolean fuePresionado() {

    // si el mouse está encima y presionaste → botón activado
    if (estaSobre && mousePressed) {

      sonidos.reproducirClick(); // sonido click
      sonidos.sonidoDorado.stop();
      return true;
    }

    return false; // no fue presionado
  }


  // ===============================
  // 🔹 OBTENER TEXTO DEL BOTÓN
  // ===============================
  public String getTexto() {
    return texto;
  }
}
