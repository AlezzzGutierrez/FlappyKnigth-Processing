// ====================================================
// ESCENA: MENÚ PRINCIPAL (Versión simplificada con fondo estático)
// ====================================================
class MenuPrincipal {

  // ----------------------------------------------------
  // 🔹 BOTONES DEL MENÚ
  // ----------------------------------------------------
  private Boton btnAjustes;
  private Boton btnJugar;
  private Boton btnRerollMusica;
  private Boton btnPersonalizar;

  // ----------------------------------------------------
  // 🔹 MANEJO DE SONIDOS
  // ----------------------------------------------------
  private GestorSonidos sonidos;

  // ----------------------------------------------------
  // 🔹 FONDO ESTÁTICO
  // ----------------------------------------------------
  private PImage fondo;

  // ====================================================
  // CONSTRUCTOR
  // ====================================================
  public MenuPrincipal(GestorSonidos gestor) {
    this.sonidos = gestor;

    // Botones
    btnAjustes = new Boton(width/2 - 100, 450, 200, 60, "AJUSTES", sonidos);
    btnPersonalizar = new Boton(width/2 - 100, 370, 200, 60, "PERSONALIZAR", sonidos);
    btnRerollMusica = new Boton(width - 60, height - 60, 40, 30, "M", sonidos);
    btnJugar = new Boton(width/2 - 100, 290, 200, 60, "JUGAR", sonidos);

    // Fondo único (usa una de las imágenes ya existentes)
    fondo = loadImage("menu_fondo1.png");
  }

  // ====================================================
  // MÉTODO DE DIBUJO
  // ====================================================
  public void dibujar(float dt) {
    // Fondo estático
    imageMode(CORNER);
    image(fondo, 0, 0, width, height);

    // Título
    fill(255);
    textAlign(CENTER);
    textSize(50);
    text("MENÚ PRINCIPAL", width / 2, 150);

    // Botones
    btnPersonalizar.dibujar();
    btnAjustes.dibujar();
    btnRerollMusica.dibujar();
    btnJugar.dibujar();
  }

  // ====================================================
  // DETECTAR ACCIÓN
  // ====================================================
  public String detectarAccion() {
    if (btnAjustes.fuePresionado()) {
      sonidos.reproducirMusicaAjustes();
      return "AJUSTES";
    }

    if (btnPersonalizar.fuePresionado()) {
      sonidos.reproducirMusicaPersonalizacion();
      return "PERSONALIZAR";
    }

    if (btnRerollMusica.fuePresionado()) {
      sonidos.reproducirMusicaMenu();
    }

    if (btnJugar.fuePresionado()) {
      sonidos.reproducirMusicaNiveles();
      return "MENUNIVELES";
    }

    return null;
  }
}
