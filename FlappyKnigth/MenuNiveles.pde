// ====================================================
// ESCENA MENÚ DE NIVELES
// ====================================================
class EscenaMenuNiveles {

  private Boton btnVolver;
  private Boton btnNivel1;
  private Boton btnNivel2;
  private Boton btnNivel3;   // ← NUEVO
  private GestorSonidos sonidos;
  private PImage fondo;

  public EscenaMenuNiveles(GestorSonidos gestor) {
    this.sonidos = gestor;
    fondo = loadImage("menu_niveles.png");

    btnVolver = new Boton(
      width/2 - 100,
      530,
      200,
      60,
      "VOLVER",
      sonidos
    );

    btnNivel1 = new Boton(width/2 - 100, 300, 200, 60, "NIVEL 1", sonidos);
    btnNivel2 = new Boton(width/2 - 100, 380, 200, 60, "NIVEL 2", sonidos);
    btnNivel3 = new Boton(width/2 - 100, 460, 200, 60, "NIVEL 3", sonidos); // NUEVO
  }

  public void dibujar(float dt) {
    imageMode(CORNER);
    image(fondo, 0, 0, width, height);

    fill(255);
    textAlign(CENTER);
    textSize(40);
    text("PANTALLA DE NIVELES", width / 2, 150);

    btnNivel1.dibujar();
    btnNivel2.dibujar();
    btnNivel3.dibujar();   // ← NUEVO
    btnVolver.dibujar();
  }

  public String detectarAccion() {

    if (btnNivel1.fuePresionado()) return "NIVEL1";
    if (btnNivel2.fuePresionado()) return "NIVEL2";
    if (btnNivel3.fuePresionado()) return "NIVEL3";  // ← NUEVO

    if (btnVolver.fuePresionado()) {
      sonidos.reproducirMusicaMenu();
      return "VOLVER";
    }

    return null;
  }
}
