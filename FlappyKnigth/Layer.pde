// ============================================================
// ======================== CAPA PARALLAX ======================
// ============================================================
class Layer {
  PImage img;
  float x;
  float speed;

  Layer(String filename, float speed) {
    img = loadImage(filename);
    this.speed = speed;
    x = 0;
  }

  void update(float dt) {
    // dt = tiempo en segundos, speed = px por frame
    x += speed * dt * 60;   // velocidad normalizada

    if (x <= -img.width) {
      x = 0;
    }
  }

  void display() {
    image(img, x, 100);
    image(img, x + img.width, 100);
  }
}
