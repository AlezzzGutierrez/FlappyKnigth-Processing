/* 
============================================================
==================== SCRIPT PRINCIPAL ======================
==================== MAQUINA DE ESTADOS ====================
============================================================

Este archivo es el "núcleo" del juego en Processing.
NO trabaja con Pvectors (/* no usa Pvectors porque es un
controlador general, no un objeto espacial */
/*
Es una clase dependiente: 
• Depende de múltiples escenas y clases externas.
• Maneja la máquina de estados del juego.
• Controla deltaTime, pausas, clics y sonidos.

Todo está separado por bloques y comentado.
============================================================
*/

// ---------------------------------------------------------
// 🔹 IMPORTS EXTERNOS (LIBRERÍAS NECESARIAS)
// ---------------------------------------------------------
import processing.sound.*;


// ---------------------------------------------------------
// 🔹 VARIABLES DE ESTADO Y CONTROL DEL JUEGO
// ---------------------------------------------------------

private boolean juegoPausado = false;   /* Activa/desactiva lógica interna */

// Estado actual de la máquina de estados
private EstadoJuego estadoActual;


// ---------------------------------------------------------
// 🔹 OBJETOS PRINCIPALES DEL JUEGO
// ---------------------------------------------------------

private GestorSonidos sonidos;              /* Controla música y efectos */
private MenuPrincipal menu;                 /* Pantalla principal */
private EscenaAjustes ajustes;              /* Menú de ajustes */
private EscenaPersonalizacion personalizacion;
private EscenaMenuNiveles menuniveles;
private Tutorial tutorial;


private EscenaVictoria escenaVictoria;
private EscenaDerrota escenaDerrota;

private NovelaInicio novelaInicio;
private NovelaFinal novelaFinal;

private GestorJugadorActual gestorJugador;

private NivelBase nivelActual;              /* Polimorfismo: puede ser Nivel1/2/3 */


// ---------------------------------------------------------
// 🔹 VARIABLES PARA DELTATIME
// ---------------------------------------------------------

private float deltaTime;       /* tiempo entre frames */
private int tiempoPrevio;      /* último millis registrado */



// =========================================================
// =========================== SETUP ========================
// =========================================================

void setup() {

  size(1000, 600);
  frameRate(30);         /* EDITABLE: cambia FPS */

  tiempoPrevio = millis();

  // ---------- Inicializar sistemas principales ----------
  sonidos = new GestorSonidos(this);
  gestorJugador = new GestorJugadorActual();

  // ---------- Crear escenas ----------
  menu            = new MenuPrincipal(sonidos);
  ajustes         = new EscenaAjustes(sonidos);
  personalizacion = new EscenaPersonalizacion(sonidos, gestorJugador);
  menuniveles     = new EscenaMenuNiveles(sonidos);
  tutorial = new Tutorial(gestorJugador);


  escenaVictoria  = new EscenaVictoria(sonidos);
  escenaDerrota   = new EscenaDerrota(sonidos);

  novelaInicio    = new NovelaInicio(sonidos);
  novelaFinal     = new NovelaFinal(sonidos);

  estadoActual = EstadoJuego.MENU;   /* Estado inicial */
}



// =========================================================
// ============================ DRAW ========================
// =========================================================

void draw() {

  /* --------------------------------
     CALCULAR DELTATIME
     -------------------------------- */
  int tiempoActual = millis();
  float dt = (tiempoActual - tiempoPrevio) / 1000.0;
  tiempoPrevio = tiempoActual;

  deltaTime = (juegoPausado ? 0 : dt);


  /* --------------------------------
     MAQUINA DE ESTADOS PRINCIPAL
     -------------------------------- */

  switch (estadoActual) {

    case MENU:
      menu.dibujar(deltaTime);
      break;

    case AJUSTES:
      ajustes.dibujar(deltaTime);
      break;

    case PERSONALIZACION:
      personalizacion.dibujar(deltaTime);
      break;

    case MENUNIVELES:
      menuniveles.dibujar(deltaTime);
      break;

    case NOVELAINICIO:
      novelaInicio.dibujar();
      break;

    case NOVELAFINAL:
      novelaFinal.dibujar();
      break;
      
      case TUTORIAL:
    tutorial.dibujar(deltaTime);
    break;


    case NIVEL1:
    case NIVEL2:
    case NIVEL3:
      manejarNivel(dt);
      break;

    case PAUSA:
      dibujarPausa();
      break;

    case VICTORIA:
      escenaVictoria.dibujar(dt);
      break;

    case DERROTA:
      escenaDerrota.dibujar(dt);
      break;
  }
}



// =========================================================
// ================ MANEJO DE NIVELES =======================
// =========================================================

/* Se extrae a una función para reducir repetición */
private void manejarNivel(float dt) {

  nivelActual.actualizar(dt);
  nivelActual.dibujar();

  if (nivelActual.debeIrAVictoria()) {
    sonidos.detenerMusicaActual();
    estadoActual = EstadoJuego.VICTORIA;
    sonidos.reproducirMusicaMenu();
  }
  else if (nivelActual.debeIrADerrota()) {
    sonidos.detenerMusicaActual();
    estadoActual = EstadoJuego.DERROTA;
    sonidos.reproducirMusicaMenu();
  }
}



// =========================================================
// ========================= PAUSA =========================
// =========================================================

private void dibujarPausa() {

  nivelActual.dibujar();     /* Se dibuja congelado */

  fill(0, 150);
  rect(0, 0, width, height);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(70);
  text("PAUSE", width/2, height/2);

  textSize(25);
  text("Pulsa ESC para continuar", width/2, height/2 + 60);
}



// =========================================================
// ======================== KEY PRESSED ====================
// =========================================================

void keyPressed() {

  if (key == ESC) {

    key = 0; /* evita que Processing cierre */

    if (estadoActual == EstadoJuego.NIVEL1 ||
        estadoActual == EstadoJuego.NIVEL2 ||
        estadoActual == EstadoJuego.NIVEL3) {

      juegoPausado = true;
      estadoActual = EstadoJuego.PAUSA;
      sonidos.pausar();
    }

    else if (estadoActual == EstadoJuego.PAUSA) {
      juegoPausado = false;

      if (nivelActual instanceof Nivel1) estadoActual = EstadoJuego.NIVEL1;
      if (nivelActual instanceof Nivel2) estadoActual = EstadoJuego.NIVEL2;
      if (nivelActual instanceof Nivel3) estadoActual = EstadoJuego.NIVEL3;

      sonidos.reanudar();
    }
  }
  
  // ----------------------------------------------------
// TUTORIAL — avanzar texto con ENTER
// ----------------------------------------------------
if (estadoActual == EstadoJuego.TUTORIAL) {
    if (key == ENTER || key == RETURN) {

        // avanzarTexto() devuelve true cuando ya terminó
        boolean finalizado = tutorial.avanzar();

        if (finalizado) {
            estadoActual = EstadoJuego.MENU;
            sonidos.reproducirMusicaMenu();
        }
    }
}

}



// =========================================================
// ======================== MOUSE PRESSED ==================
// =========================================================

void mousePressed() {

  /* ----------------------------------------------------
     MENU PRINCIPAL
     ---------------------------------------------------- */
  if (estadoActual == EstadoJuego.MENU) {

    String accion = menu.detectarAccion();

    if (accion == "AJUSTES") {
      estadoActual = EstadoJuego.AJUSTES;
      sonidos.reproducirMusicaPersonalizacion();
    }
    else if (accion == "PERSONALIZAR") {
      estadoActual = EstadoJuego.PERSONALIZACION;
      sonidos.reproducirMusicaAjustes();
    }
    else if (accion == "MENUNIVELES") {
      estadoActual = EstadoJuego.MENUNIVELES;
      sonidos.reproducirMusicaNiveles();
    }
    else if (accion == "TUTORIAL") {     // ← ← ← FALTA ESTO
      tutorial.reiniciar();              // ← Reinicia el tutorial
      estadoActual = EstadoJuego.TUTORIAL;
      sonidos.reproducirMusicaMenu();    // O música suave si quieres cambiar
    }
}
  


  /* ----------------------------------------------------
     AJUSTES
     ---------------------------------------------------- */
  else if (estadoActual == EstadoJuego.AJUSTES) {
    if (ajustes.detectarAccion() == "VOLVER") {
      estadoActual = EstadoJuego.MENU;
      sonidos.reproducirMusicaMenu();
    }
  }


  /* ----------------------------------------------------
     PERSONALIZACIÓN
     ---------------------------------------------------- */
  else if (estadoActual == EstadoJuego.PERSONALIZACION) {
    if (personalizacion.detectarAccion() == "VOLVER") {
      estadoActual = EstadoJuego.MENU;
      sonidos.reproducirMusicaMenu();
    }
  }


  /* ----------------------------------------------------
     NOVELAS
     ---------------------------------------------------- */
  else if (estadoActual == EstadoJuego.NOVELAINICIO) {
    if (novelaInicio.detectarAccion() == "VOLVER_MENUNIVELES")
      estadoActual = EstadoJuego.MENUNIVELES;
  }

  else if (estadoActual == EstadoJuego.NOVELAFINAL) {
    if (novelaFinal.detectarAccion() == "VOLVER_MENUNIVELES")
      estadoActual = EstadoJuego.MENUNIVELES;
  }



  /* ----------------------------------------------------
     VICTORIA / DERROTA
     ---------------------------------------------------- */
  else if (estadoActual == EstadoJuego.VICTORIA) {
    sonidos.detenerMusicaActual();
    if (escenaVictoria.detectarAccion() == "VOLVER") {
      estadoActual = EstadoJuego.MENUNIVELES;
      sonidos.reproducirMusicaNiveles();
    }
  }

  else if (estadoActual == EstadoJuego.DERROTA) {
    sonidos.detenerMusicaActual();
    if (escenaDerrota.detectarAccion() == "VOLVER") {
      estadoActual = EstadoJuego.MENUNIVELES;
      sonidos.reproducirMusicaNiveles();
    }
  }



  /* ----------------------------------------------------
     MENÚ DE NIVELES
     ---------------------------------------------------- */
  else if (estadoActual == EstadoJuego.MENUNIVELES) {

    String accion = menuniveles.detectarAccion();

    if (accion == "VOLVER") {
      estadoActual = EstadoJuego.MENU;
      sonidos.reproducirMusicaMenu();
    }

    else if (accion == "NIVEL1") {
      cargarNivel(new Nivel1(gestorJugador), EstadoJuego.NIVEL1);
    }

    else if (accion == "NIVEL2") {
      cargarNivel(new Nivel2(gestorJugador), EstadoJuego.NIVEL2);
    }

    else if (accion == "NIVEL3") {
      cargarNivel(new Nivel3(gestorJugador), EstadoJuego.NIVEL3);
    }

    else if (accion == "HISTORIA") {
      estadoActual = EstadoJuego.NOVELAINICIO;
      sonidos.reproducirMusicaNovela();
    }

    else if (accion == "FINAL") {
      estadoActual = EstadoJuego.NOVELAFINAL;
      sonidos.reproducirMusicaNovelaFinal();
    }
  }
}



// =========================================================
// ================== Cargar Niveles (FUNCION) =============
// =========================================================

private void cargarNivel(NivelBase nivel, EstadoJuego estadoDestino) {

  nivelActual = nivel;
  nivelActual.reiniciar();               /* obligatorio */
  estadoActual = estadoDestino;

  sonidos.reproducirMusicaNivel(nivelActual.archivoMusica);
}
