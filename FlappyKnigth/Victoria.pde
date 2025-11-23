// ====================================================
// ESCENA VICTORIA
// ====================================================
class EscenaVictoria {

  private Boton btnVolver;
  private GestorSonidos sonidos;

  public EscenaVictoria(GestorSonidos gestor) {
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

    background(20, 120, 40);
    
    

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(60);
    text("¡VICTORIA!", width/2, height/2 - 60);

    textSize(25);
    text("Has completado el nivel.", width/2, height/2 - 10);

    btnVolver.dibujar();
  }

  public String detectarAccion() {
    if (btnVolver.fuePresionado()) {
      return "VOLVER";
    }
    return null;
  }
}
