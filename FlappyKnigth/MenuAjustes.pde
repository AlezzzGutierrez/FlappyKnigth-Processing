
// ====================================================
// ESCENA AJUSTES
// ====================================================
class EscenaAjustes {

  // ----------------------------------------------------
  // 🔹 Atributos privados
  // ----------------------------------------------------
  private Boton btnVolver;         // Botón para regresar al menú principal
  private BotonBoolean btnMusica;  // NUEVO botón booleano ON/OFF
  private GestorSonidos sonidos;   // Controlador de música y efectos
  private PImage fondo;            // Imagen de fondo de la pantalla de ajustes
  
private BotonBoolean btnEfectos;



  // ----------------------------------------------------
  // 🔹 Constructor: se ejecuta al crear esta escena
  // ----------------------------------------------------
  public EscenaAjustes(GestorSonidos gestor) {

    this.sonidos = gestor; // Guardamos referencia al gestor de sonidos

    fondo = loadImage("menu_ajustes.png"); // Cargamos la imagen de fondo

    // Botón para regresar al menú
    btnVolver = new Boton(
      width/2 - 100,
      height - 100,
      200,
      60,
      "VOLVER",
      sonidos
    );

    // NUEVO: botón para activar/desactivar música
    btnMusica = new BotonBoolean(
      width/2 - 100,   // X centrado
      300,             // Y un poco más abajo del título
      200,             // Ancho
      60,              // Alto
      "MÚSICA",        // Texto
      sonidos          // Gestor de sonidos
    );
    
    btnMusica = new BotonBoolean(
  width/2 - 100,
  300,
  200,
  60,
  "MÚSICA",
  sonidos
);

btnEfectos = new BotonBoolean(
  width/2 - 100,
  380,
  200,
  60,
  "EFECTOS",
  sonidos
);

  }


  // ----------------------------------------------------
  // 🔹 Dibujar todo en pantalla
  // ----------------------------------------------------
  public void dibujar(float dt) {

    // Dibujar fondo
    imageMode(CORNER);
    image(fondo, 0, 0, width, height);

    // Título
    fill(255);
    textAlign(CENTER);
    textSize(40);
    text("AJUSTES", width / 2, 150);

    // Dibujar el botón booleano
    btnMusica.dibujar();

    // Dibujar el botón VOLVER
    btnVolver.dibujar();

    // Detectar clic en el botón booleano
    btnMusica.detectarClick();
    
    btnMusica.dibujar();
btnMusica.detectarClick();

btnEfectos.dibujar();
btnEfectos.detectarClick();

// Música ON/OFF
if (btnMusica.estaActivo()) sonidos.encenderTodo();
else sonidos.apagarTodo();

// Efectos ON/OFF
if (btnEfectos.estaActivo()) sonidos.activarEfectos();
else sonidos.desactivarEfectos();



    // Control del sonido según estado del botón
    if (btnMusica.estaActivo()) {
      sonidos.encenderTodo();  // Música normal
    } else {
      sonidos.apagarTodo();    // Música en 0
    }
  }


  // ----------------------------------------------------
  // 🔹 Detectar si se presionó VOLVER
  // ----------------------------------------------------
  public String detectarAccion() {

    if (btnVolver.fuePresionado()) {

      sonidos.reproducirMusicaMenu();

      return "VOLVER";
    }

    return null;
  }
}
