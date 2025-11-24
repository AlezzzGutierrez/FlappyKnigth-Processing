// ====================================================
// SCRIPT PRINCIPAL – MAQUINA DE ESTADOS SIMPLE
// ====================================================

// Importamos librería de sonido
import processing.sound.*;

private boolean juegoPausado = false;

// ===============================
// 🔹 OBJETOS PRINCIPALES
// ===============================
private GestorSonidos sonidos;
private MenuPrincipal menu;
private EscenaAjustes ajustes;
private EscenaPersonalizacion personalizacion;
private EscenaMenuNiveles menuniveles;

// 🔹 Estado actual del juego (enum definido por ti)
private EstadoJuego estadoActual;

private GestorJugadorActual gestorJugador;

private NivelBase nivelActual;

private EscenaVictoria escenaVictoria;
private EscenaDerrota escenaDerrota;






// ===============================
// 🔹 VARIABLES DELTATIME
// ===============================
private float deltaTime;       // tiempo entre frames
private int tiempoPrevio;      // guarda millis del frame anterior

void setup() {
  size(1000, 600);

  tiempoPrevio = millis();
  
  frameRate(30);   // ← AJUSTA AQUÍ A TU FPS DESEADOS

  sonidos = new GestorSonidos(this);

  // AHORA sí crear las escenas
  menu = new MenuPrincipal(sonidos);
  ajustes = new EscenaAjustes(sonidos);
  gestorJugador = new GestorJugadorActual();
  personalizacion = new EscenaPersonalizacion(sonidos, gestorJugador);

  menuniveles = new EscenaMenuNiveles(sonidos);
  
  escenaVictoria = new EscenaVictoria(sonidos);
  escenaDerrota = new EscenaDerrota(sonidos);



  estadoActual = EstadoJuego.MENU;
}


void draw() {

  // ===============================
  // 🔹 CALCULAR DELTATIME
  // ===============================
  int tiempoActual = millis();
  float dt = (tiempoActual - tiempoPrevio) / 1000.0;
  tiempoPrevio = tiempoActual;

  if (!juegoPausado) {
    deltaTime = dt;   // normal
  } else {
    deltaTime = 0;    // congelado
  }


  // ===============================
  // 🔹 MAQUINA DE ESTADOS
  // ===============================

  if (estadoActual == EstadoJuego.MENU) {
    menu.dibujar(deltaTime);
  }

  else if (estadoActual == EstadoJuego.AJUSTES) {
    ajustes.dibujar(deltaTime);
  }

  else if (estadoActual == EstadoJuego.PERSONALIZACION) {
    personalizacion.dibujar(deltaTime);
  }

  else if (estadoActual == EstadoJuego.MENUNIVELES) {
    menuniveles.dibujar(deltaTime);
  }

  else if (estadoActual == EstadoJuego.NIVEL1) {

    nivelActual.actualizar(deltaTime);
    nivelActual.dibujar();

    if (nivelActual.debeIrAVictoria()) {
      sonidos.detenerMusicaActual();  // ←← DETENER MÚSICA DEL NIVEL
      estadoActual = EstadoJuego.VICTORIA;
      sonidos.reproducirMusicaMenu();
    }
    else if (nivelActual.debeIrADerrota()) {
      sonidos.detenerMusicaActual();  // ←← DETENER MÚSICA DEL NIVEL
      estadoActual = EstadoJuego.DERROTA;
      sonidos.reproducirMusicaMenu();
    }
  } else if (estadoActual == EstadoJuego.NIVEL2) {

  nivelActual.actualizar(deltaTime);
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
} else if (estadoActual == EstadoJuego.NIVEL3) {

  nivelActual.actualizar(deltaTime);
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



  else if (estadoActual == EstadoJuego.PAUSA) {

    // 🔹 Dibujar el nivel congelado
    nivelActual.dibujar();

    // 🔹 Overlay oscuro
    fill(0, 150);
    rect(0, 0, width, height);

    // 🔹 Texto PAUSA
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(70);
    text("PAUSE", width / 2, height / 2);

    textSize(25);
    text("Pulsa ESC para continuar", width / 2, height / 2 + 60);
  }

  else if (estadoActual == EstadoJuego.VICTORIA) {
    escenaVictoria.dibujar(deltaTime);
  }

  else if (estadoActual == EstadoJuego.DERROTA) {
    escenaDerrota.dibujar(deltaTime);
  }
}


void keyPressed() {
  if (key == ESC) {
    key = 0; // evita que Processing cierre el sketch
    
    if (estadoActual == EstadoJuego.NIVEL1) {
      estadoActual = EstadoJuego.PAUSA;
      juegoPausado = true;
      sonidos.pausar();
    }
    else if (estadoActual == EstadoJuego.PAUSA) {
      estadoActual = EstadoJuego.NIVEL1;
      juegoPausado = false;
      sonidos.reanudar();
    }
  }
}



// ====================================================
// 🔹 MANEJO DE CLICK SEGÚN ESTADO
// ====================================================
void mousePressed() {

  // -------------------------------
  // 📌 ESTADO: MENÚ PRINCIPAL
  // -------------------------------
  if (estadoActual == EstadoJuego.MENU) {

    String accion = menu.detectarAccion();

    if (accion == "AJUSTES") {
      estadoActual = EstadoJuego.AJUSTES;
      sonidos.reproducirMusicaPersonalizacion();

    } else if (accion == "PERSONALIZAR") {
      estadoActual = EstadoJuego.PERSONALIZACION;
      sonidos.reproducirMusicaAjustes();

    } else if (accion == "MENUNIVELES") {
      estadoActual = EstadoJuego.MENUNIVELES;
      sonidos.reproducirMusicaNiveles();
    }
  }

  // -------------------------------
  // 📌 ESTADO: AJUSTES
  // -------------------------------
  else if (estadoActual == EstadoJuego.AJUSTES) {
    String accion = ajustes.detectarAccion();
    if (accion == "VOLVER") {
      estadoActual = EstadoJuego.MENU;
      sonidos.reproducirMusicaMenu();
    }
  }

  // -------------------------------
  // 📌 PERSONALIZACIÓN
  // -------------------------------
  else if (estadoActual == EstadoJuego.PERSONALIZACION) {
    String accion = personalizacion.detectarAccion();
    if (accion == "VOLVER") {
      estadoActual = EstadoJuego.MENU;
      sonidos.reproducirMusicaMenu();
    }
  }
  
    // -------------------------------
  // 📌 VICTORIA DERROTA
  // -------------------------------
  
else if (estadoActual == EstadoJuego.VICTORIA) {

  String accion = escenaVictoria.detectarAccion();
  sonidos.detenerMusicaActual();

  if (accion == "VOLVER") {
    estadoActual = EstadoJuego.MENUNIVELES;
    sonidos.reproducirMusicaNiveles();
  }
}

else if (estadoActual == EstadoJuego.DERROTA) {
 sonidos.detenerMusicaActual();

  String accion = escenaDerrota.detectarAccion();
  if (accion == "VOLVER") {
    estadoActual = EstadoJuego.MENUNIVELES;
    sonidos.reproducirMusicaNiveles();
  }
}




  // -------------------------------
  // 📌 MENÚ DE NIVELES
  // -------------------------------
  else if (estadoActual == EstadoJuego.MENUNIVELES) {
    String accion = menuniveles.detectarAccion();
    if (accion == "VOLVER") {
      estadoActual = EstadoJuego.MENU;
      sonidos.reproducirMusicaMenu();
    } else if (accion == "NIVEL1") {
  nivelActual = new Nivel1(gestorJugador);  // crea el nivel
  nivelActual.reiniciar();                 // ← ← ← SUPER IMPORTANTE
  estadoActual = EstadoJuego.NIVEL1;        // cambia de pantalla
  sonidos.reproducirMusicaNivel(nivelActual.archivoMusica);

} else if (accion == "NIVEL2") {
  nivelActual = new Nivel2(gestorJugador);
  nivelActual.reiniciar();
  estadoActual = EstadoJuego.NIVEL2;
  sonidos.reproducirMusicaNivel(nivelActual.archivoMusica);
} else if (accion == "NIVEL3") {
  nivelActual = new Nivel3(gestorJugador);
  nivelActual.reiniciar();
  estadoActual = EstadoJuego.NIVEL3;
  sonidos.reproducirMusicaNivel(nivelActual.archivoMusica);
}



  }
}
