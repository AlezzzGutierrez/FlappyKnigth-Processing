/* =================================================================================
   CLASE: MenuPrincipal
   ---------------------------------------------------------------------------------
   Clase independiente (NO heredada), pero dependiente de:
       - Boton
       - GestorSonidos
   Controla toda la lógica visual del menú:
       fondos, zoom, movimiento lateral y transiciones.
   No utiliza PVectors → solo variables escalares (advertencia solicitada).
   Todos los atributos poseen encapsulación privada.
   ---------------------------------------------------------------------------------
   NOTA EDITABLE:
   Puedes expandir esta clase agregando nuevos fondos, animaciones o lógica de UI.
   ================================================================================= */

class MenuPrincipal {

    /* =============================================================================
       BLOQUE: BOTONES Y ELEMENTOS DEL MENÚ
       -----------------------------------------------------------------------------
       Se instancian en el constructor usando posición absoluta.
       Se recomienda usar PVectors para posiciones si el proyecto crece más.
       ============================================================================= */

    private Boton btnAjustes;
    private Boton btnJugar;
    private Boton btnRerollMusica;
    private Boton btnPersonalizar;
    private PImage tituloImg;
    private Boton btnTutorial;



    /* =============================================================================
       BLOQUE: SISTEMA DE SONIDOS
       -----------------------------------------------------------------------------
       Dependencia hacia GestorSonidos para reproducir música al presionar botones.
       ============================================================================= */

    private GestorSonidos sonidos;


    /* =============================================================================
       BLOQUE: FONDOS DEL MENÚ
       -----------------------------------------------------------------------------
       fondos[] almacena todos los fondos posibles.
       indiceFondo → fondo actual que se está mostrando.
       siguienteFondo → próximo fondo para la transición fade.
       ============================================================================= */

    private PImage[] fondos;
    private int indiceFondo;
    private int siguienteFondo;


    /* =============================================================================
       BLOQUE: TRANSICIONES ENTRE FONDOS
       -----------------------------------------------------------------------------
       tiempoEntreFondos → cada cuántos ms cambia de fondo (9000 ms ~ 9 seg)
       enTransicion → controla el estado del fade.
       opacidad → valor interpolado de 0 a 255 para cubrir pantalla.
       ============================================================================= */

    private int tiempoUltimoCambio;
    private int tiempoEntreFondos = 9000;
    private boolean enTransicion = false;
    private float opacidad = 0;


    /* =============================================================================
       BLOQUE: ZOOM SUAVE Y MOVIMIENTO LATERAL
       -----------------------------------------------------------------------------
       zoom → escala actual del fondo (1.03 por defecto)
       zoomVel → velocidad del zoom (cambia signo automáticamente)
       
       offsetX → desplazamiento horizontal del fondo
       offsetVel → velocidad horizontal que cambia cada 3–5 segundos
       
       Se podría convertir esto a PVectors, pero actualmente todo es escalar.
       ============================================================================= */

    private float zoom = 1.03f;
    private float zoomVel = 0.0002f;

    private float offsetX = 0;
    private float offsetVel = 0.2f;
    private int tiempoProximoCambioMovimiento;


    /* =============================================================================
       BLOQUE: CONSTRUCTOR
       -----------------------------------------------------------------------------
       Inicializa botones, fondos, sonido y valores base.
       Verifica que todas las variables sean asignadas.
       ============================================================================= */

    public MenuPrincipal(GestorSonidos gestor) {

        this.sonidos = gestor;

        /* --- Instancia de botones --- */
        btnAjustes       = new Boton(width/2 - 100, 450, 200, 60, "AJUSTES", sonidos);
        btnPersonalizar  = new Boton(width/2 - 100, 370, 200, 60, "PERSONALIZAR", sonidos);
        btnRerollMusica  = new Boton(width - 60, height - 60, 40, 30, "M", sonidos);
        btnJugar         = new Boton(width/2 - 100, 290, 200, 60, "JUGAR", sonidos);
        btnTutorial = new Boton(width/2 - 100, 530, 200, 60, "TUTORIAL", sonidos);


        tituloImg = loadImage("Titulo.png");

        /* --- Carga de fondos --- */
        fondos = new PImage[8];
        for (int i = 0; i < fondos.length; i++) {
            fondos[i] = loadImage("menu_fondo" + (i + 1) + ".png");
        }

        /* --- Fondo inicial --- */
        indiceFondo = int(random(fondos.length));
        tiempoUltimoCambio = millis();

        /* --- Movimiento lateral inicial --- */
        tiempoProximoCambioMovimiento = millis() + 3000;
    }



    /* =============================================================================
       BLOQUE: DIBUJAR (LOOP PRINCIPAL DEL MENÚ)
       -----------------------------------------------------------------------------
       Maneja en orden:
       1) Zoom animado
       2) Movimiento lateral suave
       3) Render del fondo
       4) Transiciones de fade
       5) Título
       6) Botones
       -----------------------------------------------------------------------------
       Se usa dt (deltaTime), aunque algunas operaciones aún dependen de millis().
       ============================================================================= */

    public void dibujar(float dt) {

        pushMatrix();


        /* ------------------------------------------------------------
           1️ZOOM SUAVE
           ------------------------------------------------------------
           Matemática:
               zoom += zoomVel
           Si supera límites → invertir dirección
           ------------------------------------------------------------ */
        zoom += zoomVel;
        if (zoom > 1.05f || zoom < 1.00f) {
            zoomVel *= -1;
        }


        /* ------------------------------------------------------------
           2️MOVIMIENTO LATERAL SUAVE
           ------------------------------------------------------------ */
        offsetX += offsetVel;

        // Cambia la dirección de offset cada 3–5 segundos
        if (millis() > tiempoProximoCambioMovimiento) {
            offsetVel = random(-0.3f, 0.3f);
            tiempoProximoCambioMovimiento = millis() + int(random(3000, 5000));
        }

        // Limitar el movimiento según el zoom aplicado
        float anchoZoom = width * zoom;
        float limiteIzq = -(anchoZoom - width);
        offsetX = constrain(offsetX, limiteIzq, 0);


        /* ------------------------------------------------------------
           3️DIBUJADO DEL FONDO (con zoom + desplazamiento)
           ------------------------------------------------------------ */
        translate(offsetX, 0);
        scale(zoom);

        imageMode(CORNER);
        image(fondos[indiceFondo], 0, 0, width, height);

        popMatrix();


        /* ------------------------------------------------------------
           4️TRANSICIÓN FADE ENTRE FONDOS
           ------------------------------------------------------------ */

        // Iniciar transición nueva
        if (!enTransicion && millis() - tiempoUltimoCambio > tiempoEntreFondos) {
            iniciarTransicion();
        }

        // Durante transición (fade IN)
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

        // Fade OUT
        else if (opacidad > 0) {
            opacidad -= 5;
            fill(0, constrain(opacidad, 0, 255));
            rect(0, 0, width, height);
        }


        /* ------------------------------------------------------------
           5️TÍTULO DEL JUEGO
           ------------------------------------------------------------ */
        imageMode(CENTER);
        image(tituloImg, width / 2, 150, 400, 250);


        /* ------------------------------------------------------------
           6️BOTONES
           ------------------------------------------------------------ */
        btnPersonalizar.dibujar();
        btnAjustes.dibujar();
        btnRerollMusica.dibujar();
        btnJugar.dibujar();
        btnTutorial.dibujar();

    }



    /* =============================================================================
       BLOQUE: TRANSICIONES
       -----------------------------------------------------------------------------
       Simple cambio de estado a fade-in.
       ============================================================================= */

    private void iniciarTransicion() {
        enTransicion = true;
        opacidad = 0;
        siguienteFondo = (indiceFondo + 1) % fondos.length;
    }



    /* =============================================================================
       BLOQUE: DETECTAR ACCIONES DEL MENÚ
       -----------------------------------------------------------------------------
       Cada botón retorna un String indicando qué escena cargar.
       Si no hay acción, retorna null.
       ============================================================================= */

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


        return null;
    }
}
