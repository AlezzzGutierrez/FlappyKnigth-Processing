/* ---------------------------------------------------------
   Clase ObstaculoVivoBasico
   ---------------------------------------------------------
   Esta clase HEREDA de ObstaculoVivo
   Representa un enemigo simple animado
   Usa sprites secuenciales para generar animación
   No usa PVectores → Se recomienda migrar a PVector
      para simplificar posiciones y velocidades.
   --------------------------------------------------------- */

public class ObstaculoVivoBasico extends ObstaculoVivo {

    /* ---------------------------------------------------------
       BLOQUE: Atributos privados (encapsulación)
       ---------------------------------------------------------
       Se instancian en el constructor o contienen valores
       por defecto seguros.
       --------------------------------------------------------- */

    // Lista de sprites de animación en orden de frames
    private ArrayList<PImage> sprites;

    // Control del tiempo acumulado para decidir cambio de frame
    private float tiempoAnim;

    // Tiempo que debe pasar entre frames (segundos)
    private float velocidadAnim;  

    // Frame actual del sprite
    private int frameActual;


    /* ---------------------------------------------------------
       BLOQUE: Constructor
       ---------------------------------------------------------
       Aquí se inicializan TODOS los atributos necesarios
       para asegurar que la clase no tenga valores nulos.
       --------------------------------------------------------- */
    public ObstaculoVivoBasico(float x, float y) {

        // Llamada obligatoria a la clase padre
        super(
            x, y,
            50, 50,    // tamaño del sprite
            150,       // velocidad (px/seg)
            20,        // daño al jugador
            2.0f       // tiempo que sigue al jugador
        );

        // Inicialización explícita de atributos
        this.sprites = new ArrayList<PImage>();
        this.tiempoAnim = 0f;
        this.velocidadAnim = 0.15f;
        this.frameActual = 0;

        /* -----------------------------------------------------
           Cargar sprites de animación
           Editable → Puedes agregar los que desees
           ----------------------------------------------------- */
        sprites.add(loadImage("pajaro1.png"));
        sprites.add(loadImage("pajaro2.png"));
        sprites.add(loadImage("pajaro3.png"));
        // sprites.add(loadImage("pajaro4.png"));  // opcional
    }


    /* ---------------------------------------------------------
       BLOQUE: Actualización lógica
       ---------------------------------------------------------
       dt → Time delta, tiempo entre frames (segundos)
       jugador → Dependencia directa (la clase depende del jugador)
       ---------------------------------------------------------
       Se usa matemática simple:
         tiempoAnim += dt
         → Acumula tiempo real.
       
         Si tiempoAnim >= velocidadAnim → pasa al siguiente frame.

         frameActual = (frameActual + 1) % sprites.size()
         → bucle perfectamente circular.
       --------------------------------------------------------- */
    @Override
    public void actualizar(float dt, Jugador jugador) {

        // Primero ejecuta el comportamiento base del enemigo
        super.actualizar(dt, jugador);

        // --- Control de animación ---
        tiempoAnim += dt;

        if (tiempoAnim >= velocidadAnim) {
            tiempoAnim = 0f;

            // Avanza al siguiente frame en ciclo infinito
            frameActual = (frameActual + 1) % sprites.size();
        }
    }


    /* ---------------------------------------------------------
       BLOQUE: Renderizado en pantalla
       ---------------------------------------------------------
       Si no hay sprites cargados → no dibuja nada.
       ---------------------------------------------------------
       Recom. futura:
       Migrar el x,y a PVector para consistencia con Processing.
       --------------------------------------------------------- */
    @Override
    public void dibujar() {

        if (sprites.isEmpty()) return;

        PImage actual = sprites.get(frameActual);

        // Dibuja el frame actual con el tamaño configurado
        image(actual, x, y, ancho, alto);
    }
}
