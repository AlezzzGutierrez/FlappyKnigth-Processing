/* --------------------------------------------------------------
   CLASE CABALLERO
   --------------------------------------------------------------
   - Esta clase hereda de Jugador → es una SUBCLASE dependiente.
   - Representa un tipo específico de jugador con habilidades
     únicas (Z y X) y sprites personalizados.

   - NOTA: Esta clase NO usa PVector para posición/movimiento.
     Si se desea trabajar con físicas más avanzadas,
-----------------------------------------------------------------*/
public class Caballero extends Jugador {

    /* ==============================================================
       CONSTRUCTOR
       --------------------------------------------------------------
       - Recibe el nombre del jugador.
       - Llama al constructor de Jugador con un color base.
       - Define tamaño del sprite.
       - Carga sprites principales.
       ==============================================================
    */
    public Caballero(String nombre) {
        super(nombre, color(#17DFE8));  // Llamada al constructor padre (Jugador)

        /* Tamaño del sprite */
        this.ancho = 110;
        this.alto  = 110;

        /* Carga de imágenes */
        spriteNormal   = loadImage("cab1.png");
        spriteEspecial = loadImage("cab2.png");

        /* Sprite inicial */
        spriteActual = spriteNormal;
    }



    /* ==============================================================
       HABILIDAD Z – Corte Cercano
       --------------------------------------------------------------
       COSTE: 5 puntos de stamina.
       EFECTO:
       - Usa un sprite especial por 1 segundo.
       - Reproduce un sonido.
       - Elimina obstáculos cercanos en un radio determinado.

       Matemática aplicada:
       rango = ancho * 3
       Esto permite que el rango de impacto escale con el tamaño
       del sprite del Caballero.
       ==============================================================
    */
    @Override
    protected void habilidadZ() {

        /* Evita ejecutar si no hay stamina suficiente */
        if (getStamina() < 5) return;
        consumirStamina(5);

        /* Sprite especial activo durante 1 segundo */
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;

        /* Reproduce sonido del corte */
        sonidos.reproducirCorte();

        /* Radio de impacto → escala según el ancho del sprite */
        float rango = getAncho() * 3;

        /* Llamamos al nivel actual para ejecutar la eliminación */
        if (nivelActual != null) {
            nivelActual.eliminarObstaculosCercanos(this, rango);
        }

        println(getNombre() + " usa TAJADA PESADA");
    }



    /* ==============================================================
       HABILIDAD X – Golpe Terremoto
       --------------------------------------------------------------
       COSTE: 15 puntos de stamina.
       EFECTO:
       - Usa sprite especial por 1 segundo.
       - Reproduce sonido diferente al de Z.
       - Elimina obstáculos en un área especial definida por el nivel.

       Nota: La lógica de impacto depende del método del nivel.
       ==============================================================
    */
    @Override
    protected void habilidadX() {

        /* Verificación de stamina */
        if (getStamina() < 15) return;
        consumirStamina(15);

        /* Activar sprite especial por 1 segundo */
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;

        /* Sonido de ataque pesado */
        sonidos.reproducirCortes();

        /* Acción del terremoto */
        if (nivelActual != null) {
            nivelActual.eliminarObstaculosEnRangoCaballero(this);
        }

        println(getNombre() + " usa GOLPE TERREMOTO");
    }



    /* ==============================================================
       EVENTO: presionarSpace()
       --------------------------------------------------------------
       - Llama al salto de Jugador (super).
       - Activa sprite especial durante 1 segundo.

       Nota:
       El salto NO depende de PVector, usa la lógica propia
       definida en la clase Jugador.
       ==============================================================
    */
    @Override
    public void presionarSpace() {
        super.presionarSpace(); // Ejecuta el salto original

        /* Cambia sprite mientras salta */
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;
    }
}
