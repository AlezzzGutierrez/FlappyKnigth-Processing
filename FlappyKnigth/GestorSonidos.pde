// ====================================================
// GESTOR DE SONIDOS – VERSIÓN SIMPLIFICADA Y ESTABLE
// ====================================================
import processing.sound.*;

class GestorSonidos {

  // ===============================
  // 🔹 VARIABLES PRIVADAS
  // ===============================
  private SoundFile musicaMenu;          
  private SoundFile musicaAjustes;          
  private SoundFile musicaPersonalizacion;
  private SoundFile musicaMenuNiveles;

  private SoundFile click;                  // sonido de click
  private SoundFile sonidoDorado;           // sonido especial

  private float volumen = 0.3;              // volumen base
  private PApplet app;                      // referencia al sketch
  private SoundFile musicaActual;           // música que está sonando
  
  private boolean enPausa = false;
  private float posicionPausa = 0;

  private boolean efectosActivos = true;

  // ===============================
  // 🔹 CONSTRUCTOR
  // ===============================
  public GestorSonidos(PApplet app) {
    this.app = app;

    // Cargamos las músicas
    musicaMenu = new SoundFile(app, "musica_menu1.mp3"); // fija
    musicaAjustes = new SoundFile(app, "musica_ajustes.mp3");
    musicaPersonalizacion = new SoundFile(app, "musica_personalizacion.mp3");
    musicaMenuNiveles = new SoundFile(app, "musica_niveles.mp3");

    // Cargamos efectos
    click = new SoundFile(app, "click.wav");
    sonidoDorado = new SoundFile(app, "sonido_dorado.wav");

    reproducirMusicaMenu(); // sonido inicial
  }

  // ===============================
  // 🔹 MÉTODOS DE REPRODUCCIÓN
  // ===============================
  public void reproducirMusicaMenu() {
    detenerMusicaActual();
    musicaActual = musicaMenu;
    musicaActual.loop();
    musicaActual.amp(volumen);
  }

  public void reproducirMusicaAjustes() {
    detenerMusicaActual();
    musicaActual = musicaAjustes;
    musicaActual.loop();
    musicaActual.amp(volumen);
  }

  public void reproducirMusicaPersonalizacion() {
    detenerMusicaActual();
    musicaActual = musicaPersonalizacion;
    musicaActual.loop();
    musicaActual.amp(volumen);
  }

  public void reproducirMusicaNiveles() {
    detenerMusicaActual();
    musicaActual = musicaMenuNiveles;
    musicaActual.loop();
    musicaActual.amp(volumen);
  }

  public void reproducirMusicaNivel(String archivo) {
    detenerMusicaActual();
    musicaActual = new SoundFile(app, archivo);
    musicaActual.loop();
    musicaActual.amp(volumen);
  }

  public void detenerMusicaActual() {
    if (musicaActual != null) {
      musicaActual.stop();
    }
  }

  // ===============================
  // 🔹 EFECTOS DE SONIDO
  // ===============================
  public void reproducirClick() { 
    if (efectosActivos) click.play(); 
  }

  public void reproducirDorado() {
    if (!efectosActivos) return;
    sonidoDorado.loop();
    sonidoDorado.amp(0.4);
  }

  public void detenerDorado() {
    if (!efectosActivos) return;
    new Thread(() -> {
      float v = 0.4;
      while (v > 0) {
        sonidoDorado.amp(v);
        delay(50);
        v -= 0.05;
      }
      sonidoDorado.stop();
    }).start();
  }

  // ===============================
  // 🔹 CONTROL DE VOLUMEN
  // ===============================
  public void setVolumen(float nuevoVolumen) {
    volumen = nuevoVolumen;
    if (musicaActual != null) musicaActual.amp(volumen);
    musicaAjustes.amp(volumen);
    musicaPersonalizacion.amp(volumen);
    musicaMenuNiveles.amp(volumen);
  }

  public void apagarTodo() { setVolumen(0); }
  public void encenderTodo() { setVolumen(0.3); }

  // ===============================
  // 🔹 PAUSAR / REANUDAR
  // ===============================
  public void pausar() {
    if (musicaActual != null && musicaActual.isPlaying()) {
      posicionPausa = musicaActual.position();
      musicaActual.stop();
      enPausa = true;
    }
  }

  public void reanudar() {
    if (musicaActual != null && enPausa) {
      musicaActual.cue(posicionPausa);
      musicaActual.loop();
      musicaActual.amp(volumen);
      enPausa = false;
    }
  }

  // ===============================
  // 🔹 EFECTOS ON/OFF
  // ===============================
  public void activarEfectos() { efectosActivos = true; }
  public void desactivarEfectos() { efectosActivos = false; }
}
