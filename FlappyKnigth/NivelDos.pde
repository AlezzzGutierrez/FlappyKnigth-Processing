/* ================================================================================
   CLASE: Nivel2
   --------------------------------------------------------------------------------
   Esta clase HEREDA de NivelBase → depende totalmente de su estructura interna.
   Representa un nivel intermedio con:
       - Obstáculos horizontales
       - Obstáculos que caen (Picos)
       - Obstáculos vivos (Murciélagos)
       - Generación de ítems
   Este nivel NO usa PVector. Aunque funciona, se sugiere refactorizar a PVectors 
     para manejar posiciones y velocidades de forma más limpia y orientada a objetos.
   ================================================================================ */

public class Nivel2 extends NivelBase {


    /* ================================================================================
       BLOQUE: CONFIGURACIÓN DEL NIVEL
       --------------------------------------------------------------------------------
       Estos valores pueden modificarse para ajustar dificultad.
       No son finales para permitir que el diseñador los ajuste durante desarrollo.
       ================================================================================ */

    private float intervaloObstaculos = 10.0f;           // Tiempo entre obst. básicos (no usado directamente)
    private float intervaloObstaculosVivos = 4.0f;       // Tiempo entre apariciones de Murciélagos

    private float intervaloObstaculosQueCae = 3.0f;      // Cada cuántos segundos cae un Pico
    private float timerObstaculoCae = 0;                 // Acumulador de tiempo


    /* ================================================================================
       BLOQUE: CONSTRUCTOR — INICIALIZACIÓN DE NIVEL 2
       --------------------------------------------------------------------------------
       Llama al constructor del nivel base (super)
       Setea duración del nivel
       Define tiempos de spawn
       Carga fondos del escenario
       ================================================================================ */
    public Nivel2(GestorJugadorActual gestor) {

        super(
            40,              // duración del nivel en segundos
            5.0f,            // tiempo entre ObstáculoBasico
            gestor,          // referencia al jugador
            "musica_nivel1.mp3" // música del nivel
        );

        // El nivel usa su propio intervalo para los obstáculos vivos.
        this.tiempoEntreObstaculosVivos = intervaloObstaculosVivos;

        // Fondo del nivel
        cargarFondos(
            new String[]{ "cueva.png" },
            new float[]{ -0.6f }          // parallax del fondo
        );
    }


    /* ================================================================================
       BLOQUE: ACTUALIZACIÓN
       --------------------------------------------------------------------------------
       Lógica ejecutada en cada frame:
         Actualizar base del nivel
         Controlar temporizador para obstáculos que caen
         Generar Picos
       
       Matemática usada:
         - timer += dt   → acumulación de tiempo
         - spawn cuando timer >= intervalo
       ================================================================================ */
    @Override
    public void actualizar(float dt) {

        /* --- Actualización general del nivel (fondo, jugador, etc.) --- */
        super.actualizar(dt);


        /* ---------------------------------------------------------------------------
           BLOQUE: Obstáculos que CAEN DESDE ARRIBA (tipo Pico)
           --------------------------------------------------------------------------- */

        timerObstaculoCae += dt;  // suma del tiempo usando deltaTime

        if (timerObstaculoCae >= intervaloObstaculosQueCae) {

            timerObstaculoCae = 0;  // reinicio del temporizador

            float xRandom = random(0, 1100);  
            // spawn en coordenada horizontal aleatoria (simple matemática uniforme)

            agregarObstaculo(new Pico(xRandom, -100));
        }
    }


    /* ================================================================================
       BLOQUE: DIBUJAR
       --------------------------------------------------------------------------------
       Aquí no agregamos elementos nuevos, simplemente dibujamos lo de NivelBase.
       Este bloque puede ampliarse si se quiere dibujar UI especial.
       ================================================================================ */
    @Override
    public void dibujar() {
        super.dibujar();
    }


    /* ================================================================================
       BLOQUE: CREACIÓN DE OBSTÁCULOS HORIZONTALES
       --------------------------------------------------------------------------------
       Se llama automáticamente desde el NivelBase.
       ================================================================================ */
    @Override
    protected Obstaculo crearObstaculo() {

        float yMin = Jugador.TECHO + 30;
        float yMax = Jugador.PISO - 40;

        return new ObstaculoBasico(width + 60, random(yMin, yMax),2);
    }


    /* ================================================================================
       BLOQUE: CREACIÓN DE OBSTÁCULOS VIVOS (Murciélagos)
       --------------------------------------------------------------------------------
       Movimiento independiente.
       Spawnean desde la derecha.
       ================================================================================ */
    @Override
    protected Obstaculo crearObstaculoVivo() {

        float yMin = Jugador.TECHO + 30;
        float yMax = Jugador.PISO - 40;

        return new Murcielago(width + 60, random(yMin, yMax));
    }


    /* ================================================================================
       BLOQUE: ITEMS
       --------------------------------------------------------------------------------
       50% probabilidad de vida
       50% probabilidad de stamina
       (puede editarse para ajustar balance)
       ================================================================================ */
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
