/* ============================================================
   ===============  CAPA PARALLAX / BACKGROUND  ===============
   ============================================================

   Esta clase es una UNIDAD INDEPENDIENTE que representa una capa
   de fondo en movimiento para un efecto de Parallax.

   - Se puede usar en cualquier escena
   - No hereda de otras clases (no es dependiente)
   - No usa PVectores (pero podría usarlos si prefieres)
   - Está orientada a objetos correctamente
   - Listo para ser modificado / expandido
   ------------------------------------------------------------
*/

class Layer {

  // ------------------------------------------------------------
  // ---------------------- ATRIBUTOS ---------------------------
  // ------------------------------------------------------------

  /* Imagen del fondo */
  private PImage img;

  /* Posición horizontal de la capa.
     Si usáramos PVector sería: PVector posicion */
  private float x;

  /* Velocidad de desplazamiento en px/segundo.
     Esta velocidad se multiplica por dt. */
  private float speed;

  // ------------------------------------------------------------
  // --------------------- CONSTRUCTOR --------------------------
  // ------------------------------------------------------------

  Layer(String filename, float speed) {

    /* Carga de imagen: operación dependiente de Processing */
    this.img = loadImage(filename);

    /* Guardamos la velocidad solicitada */
    this.speed = speed;

    /* Comenzamos en 0 por defecto */
    this.x = 0;
  }

  // ------------------------------------------------------------
  // -------------------- ACTUALIZACIÓN -------------------------
  // ------------------------------------------------------------

  void update(float dt) {
    /* ==========================================================
       CÁLCULO DE MOVIMIENTO:
       x += velocidad * dt

       - speed: píxeles por segundo (si quieres que lo sea)
       - dt: tiempo en segundos desde el último frame

       Multiplicar por 60 normaliza para Processing,
       porque speed suele estar pensado para "px por frame".
       ========================================================== */

    x += speed * dt * 60;

    /* Cuando la imagen completa sale por la izquierda,
       se reinicia para continuar el loop infinito */
    if (x <= -img.width) {
      x = 0;
    }
  }

  // ------------------------------------------------------------
  // ------------------------ DIBUJO ----------------------------
  // ------------------------------------------------------------

  void display() {

    /* La imagen se dibuja DOS veces:
       1. La actual
       2. La misma imagen inmediatamente después

       Esto genera un ciclo continuo sin cortes.
    */

    image(img, x,       100);
    image(img, x + img.width, 100);
  }

  // ------------------------------------------------------------
  // ---------------------- GETTERS SETTERS ---------------------
  // ------------------------------------------------------------

  /* Puedes editar velocidad "on the fly" */
  void setSpeed(float s) { this.speed = s; }
  float getSpeed() { return speed; }

  /* Puedes leer la posición si fuese necesario */
  float getX() { return x; }
}
