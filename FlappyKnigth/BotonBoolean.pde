// ====================================================
// BOTÓN BOOLEANO (ON / OFF)
// ====================================================
class BotonBoolean {

  // ----------------------------------------------------
  // 🔹 Atributos privados
  // ----------------------------------------------------
  private float x, y;          // Posición del botón
  private float ancho, alto;   // Tamaño
  private boolean activo;      // Estado ON/OFF del botón
  private String texto;        // Etiqueta opcional
  private GestorSonidos sonidos; // Sonidos del juego


  // ----------------------------------------------------
  // 🔹 Constructor
  // ----------------------------------------------------
  public BotonBoolean(float x, float y, float ancho, float alto, String texto, GestorSonidos sonidos) {

    this.x = x;                // Guardamos posición X
    this.y = y;                // Guardamos posición Y
    this.ancho = ancho;        // Guardamos ancho
    this.alto = alto;          // Guardamos alto
    this.texto = texto;        // Guardamos texto
    this.sonidos = sonidos;    // Guardamos gestor de sonidos

    this.activo = true;        // Estado inicial (ON)
  }


  // ----------------------------------------------------
  // 🔹 Dibujar el botón
  // ----------------------------------------------------
  public void dibujar() {

    // Color según estado ON (verde) u OFF (rojo)
    if (activo) fill(0, 200, 0);
    else fill(200, 0, 0);

    // Dibujamos el rectángulo del botón
    rect(x, y, ancho, alto, 10);

    // Dibujamos el texto
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);

    // Mostramos el estado
    String estado = activo ? "ON" : "OFF";

    text(texto + ": " + estado, x + ancho/2, y + alto/2);
  }


  // ----------------------------------------------------
  // 🔹 Detectar si fue clicado
  // ----------------------------------------------------
  public void detectarClick() {

    // Si el mouse está dentro del botón…
    if (mouseX > x && mouseX < x + ancho &&
        mouseY > y && mouseY < y + alto &&
        mousePressed) {

      // Cambiamos el estado (ON ↔ OFF)
      activo = !activo;

      // Sonido de clic
      sonidos.reproducirClick();

      // Esperamos un pequeño tiempo para evitar muchas detecciones
      delay(150);
    }
  }


  // ----------------------------------------------------
  // 🔹 Obtener el estado del botón
  // ----------------------------------------------------
  public boolean estaActivo() {
    return activo;
  }
}
