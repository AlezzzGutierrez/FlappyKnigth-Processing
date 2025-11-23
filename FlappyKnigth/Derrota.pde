// ====================================================
// ESCENA DERROTA
// ====================================================
class EscenaDerrota {

  private Boton btnVolver;
  private GestorSonidos sonidos;

  public EscenaDerrota(GestorSonidos gestor) {
    this.sonidos = gestor;

    btnVolver = new Boton(
      width/2 - 150,
      height/2 + 80,
      300,
      70,
      "REGRESAR AL MENÚ NIVELES",
      sonidos
    );
  }

  public void dibujar(float dt) {

    background(120, 20, 20);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(60);
    text("DERROTA", width/2, height/2 - 60);

    textSize(25);
    text("Tu vida llegó a cero.", width/2, height/2 - 10);

    btnVolver.dibujar();
  }

  public String detectarAccion() {
    if (btnVolver.fuePresionado()) {
      return "VOLVER";
    }
    return null;
  }
}
