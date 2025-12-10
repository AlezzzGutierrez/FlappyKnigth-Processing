/* ================================================================================
   CLASE: Murcielago
   --------------------------------------------------------------------------------
   Clase HEREDADA → extiende de ObstaculoVivo.
   Dependiente del sistema de persecución y actualización de ObstaculoVivo.
   Representa un enemigo vivo que sigue al jugador durante un tiempo definido.
   NO utiliza PVector. Se recomienda migrar a PVector en un futuro para limpiar
     la gestión de posición y velocidad.
   ================================================================================ */

public class Murcielago extends ObstaculoVivo {

    /* ================================================================================
       BLOQUE: SPRITES Y ANIMACIÓN
       --------------------------------------------------------------------------------
       - Los sprites contienen cada frame del batido de alas.
       - velocidadAnim controla cuántos segundos permanece un frame en pantalla.
       - tiempoAnim se acumula mediante dt (deltaTime).
       ================================================================================ */
    
    private ArrayList<PImage> sprites = new ArrayList<PImage>();
    
    private float tiempoAnim = 0;          // Acumula tiempo entre frames
    private float velocidadAnim = 0.15f;   // Segundos por cada frame
    private int frameActual = 0;           // Frame actual del murciélago


    /* ================================================================================
       BLOQUE: CONSTRUCTOR
       --------------------------------------------------------------------------------
       Parámetros heredados hacia ObstaculoVivo:
       - x, y → posición inicial
       - ancho, alto → tamaño del sprite
       - velocidad → velocidad horizontal/base
       - daño → daño por colisión
       - tiempoPersecuciónJugador → tiempo en el que seguirá al jugador

       Se instancian TODOS los atributos necesarios.
       ================================================================================ */
    public Murcielago(float x, float y) {
        
        super(
            x, y,
            50, 50,     // tamaño
            160,        // velocidad horizontal
            25,         // daño por colisión
            2.5f        // tiempo siguiendo al jugador
        );

        /* ---------------------------------------------------------------------------
           BLOQUE: CARGA DE SPRITES
           ---------------------------------------------------------------------------
           Puedes editar la lista para añadir más frames.
           --------------------------------------------------------------------------- */
        sprites.add(loadImage("murcielago1.png"));
        sprites.add(loadImage("murcielago2.png"));
        sprites.add(loadImage("murcielago3.png"));

        // Para extender la animación:
        // sprites.add(loadImage("murcielago4.png"));
    }


    /* ================================================================================
       BLOQUE: ACTUALIZACIÓN
       --------------------------------------------------------------------------------
       Movement logic → hecho por ObstaculoVivo (seguimiento del jugador)
       Animación → se maneja aquí

       Matemática usada:
       tiempoAnim += dt
       Si tiempoAnim >= velocidadAnim → cambiar frame

       Este sistema garantiza animación fluida acorde al frameRate real.
       ================================================================================ */
    @Override
    public void actualizar(float dt, Jugador jugador) {

        /* --- Movimiento y lógica base del obstáculo vivo --- */
        super.actualizar(dt, jugador);


        /* --- Animación del murciélago --- */
        tiempoAnim += dt;

        if (tiempoAnim >= velocidadAnim) {
            tiempoAnim = 0;

            frameActual++;
            if (frameActual >= sprites.size()) {
                frameActual = 0; // ciclo infinito de animación
            }
        }
    }


    /* ================================================================================
       BLOQUE: DIBUJAR
       --------------------------------------------------------------------------------
       Renderiza el frame actual.
       Se recomienda, a futuro, dibujar usando PVectors para mayor claridad.
       ================================================================================ */
    @Override
    public void dibujar() {

        if (sprites.isEmpty()) return; // seguridad por si hubo error de carga

        PImage actual = sprites.get(frameActual);

        // Se dibuja directamente en x, y heredado (sin PVector)
        image(actual, x, y, ancho, alto);
    }
}
