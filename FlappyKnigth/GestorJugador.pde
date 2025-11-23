// ====================================================
// 🔹 GESTOR DEL JUGADOR ACTUAL
// ====================================================
class GestorJugadorActual {

  // ----------------------------------------------------
  // 🔹 Jugador actual seleccionado
  // ----------------------------------------------------
  private Jugador jugadorActual;

  // ----------------------------------------------------
  // 🔹 Constructor → por defecto arranca con Caballero
  // ----------------------------------------------------
  public GestorJugadorActual() {
    jugadorActual = new Caballero("Jugador");
  }

  // ----------------------------------------------------
  // 🔹 Getter del jugador actual
  // ----------------------------------------------------
  public Jugador getJugador() {
    return jugadorActual;
  }

  // ----------------------------------------------------
  // 🔹 Cambiar clase del jugador según probabilidades
  // ----------------------------------------------------
  public void rerollearClase() {

    // ----------------------------------------------
    // Matemática básica: número aleatorio 0 → 1
    // ----------------------------------------------
    float r = random(1);

    // 40% → Caballero
    if (r < 0.40) {
      jugadorActual = new Caballero("Jugador");
    }
    // 30% → Arquero
    else if (r < 0.70) {
      jugadorActual = new Arquero("Jugador");
    }
    // 20% → Escudero
    else if (r < 0.90) {
      jugadorActual = new Escudero("Jugador");
    }
    // 10% → Mago
    else {
      jugadorActual = new Mago("Jugador");
    }
  }
}
