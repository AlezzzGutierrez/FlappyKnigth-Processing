/* 
============================================================
====================== ESCENA VICTORIA =====================
============================================================

 Pantalla mostrada cuando el jugador completa un nivel.
 Contiene:
  - Fondo estático (imagen)
  - Botón para regresar al menú de niveles

 NOTA IMPORTANTE:
 • ESTA CLASE NO TRABAJA CON PVECTORES porque representa una
   *escena estática*, no un objeto en movimiento.
   Esto es correcto y no necesita Pvectors.

 • Todo está dividido en bloques y comentado.
 • Todas las variables están encapsuladas como private.
============================================================
*/

class EscenaVictoria {

    /* ============================================================
       ===================== VARIABLES PRIVADAS ====================
       ============================================================ */

    /* Botón para volver al menú niveles */
    private Boton btnVolver;

    /* Controlador externo de sonidos */
    private GestorSonidos sonidos;

    /* Imagen de fondo de la escena */
    private PImage fondoVictoria;


    /* ============================================================
       ========================= CONSTRUCTOR =======================
       ============================================================ */

    public EscenaVictoria(GestorSonidos gestor) {

        /* Guardar referencia a sonidos */
        this.sonidos = gestor;

        /* Cargar imagen del fondo */
        this.fondoVictoria = loadImage("victoria.png");

        /* Crear el botón para volver */
        this.btnVolver = new Boton(
            width / 2 - 150,      /* posición X */
            height / 2 + 80,      /* posición Y */
            300,                  /* ancho */
            70,                   /* alto */
            "REGRESAR AL MENÚ NIVELES",
            sonidos
        );
    }


    /* ============================================================
       ============================ DIBUJAR ========================
       ============================================================ */

    public void dibujar(float dt) {

        /* Dibujar imagen de fondo */
        imageMode(CORNER);
        image(fondoVictoria, 0, 0, width, height);

        /* Dibujar botón */
        btnVolver.dibujar();
    }


    /* ============================================================
       ======================== INTERACCIÓN ========================
       ============================================================ */

    public String detectarAccion() {

        if (btnVolver.fuePresionado()) {
            return "VOLVER";
        }

        return null;
    }


    /* ============================================================
       ========================= EDITABLE ==========================
       ============================================================ */

    /* Cambiar fondo desde afuera si deseas un tema alternativo */
    public void setFondo(PImage nuevoFondo) {
        this.fondoVictoria = nuevoFondo;
    }

    /* (ELIMINADO) → ya que Boton NO tiene setTexto() */
}
