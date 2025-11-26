/* =======================================================================
   CLASE: Arquero
   -----------------------------------------------------------------------
   Clase HIJA → hereda de Jugador (dependencia total de esa clase).
   No es independiente: usa atributos y métodos heredados, como:
       - stamina
       - spriteActual
       - tiempoSpriteEspecial
       - nivelActual
       - sonido reutilizado desde GestorSonidos
   No utiliza PVector para posición (lo maneja la clase padre).
       --> Esto se aclara porque tal vez quieras migrarlo más adelante.
   Esta clase se centra en animaciones y habilidades del arquero.
======================================================================= */
public class Arquero extends Jugador {


    /* ===================================================================
       BLOQUE 1 — CONSTRUCTOR
       -------------------------------------------------------------------
       Se instancian las variables necesarias:
       - color del jugador
       - tamaño del sprite
       - sprites normal y especial
       -------------------------------------------------------------------
       Todo en este bloque se PUEDE EDITAR libremente:
           • tamaños
           • sprites
           • colores
           • archivos de imagen
    =================================================================== */
    public Arquero(String nombre) {

        /* Llama al constructor del Jugador (clase padre)**/
        super(nombre, color(#FFBE08)); /*color característico del arquero**/ 

        /*Tamaño del sprite (se puede editar)**/ 
        this.ancho = 110;
        this.alto  = 110;

        /*Sprites específicos del arquero (cargados localmente)**/ 
        spriteNormal  = loadImage("Arq1.png");
        spriteEspecial = loadImage("cab2.png");

        /*Sprite inicial mostrado en pantalla**/ 
        spriteActual = spriteNormal;
    }



    /* ===================================================================
       BLOQUE 2 — SALTO
       -------------------------------------------------------------------
       Explicación:
       - Cada vez que el jugador presiona barra espaciadora,
         el arquero usa spriteEspecial durante 1 segundo.
       - "super.presionarSpace()" ejecuta la física / movimiento del padre.
       -------------------------------------------------------------------
       Matemática:
       tiempoSpriteEspecial = 1.0f;
       → contador que se va reduciendo gradualmente en update() del padre.
    =================================================================== */
    @Override
    public void presionarSpace() {
        super.presionarSpace(); /*movimiento base del jugador**/ 

        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f; /*duración exacta**/ 
    }



    /* ===================================================================
       BLOQUE 3 — HABILIDAD Z : "FLECHA EXACTA"
       -------------------------------------------------------------------
       Costo: 3 de stamina
       Efecto:
       . Cambia sprite 1 segundo
       . Reproduce sonido asociado
       . Elimina SOLO el obstáculo MÁS cercano al jugador

       Dependencias:
       - nivelActual (clase 'Nivel') → calcula obstáculos
       - sonidos (desde GestorSonidos)

       Matemática:
       No hay cálculos complejos aquí, solo llamadas a otros sistemas.
    =================================================================== */
    @Override
    protected void habilidadZ() {

        if (getStamina() < 3) return; // suficiente stamina?
        consumirStamina(3);

        // Sprite especial animado
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;

        // Sonido característico de una flecha
        sonidos.reproducirSonidoFlecha();

        // Interactúa con el nivel → elimina SOLO 1 obstáculo
        if (nivelActual != null) {
            nivelActual.eliminarObstaculoMasCercano(this);
        }

        println(
            getNombre() +
            " dispara una FLECHA EXACTA (elimina 1 obstáculo cercano)"
        );
    }



    /* ===================================================================
       BLOQUE 4 — HABILIDAD X : "LLUVIA DE FLECHAS"
       -------------------------------------------------------------------
       Costo: 9 de stamina
       Efecto:
       Cambia sprite 1 segundo
       Lanza sonido de múltiples flechas
       Elimina los 4 obstáculos MÁS cercanos

       Explicación matemática:
       - No hay cálculos propios aquí.
       - La lógica pesada la ejecuta "nivelActual":
            eliminar4ObstaculosMasCercanos()
         que seguramente usa distancias y comparaciones.
    =================================================================== */
    @Override
    protected void habilidadX() {

        if (getStamina() < 9) return; // suficiente stamina?
        consumirStamina(9);

        // Animación (sprite especial por 1 segundo)
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;

        // Sonido múltiple
        sonidos.reproducirSonidoFlechas();

        // Elimina varios obstáculos
        if (nivelActual != null) {
            nivelActual.eliminar4ObstaculosMasCercanos(this);
        }

        println(
            getNombre() +
            " usa LLUVIA DE FLECHAS (elimina 4 obstáculos cercanos)"
        );
    }
}
