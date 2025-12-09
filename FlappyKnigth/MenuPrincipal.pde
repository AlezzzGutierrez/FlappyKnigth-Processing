/* =================================================================================
   CLASE: MenuPrincipal (ACTUALIZADA)
   ---------------------------------------------------------------------------------
   - Agregado nuevo botón: SALIR DEL JUEGO
   - Reacomodados los botones para encajar correctamente
   - Reducida altura Y de todos los botones grandes
================================================================================= */

class MenuPrincipal {

    private Boton btnAjustes;
    private Boton btnJugar;
    private Boton btnRerollMusica;
    private Boton btnPersonalizar;
    private Boton btnTutorial;
    private Boton btnSalir;          // ✔ NUEVO BOTÓN

    private PImage tituloImg;
    private GestorSonidos sonidos;

    private PImage[] fondos;
    private int indiceFondo;
    private int siguienteFondo;

    private int tiempoUltimoCambio;
    private int tiempoEntreFondos = 9000;
    private boolean enTransicion = false;
    private float opacidad = 0;

    private float zoom = 1.03f;
    private float zoomVel = 0.0002f;

    private float offsetX = 0;
    private float offsetVel = 0.2f;
    private int tiempoProximoCambioMovimiento;



    // =========================================================================
    //  CONSTRUCTOR
    // =========================================================================
    public MenuPrincipal(GestorSonidos gestor) {

        this.sonidos = gestor;

        int bw = 230;   // ancho botón
        int bh = 45;    // ✔ altura reducida
        int cx = width/2 - bw/2;

        int yStart = 260;   // ✔ nueva posición inicial
        int yStep  = 55;    // separación reducida para que entren todos

        btnJugar        = new Boton(cx, yStart + 0 * yStep, bw, bh, "JUGAR", sonidos);
        btnPersonalizar = new Boton(cx, yStart + 1 * yStep, bw, bh, "PERSONALIZAR", sonidos);
        btnAjustes      = new Boton(cx, yStart + 2 * yStep, bw, bh, "AJUSTES", sonidos);
        btnTutorial     = new Boton(cx, yStart + 3 * yStep, bw, bh, "TUTORIAL", sonidos);

        // ✔ Nuevo botón FINAL
        btnSalir        = new Boton(cx, yStart + 4 * yStep, bw, bh, "SALIR DEL JUEGO", sonidos);

        // Botón chico (no se cambia)
        btnRerollMusica = new Boton(width - 60, height - 60, 40, 30, "M", sonidos);

        tituloImg = loadImage("Titulo.png");

        fondos = new PImage[8];
        for (int i = 0; i < fondos.length; i++) {
            fondos[i] = loadImage("menu_fondo" + (i + 1) + ".png");
        }

        indiceFondo = int(random(fondos.length));
        tiempoUltimoCambio = millis();
        tiempoProximoCambioMovimiento = millis() + 3000;
    }



    // =========================================================================
    //  LOOP PRINCIPAL DE DIBUJO
    // =========================================================================
    public void dibujar(float dt) {

        pushMatrix();


        /* ZOOM */
        zoom += zoomVel;
        if (zoom > 1.05f || zoom < 1.00f) zoomVel *= -1;


        /* MOVIMIENTO LATERAL */
        offsetX += offsetVel;

        if (millis() > tiempoProximoCambioMovimiento) {
            offsetVel = random(-0.3f, 0.3f);
            tiempoProximoCambioMovimiento = millis() + int(random(3000, 5000));
        }

        float anchoZoom = width * zoom;
        float limiteIzq = -(anchoZoom - width);
        offsetX = constrain(offsetX, limiteIzq, 0);


        /* FONDO */
        translate(offsetX, 0);
        scale(zoom);

        imageMode(CORNER);
        image(fondos[indiceFondo], 0, 0, width, height);

        popMatrix();


        /* TRANSICIÓN DE FONDOS */
        if (!enTransicion && millis() - tiempoUltimoCambio > tiempoEntreFondos) {
            iniciarTransicion();
        }

        if (enTransicion) {

            opacidad += 5;
            fill(0, constrain(opacidad, 0, 255));
            rect(0, 0, width, height);

            if (opacidad >= 255) {
                indiceFondo = siguienteFondo;
                tiempoUltimoCambio = millis();
                enTransicion = false;
            }
        }
        else if (opacidad > 0) {
            opacidad -= 5;
            fill(0, constrain(opacidad, 0, 255));
            rect(0, 0, width, height);
        }


        /* TÍTULO */
        imageMode(CENTER);
        image(tituloImg, width / 2, 150, 400, 250);


        /* BOTONES */
        btnJugar.dibujar();
        btnPersonalizar.dibujar();
        btnAjustes.dibujar();
        btnTutorial.dibujar();
        btnSalir.dibujar();          // ✔ NUEVO
        btnRerollMusica.dibujar();
    }



    // =========================================================================
    //  TRANSICIÓN
    // =========================================================================
    private void iniciarTransicion() {
        enTransicion = true;
        opacidad = 0;
        siguienteFondo = (indiceFondo + 1) % fondos.length;
    }



    // =========================================================================
    //  ACCIONES DEL MENÚ
    // =========================================================================
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
        
        if (btnTutorial.fuePresionado()) {
            sonidos.reproducirMusicaMenu();
            return "TUTORIAL";
        }

        // ✔ NUEVO: Cerrar juego
        if (btnSalir.fuePresionado()) {
            exit();  // mismo comportamiento que cerrar ventana
        }

        return null;
    }
}
