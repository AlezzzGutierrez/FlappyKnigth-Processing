/* ============================================================
   ======================= CLASE POCIONVIDA ====================
   ============================================================

   Clase derivada (HEREDADA) de la clase base Item.
   Representa una poción que restaura vida al jugador.

   • Esta clase depende de Item (clase padre).
   • NO utiliza PVectores, porque la poción es un objeto estático
     que solo se dibuja en una posición fija.
   • Si en el futuro deseas mover la poción con física,
     entonces sí deberías convertir (x,y) en un PVector.

   Todos los campos están encapsulados correctamente como private.
   Todo se inicializa en el constructor.
   El código está dividido por bloques lógicos para fácil lectura.
   ============================================================ */

public class PocionVida extends Item {

    /* ============================================================
       ======================= VARIABLES PRIVADAS =================
       ============================================================ */

    /* Sprite (imagen) de la poción.
       EDITABLE: puedes reemplazar la imagen desde fuera si deseas. */
    private PImage sprite;


    /* ============================================================
       ========================== CONSTRUCTOR =====================
       ============================================================ */

    /*
     * Constructor de la poción:
     *  - Llama a super() para inicializar todos los atributos del Item.
     *  - Carga el sprite correspondiente.
     */
    public PocionVida(float x, float y) {

        super(
            x, y,      /* posición */
            30, 30,    /* tamaño ancho/alto */
            180,       /* velocidad (si el ítem la usa) */
            +10,       /* puntos de vida que otorga */
            0          /* puntos de stamina */
        );

        /* Carga de imagen del sprite */
        this.sprite = loadImage("pocionVida.png");
    }


    /* ============================================================
       ============================ DIBUJAR ========================
       ============================================================ */

    /*
     * Dibuja la poción en pantalla.
     * - Si la imagen existe, se dibuja.
     * - Si no existe, se usa un fallback: un rectángulo verde.
     */
    @Override
    public void dibujar() {

        /* Si el sprite está disponible → dibujarlo */
        if (sprite != null) {
            image(sprite, x, y, ancho, alto);
            return;
        }

        /* Si la imagen no cargó → fallback visual */
        fill(0, 255, 0);  /* verde */
        rect(x, y, ancho, alto);
    }


    /* ============================================================
       ============================= EDITABLE ======================
       ============================================================ */

    /*
     * Permite cambiar el sprite desde afuera.
     * Útil si deseas un pack de texturas o tema alternativo.
     */
    public void setSprite(PImage nuevoSprite) {
        this.sprite = nuevoSprite;
    }
}
