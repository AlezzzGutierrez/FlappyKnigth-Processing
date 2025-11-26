/* ================================================================================
   CLASE: Nivel3 
   --------------------------------------------------------------------------------
   Hereda de NivelBase → esta clase DEPENDE completamente de la arquitectura 
     de niveles ya creada.
   Controla:
       - Obstáculos que caen
       - Obstáculos vivos
       - Fase del dragón
       - Ataques del dragón
   No usa PVectors → manejar x,y manualmente funciona, 
     pero se recomienda migrar a PVector en un refactor futuro.
   ================================================================================ */

public class Nivel3 extends NivelBase { 


    /* ================================================================================
       BLOQUE: INTERVALOS DE GENERACIÓN DE OBSTÁCULOS
       --------------------------------------------------------------------------------
       Estos valores pueden modificarse libremente para cambiar la dificultad.
       ================================================================================ */

    private float intervaloObstaculos = 1000.0f;     // No se usa directamente aquí, pero se conserva.
    private float intervaloObstaculosVivos = 1000.0f;

    private float intervaloObstaculosQueCae = 0.5f;  // Generación de piedras de lava
    private float timerObstaculoCae = 0;


    /* ================================================================================
       BLOQUE: DRAGÓN (SPRITES, POSICIÓN Y ANIMACIÓN)
       --------------------------------------------------------------------------------
       - dragonX, dragonY         → posición actual del dragón
       - dragonYFinal             → punto donde se detendrá al descender
       - velocidadDragon          → velocidad vertical (px/seg)

       frameDragon              → frame actual de la animación
       tiempoFrameDragon        → acumulador deltaTime para animación
       duracionFrameDragon      → tiempo entre frames

       Estos valores son libres de editar.
       ================================================================================ */

    private ArrayList<PImage> dragonSprites = new ArrayList<PImage>();

    private float dragonX = 700;    
    private float dragonY = -100;   
    private float dragonYFinal = 200;
    private float velocidadDragon = 100;

    private boolean dragonActivo = false;
    private boolean dragonBajando = false;

    private int frameDragon = 0;
    private float tiempoFrameDragon = 0;
    private float duracionFrameDragon = 0.15f;


    /* ================================================================================
       BLOQUE: SISTEMA DE INVOCACIÓN / ATAQUES DEL DRAGÓN
       --------------------------------------------------------------------------------
       - tiempoAparicionDragon  → Momento del nivel donde aparece
       - rafagas de bolas de fuego
       - número de invocaciones por ráfaga

       Matemática simple:
       comparaciones de tiempo
       contadores acumulados por dt
       ================================================================================ */

    private float tiempoAparicionDragon = 109; 
    private float timerRafaga = 0;

    private boolean haciendoRafaga = false;
    private float timerDentroRafaga = 0;
    private int vivosInvocados = 0;


    /* ================================================================================
       BLOQUE: CONSTRUCTOR 
       --------------------------------------------------------------------------------
       Inicializa todo lo necesario
       Llama al constructor de NivelBase
       Carga fondos y sprites del dragón
       ================================================================================ */

    public Nivel3(GestorJugadorActual gestor) { 

        // Llamada al constructor de la clase padre
        super(
            220,                 // velocidad del nivel
            5.0f,                // tiempo entre ítems
            gestor,              // referencia al jugador
            "musica_nivel3.mp3"  // música del nivel
        );

        // Ajuste del intervalo de obstáculos vivos
        this.tiempoEntreObstaculosVivos = intervaloObstaculosVivos;

        // Fondo del nivel
        cargarFondos(
            new String[]{ "volcan.png" },
            new float[]{ -0.6f }
        );

        // Sprites del dragón
        dragonSprites.add(loadImage("dragon1.png"));
        dragonSprites.add(loadImage("dragon2.png"));
        dragonSprites.add(loadImage("dragon3.png"));
    }


    /* ================================================================================
       BLOQUE: ACTUALIZACIÓN DEL NIVEL
       --------------------------------------------------------------------------------
       Esta función coordina:
         Obstáculos que caen
         Inicio del dragón
         Movimiento del dragón
         Animación del dragón
         Ataques del dragón

       Matemática usada:
       - Movimiento → valor += velocidad * dt
       - Temporizadores → acumulación de tiempo dt
       ================================================================================ */

    @Override
    public void actualizar(float dt) {

        /* --- Actualización estándar del nivel (fondo, jugador, obstáculos base) --- */
        super.actualizar(dt);


        /* ---------------------------------------------------------------------------
           BLOQUE: Obstáculos que caen desde arriba
           --------------------------------------------------------------------------- */
        timerObstaculoCae += dt;
        if (timerObstaculoCae >= intervaloObstaculosQueCae) {
            timerObstaculoCae = 0;

            float xRandom = random(0, 1100);

            // Obstáculo que cae → Piedra de lava
            agregarObstaculo(new PiedraLava(xRandom, -100));
        }


        /* ---------------------------------------------------------------------------
           BLOQUE: Activación inicial del dragón
           ---------------------------------------------------------------------------
           Cuando el tiempo del nivel supere 'tiempoAparicionDragon'
           el dragón comienza a bajar.
           --------------------------------------------------------------------------- */
        if (!dragonActivo && tiempoTranscurrido >= tiempoAparicionDragon) {
            dragonActivo = true;
            dragonBajando = true;
        }


        /* ---------------------------------------------------------------------------
           BLOQUE: Movimiento del dragón hacia su posición final
           ---------------------------------------------------------------------------
           Movimiento vertical simple:
               Y += velocidad * dt
           --------------------------------------------------------------------------- */
        if (dragonBajando) {

            dragonY += velocidadDragon * dt;

            if (dragonY >= dragonYFinal) { 
                dragonY = dragonYFinal; 
                dragonBajando = false;
            }
        }


        /* ---------------------------------------------------------------------------
           BLOQUE: Animación del dragón
           --------------------------------------------------------------------------- */
        if (dragonActivo) {
            tiempoFrameDragon += dt;

            if (tiempoFrameDragon >= duracionFrameDragon) {
                frameDragon = (frameDragon + 1) % dragonSprites.size();
                tiempoFrameDragon = 0;
            }
        }


        /* ---------------------------------------------------------------------------
           BLOQUE: Sistema de ráfagas del dragón
           ---------------------------------------------------------------------------
           Cuando el dragón ya está fijo en su posición:
                - espera 10 segundos
                - lanza 5 bolas de fuego cada 0.4 segundos
           --------------------------------------------------------------------------- */
        if (dragonActivo && !dragonBajando) {

            timerRafaga += dt;

            if (!haciendoRafaga && timerRafaga >= 10) {
                haciendoRafaga = true;
                timerDentroRafaga = 0;
                vivosInvocados = 0;
                timerRafaga = 0;
            }

            if (haciendoRafaga) {

                timerDentroRafaga += dt;

                if (timerDentroRafaga >= 0.4f) {
                    timerDentroRafaga = 0;

                    agregarObstaculo(new BolaFuego(dragonX - 40, dragonY + 80));

                    vivosInvocados++;

                    if (vivosInvocados >= 5) {
                        haciendoRafaga = false;
                    }
                }
            }
        }
    }


    /* ================================================================================
       BLOQUE: DIBUJAR
       --------------------------------------------------------------------------------
       Se dibuja lo del nivel base + el dragón si está activo.
       ================================================================================ */

    @Override
    public void dibujar() {
        super.dibujar();

        if (dragonActivo) {
            image(dragonSprites.get(frameDragon), dragonX - 50, dragonY - 50, 450, 300);
        }
    }


    /* ================================================================================
       BLOQUE: FABRICACIÓN DE OBSTÁCULOS DEL NIVEL
       --------------------------------------------------------------------------------
       Se crean obstáculos estándar, obstáculos vivos, e ítems.
       Estos métodos pueden editarse sin peligro, siempre que se retorne
       el tipo correcto.
       ================================================================================ */

    @Override
    protected Obstaculo crearObstaculo() {

        float yMin = Jugador.TECHO + 30;
        float yMax = Jugador.PISO - 40;

        return new ObstaculoBasico(width + 60, random(yMin, yMax));
    }

    @Override
    protected Obstaculo crearObstaculoVivo() {

        float yMin = Jugador.TECHO + 30;
        float yMax = Jugador.PISO - 40;

        return new BolaFuego(width + 60, random(yMin, yMax));
    }

    @Override
    protected Item crearItem() {

        float yMin = Jugador.TECHO + 40;
        float yMax = Jugador.PISO - 40;

        if (random(1) < 0.5) {
            return new PocionVida(width + 60, random(yMin, yMax));
        } else {
            return new PocionStamina(width + 60, random(yMin, yMax));
        }
    }
}
