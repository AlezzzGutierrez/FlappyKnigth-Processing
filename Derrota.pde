/* ========================================================================== */
/* CLASE: EscenaDerrota                                                    */
/* -------------------------------------------------------------------------- */
/* • Representa la pantalla que se muestra cuando el jugador pierde.          */
/* • Esta clase **depende** de:                                              */
/*      - GestorSonidos (inyectado → dependencia asignada)                   */
/*      - Boton (clase externa ya existente)                                 */
/*      - PImage (Processing)                                                */
/* • No usa PVectors. Si deseas mover elementos con físicas, deberías usar   */
/*   PVector para posiciones.                                                */
/* • Esta clase NO es heredada, pero podría ser incluida en una máquina de   */
/*   estados de forma modular.                                               */
/* ========================================================================== */

class EscenaDerrota {

  /* ------------------------------------------------------------------------ */
  /* Variables privadas → Encapsulación correcta                          */
  /* ------------------------------------------------------------------------ */

  private Boton btnVolver;         // Botón para retornar al menú
  private GestorSonidos sonidos;   // Referencia al gestor de sonido (dependencia)
  private PImage fondoDerrota;     // Imagen de fondo de la escena


  /* ------------------------------------------------------------------------ */
  /* Constructor                                                          */
  /* ------------------------------------------------------------------------ */
  /* • Instancia todos los elementos necesarios.                             */
  /* • Recibe el gestor de sonidos como dependencia externa.                 */
  /* • Carga la imagen de fondo desde archivo.                               */
  /* • Crea un botón centrado horizontalmente.                               */
  /*                                                                          */
  /* • Matemática simple:                                                    */
  /*     - width/2 - 150  → centra un botón de ancho 300.                    */
  /*     - height/2 + 80  → lo posiciona debajo del centro vertical.         */
  /* ------------------------------------------------------------------------ */
  public EscenaDerrota(GestorSonidos gestor) {

    this.sonidos = gestor;

    // Fondo de pantalla
    fondoDerrota = loadImage("derrota.png");

    // Crear botón de retorno
    btnVolver = new Boton(
      width  / 2 - 150,   // centro pantalla - mitad del ancho del botón
      height / 2 + 80,    // un poco debajo del centro
      300,
      70,
      "REGRESAR AL MENÚ NIVELES",
      sonidos
    );
  }


  /* ------------------------------------------------------------------------ */
  /* Dibujar escena                                                        */
  /* ------------------------------------------------------------------------ */
  /* • Param: dt → deltaTime (no usado aún, pero correcto para integración   */
  /*   futura de animaciones).                                               */
  /* • Dibuja la imagen de fondo estirada al tamaño de ventana.              */
  /* • Renderiza el botón.                                                   */
  /* ------------------------------------------------------------------------ */
  public void dibujar(float dt) {

    /* Nota:
       Si deseas hacer animaciones o transiciones, dt será útil.
       Por ahora se deja para coherencia con el resto del motor.
    **/

    imageMode(CORNER);
    image(fondoDerrota, 0, 0, width, height);

    // Dibujar botón
    btnVolver.dibujar();
  }


  /* ------------------------------------------------------------------------ */
  /* Detección de acciones del usuario                                    */
  /* ------------------------------------------------------------------------ */
  /* • Devuelve un string interpretado por la máquina de estados.            */
  /* • Se podría reemplazar por un enum si quieres mayor robustez.           */
  /* ------------------------------------------------------------------------ */
  public String detectarAccion() {

    if (btnVolver.fuePresionado()) {
      return "VOLVER";
    }

    return null;
  }

}
