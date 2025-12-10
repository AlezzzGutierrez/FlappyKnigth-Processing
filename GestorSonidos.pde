// ========================================================================
//  GESTOR DE SONIDOS 
// ========================================================================
class GestorSonidos {

  /* --------------------------------------------------------------------
     NOTA GENERAL DE LA CLASE
     --------------------------------------------------------------------
     - Esta clase actúa como GESTOR / CONTROLADOR DE SONIDOS del juego.
     - Es un módulo dependiente, NO es heredado y NO extiende de nada.
     - Depende de: PApplet y SoundFile.
     - No utiliza PVector porque no es necesario para su función.
     -------------------------------------------------------------------- */

  // ================================================================
  // BLOQUE 1 – VARIABLES DE REFERENCIA Y ENTORNO
  // ================================================================
  private PApplet app;              // referencia necesaria para cargar sonidos

  // ================================================================
  // BLOQUE 2 – MÚSICA GENERAL
  // ================================================================
  private SoundFile[] musicasMenu;  // arreglo de pistas para menú (aleatorias)

  private SoundFile musicaAjustes;
  private SoundFile musicaPersonalizacion;
  private SoundFile musicaMenuNiveles;
  private SoundFile musicaNovela;
  private SoundFile musicaNovelaFinal;

  private SoundFile musicaActual;   // referencia a la pista que está sonando

  // ================================================================
  // BLOQUE 3 – EFECTOS DE SONIDO (FX)
  // ================================================================
  private SoundFile click;
  private SoundFile sonidoDorado;

  // SFX habilidades → están separados por claridad
  private SoundFile sonidoCorte;
  private SoundFile sonidoCortes;
  private SoundFile sonidoCurar;
  private SoundFile sonidoCurar2;
  private SoundFile sonidoFlecha;
  private SoundFile sonidoFlechas;
  private SoundFile sonidoEscudo;
  private SoundFile sonidoEscudos;

  // ================================================================
  // BLOQUE 4 – CONTROL GENERAL
  // ================================================================
  private float volumen = 0.3f;     // volumen global
  private boolean efectosActivos = true;

  // pausa manual
  private boolean enPausa = false;
  private float posicionPausa = 0;

  // ================================================================
  // CONSTRUCTOR
  // ================================================================
  public GestorSonidos(PApplet app) {
    this.app = app;

    /* --------------------------------------------------------------
       Carga de TODOS los sonidos
       -------------------------------------------------------------- */

    // Música de menú (aleatoria)
    musicasMenu = new SoundFile[] {
      new SoundFile(app, "musica_menu1.mp3"),
      new SoundFile(app, "musica_menu2.mp3"),
      new SoundFile(app, "musica_menu3.mp3")
    };

    // Música fija de secciones
    musicaAjustes          = new SoundFile(app, "musica_ajustes.mp3");
    musicaPersonalizacion  = new SoundFile(app, "musica_personalizacion.mp3");
    musicaMenuNiveles      = new SoundFile(app, "musica_niveles.mp3");
    musicaNovela           = new SoundFile(app, "musica_novela.mp3");
    musicaNovelaFinal      = new SoundFile(app, "musica_novela2.mp3");

    // Efectos de usuario
    click         = new SoundFile(app, "click.wav");
    sonidoDorado  = new SoundFile(app, "sonido_dorado.wav");

    // Efectos de habilidades
    sonidoCorte   = new SoundFile(app, "corte.mp3");
    sonidoCortes  = new SoundFile(app, "cortes.mp3");
    sonidoCurar   = new SoundFile(app, "curar.mp3");
    sonidoCurar2  = new SoundFile(app, "curar2.mp3");
    sonidoFlecha  = new SoundFile(app, "flecha.mp3");
    sonidoFlechas = new SoundFile(app, "flechas.mp3");
    sonidoEscudo  = new SoundFile(app, "escudo.mp3");
    sonidoEscudos = new SoundFile(app, "escudos.mp3");

    // Reproducir música inicial
    reproducirMusicaMenu();
  }

  // =====================================================================
  // BLOQUE 5 – PAUSAR Y REANUDAR LA MÚSICA
  // =====================================================================
  public void pausar() {
    if (musicaActual != null && musicaActual.isPlaying()) {

      /* explicación matemática:
         - position() devuelve segundos de reproducción
         - guardamos ese punto para reanudar luego
      */

      posicionPausa = musicaActual.position();
      musicaActual.stop();
      enPausa = true;
    }
  }

  public void reanudar() {
    if (musicaActual != null && enPausa) {
      musicaActual.cue(posicionPausa); // vuelve al tiempo exacto
      musicaActual.loop();
      musicaActual.amp(volumen);
      enPausa = false;
    }
  }

  // =====================================================================
  // BLOQUE 6 – REPRODUCCIÓN MUSICAL
  // =====================================================================
  public void reproducirMusicaMenu() {
    detenerTodo();

    int i = (int) app.random(musicasMenu.length);  // selección aleatoria

    musicaActual = musicasMenu[i];
    musicaActual.loop();
    musicaActual.amp(volumen);
  }

  public void reproducirMusicaAjustes() {
    reproducir(musicaAjustes);
  }

  public void reproducirMusicaPersonalizacion() {
    reproducir(musicaPersonalizacion);
  }

  public void reproducirMusicaNiveles() {
    reproducir(musicaMenuNiveles);
  }

  public void reproducirMusicaNivel(String archivo) {
    detenerTodo();
    musicaActual = new SoundFile(app, archivo);
    musicaActual.loop();
    musicaActual.amp(volumen);
  }

  public void reproducirMusicaNovela() {
    reproducir(musicaNovela);
  }

  public void reproducirMusicaNovelaFinal() {
    reproducir(musicaNovelaFinal);
  }

  /* Método auxiliar para evitar repetir código */
  private void reproducir(SoundFile musica) {
    detenerTodo();
    musicaActual = musica;
    musicaActual.loop();
    musicaActual.amp(volumen);
  }

  // =====================================================================
  // BLOQUE 7 – DETENER MÚSICA ACTUAL
  // =====================================================================
  public void detenerMusicaActual() {
    if (musicaActual != null) musicaActual.stop();
  }

  // =====================================================================
  // BLOQUE 8 – EFECTOS DE SONIDO
  // =====================================================================
  public void reproducirClick() {
    if (efectosActivos) click.play();
  }

  public void reproducirDorado() {
    if (!efectosActivos) return;

    sonidoDorado.loop();
    sonidoDorado.amp(0.4f);
  }

  public void detenerDorado() {
    if (!efectosActivos) return;

    /* ------------------------------------------------------------------
       FADE OUT MANUAL
       Matemática sencilla:
       - partimos de volumen 0.4
       - restamos 0.05 cada 50ms
       - → transición suave de apagado
       ------------------------------------------------------------------ */
    new Thread(() -> {
      float v = 0.4f;
      while (v > 0) {
        sonidoDorado.amp(v);
        app.delay(50);
        v -= 0.05f;
      }
      sonidoDorado.stop();
    }).start();
  }

  // Habilidades
  public void reproducirCorte() { if (efectosActivos) sonidoCorte.play(); }
  public void reproducirCortes() { if (efectosActivos) sonidoCortes.play(); }
  public void reproducirSonidoCurar() { if (efectosActivos) sonidoCurar.play(); }
  public void reproducirSonidoCurar2() { if (efectosActivos) sonidoCurar2.play(); }
  public void reproducirSonidoFlecha() { if (efectosActivos) sonidoFlecha.play(); }
  public void reproducirSonidoFlechas() { if (efectosActivos) sonidoFlechas.play(); }
  public void reproducirSonidoEscudo() { if (efectosActivos) sonidoEscudo.play(); }
  public void reproducirSonidoEscudos() { if (efectosActivos) sonidoEscudos.play(); }

  // =====================================================================
  // BLOQUE 9 – ACTIVAR / DESACTIVAR EFECTOS
  // =====================================================================
  public void activarEfectos() {
    efectosActivos = true;
  }

  public void desactivarEfectos() {
    efectosActivos = false;

    // Detiene sonidos en loop o sostenidos
    sonidoDorado.stop();
    sonidoCorte.stop();
    sonidoCortes.stop();
    sonidoCurar.stop();
    sonidoCurar2.stop();
    sonidoFlecha.stop();
    sonidoFlechas.stop();
    sonidoEscudo.stop();
    sonidoEscudos.stop();
  }

  // =====================================================================
  // BLOQUE 10 – CONTROL DE VOLUMEN
  // =====================================================================
  public void setVolumen(float v) {

    /* Consideración matemática:
       - v debe estar preferentemente entre 0 y 1
       - no se fuerza límite pero sería recomendable
    */

    volumen = v;
    if (musicaActual != null) musicaActual.amp(volumen);
  }

  public void apagarTodo()    { setVolumen(0); }
  public void encenderTodo()  { setVolumen(0.3f); }

  // =====================================================================
  // BLOQUE 11 – DETENER TODO (MÚSICA)
  // =====================================================================
  private void detenerTodo() {
    if (musicaActual != null) musicaActual.stop();

    for (SoundFile m : musicasMenu) m.stop();
    musicaAjustes.stop();
    musicaPersonalizacion.stop();
    musicaMenuNiveles.stop();
    musicaNovela.stop();
    musicaNovelaFinal.stop();
  }
}
