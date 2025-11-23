// ====================================================
// ESCENA PERSONALIZACIÓN (ACTUALIZADA)
// ====================================================
class EscenaPersonalizacion {

  // ----------------------------------------------------
  // 🔹 Atributos privados
  // ----------------------------------------------------
  private Boton btnVolver;
  private Boton btnReroll;

  private GestorSonidos sonidos;
  private GestorJugadorActual gestorJugador;

  private PImage fondo;

  // ----------------------------------------------------
  // 🔹 Constructor
  // ----------------------------------------------------
  public EscenaPersonalizacion(GestorSonidos gestor, GestorJugadorActual gestorJugador) {

    this.sonidos = gestor;
    this.gestorJugador = gestorJugador;

    fondo = loadImage("menu_personalizacion.png");

    // Botón VOLVER
    btnVolver = new Boton(
      width/2 - 100,
      500,
      200,
      60,
      "VOLVER",
      sonidos
    );

    // Botón REROLL CLASS
    btnReroll = new Boton(
      width/2 - 120,
      420,
      240,
      60,
      "REROLL CLASS",
      sonidos
    );
  }

  // ----------------------------------------------------
  // 🔹 Dibujar la escena
  // ----------------------------------------------------
  public void dibujar(float dt) {

    imageMode(CORNER);
    image(fondo, 0, 0, width, height);

    // ----------------------------------------------
    // 🔷 Título principal
    // ----------------------------------------------
    fill(255);
    textAlign(CENTER);
    textSize(40);
    text("PERSONALIZACIÓN", width / 2, 150);

    // ----------------------------------------------
    // 🔷 Cuadrado del personaje según su clase
    // ----------------------------------------------
    Jugador j = gestorJugador.getJugador();

    color c = obtenerColorSegunClase(j);
    fill(c);
    noStroke();
    rect(width/2 - 75, 200, 150, 150, 15);

    // ----------------------------------------------
    // 🔷 Texto debajo del cuadrado
    // ----------------------------------------------
    fill(255);
    textSize(28);
    text("Clase actual: " + nombreClase(j), width/2, 390);

    // Dibujar botones
    btnReroll.dibujar();
    btnVolver.dibujar();
  }

  // ----------------------------------------------------
  // 🔹 Detectar acciones de botones
  // ----------------------------------------------------
  public String detectarAccion() {

    if (btnReroll.fuePresionado()) {
      gestorJugador.rerollearClase();
    }

    if (btnVolver.fuePresionado()) {
      sonidos.reproducirMusicaMenu();
      return "VOLVER";
    }

    return null;
  }

  // ----------------------------------------------------
  // 🔹 Color por clase
  // ----------------------------------------------------
  private color obtenerColorSegunClase(Jugador j) {

    if (j instanceof Caballero) return color(0, 180, 255);      // celeste
    if (j instanceof Arquero)   return color(255, 150, 0);      // naranja
    if (j instanceof Mago)      return color(150, 0, 200);      // morado
    if (j instanceof Escudero)  return color(0, 0, 120);        // azul oscuro

    return color(255);
  }

  // ----------------------------------------------------
  // 🔹 Nombre legible por clase
  // ----------------------------------------------------
  private String nombreClase(Jugador j) {

    if (j instanceof Caballero) return "Caballero";
    if (j instanceof Arquero)   return "Arquero";
    if (j instanceof Mago)      return "Mago";
    if (j instanceof Escudero)  return "Escudero";

    return "Desconocida";
  }
}
