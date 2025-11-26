/* 
 ======================================================================
   CLASE Mago
   ----------------------------------------------------------------------
   • Clase HEREDADA → extiende a Jugador.
   • Clase completamente dependiente de Jugador (usa sus métodos y 
     variables como stamina, curar(), tiempoSpriteEspecial, etc.)
   • Usa sprites cargados con loadImage() → dependiente de Processing.
   • NO utiliza PVector actualmente — recomendable para manejar 
     movimiento, colisiones y posiciones en el futuro.
 ======================================================================
*/
public class Mago extends Jugador {

    /* ------------------------------------------------------------------
       CONSTRUCTOR — Inicializa atributos del Mago
       ------------------------------------------------------------------
       Parámetro:
           nombre = nombre del jugador
       ------------------------------------------------------------------ */
    public Mago(String nombre) {

        /* 
           Se llama al constructor padre (Jugador):
           - Asigna nombre
           - Asigna color único del Mago
        */
        super(nombre, color(#FE08FF)); // color rosado característico

        /* --- Configurar tamaño --- */
        this.ancho = 110;
        this.alto  = 110;

        /* --- Cargar sprites --- */
        spriteNormal   = loadImage("Mag1.png"); // sprite base del mago
        spriteEspecial = loadImage("cab2.png"); // sprite para habilidades

        /* --- Sprite inicial --- */
        spriteActual = spriteNormal;
    }



    /* ==================================================================
       MÉTODO: presionarSpace() — Salto especial del Mago
       ------------------------------------------------------------------
       • Cambia sprite por 1 segundo.
       • Llama al comportamiento base del Jugador.
       ------------------------------------------------------------------ */
    @Override
    public void presionarSpace() {

        /* ejecuta la lógica común del salto */
        super.presionarSpace();

        /* Cambiar a sprite especial durante 1 segundo */
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;   // tiempo simple, sin cálculos extra
    }



    /* ==================================================================
       HABILIDAD Z — Curación Arcana (+15 vida)
       ------------------------------------------------------------------
       • Consume 5 de stamina.
       • Activa sprite especial 1 segundo.
       • Usa operación matemática simple (suma de vida en método curar()).
       ------------------------------------------------------------------ */
    @Override
    protected void habilidadZ() {

        /* Verificar stamina mínima necesaria */
        if (getStamina() < 5) return;

        /* Resta stamina usando método encapsulado */
        consumirStamina(5);

        /* Activar sprite especial durante 1 segundo */
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;

        /* Reproducir sonido asociado */
        sonidos.reproducirSonidoCurar();

        /* Sumar vida (operación simple manipulada por método curar()) */
        curar(15);

        println(getNombre() + " canaliza ENERGÍA ARCANA (+15 vida)");
    }



    /* ==================================================================
       HABILIDAD X — Tormenta Cósmica (destruye 20 obstáculos)
       ------------------------------------------------------------------
       • Requiere 15 stamina.
       • Sprite especial por 1 segundo.
       • Lógica delegada al nivel actual (patrón de dependencia).
       ------------------------------------------------------------------ */
    @Override
    protected void habilidadX() {

        /* Verificar stamina mínima */
        if (getStamina() < 15) return;

        /* Consumir stamina */
        consumirStamina(15);

        /* Sprite especial temporal */
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;

        /* Sonido específico */
        sonidos.reproducirSonidoCurar2();

        /* 
           Si hay un nivel activo:
           - se llama a eliminar20ObstaculosMasCercanos(this)
           - delega la lógica al nivel
           - LA CLASE MAGO NO CALCULA distancias ni físicas
             (responsabilidad del nivel).
        */
        if (nivelActual != null) {
            nivelActual.eliminar20ObstaculosMasCercanos(this);
        }

        println(getNombre() + 
            " desata TORMENTA CÓSMICA (destruye 20 obstáculos)");
    }
}
