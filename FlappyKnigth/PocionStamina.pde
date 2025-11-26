/* ============================================================
   ===================== CLASE POCIONSTAMINA ===================
   ============================================================

   Clase heredada de Item (clase padre).
   Representa una poción que otorga STAMINA al jugador.

   • Esta clase depende de Item.
   • NO utiliza PVectores porque es un objeto estático en pantalla,
     solo se dibuja donde se coloca. Si en el futuro deseas que
     tenga movimiento físico, deberás migrar (x, y) a PVectors.

   • Encapsulación correcta: todas las variables son privadas.
   • Constructor inicializa todo lo que la clase necesita.
   • Código organizado en bloques lógicos y comentado.
   • Contiene zona EDITABLE para personalizar sprite.
   ============================================================ */

public class PocionStamina extends Item {

    /* ============================================================
       ======================= VARIABLES PRIVADAS ==================
       ============================================================ */

    /*
     * Sprite de la poción.
     * EDITABLE: se puede reemplazar desde afuera con setSprite().
     */
    private PImage sprite;


    /* ============================================================
       ============================ CONSTRUCTOR ===================
       ============================================================ */

    /*
     * Constructor:
     *  - Llama al constructor de Item con parámetros predefinidos
     *    para una poción de stamina.
     *  - Carga el sprite gráfico de esta poción.
     */
    public PocionStamina(float x, float y) {

        super(
            x, y,         /* posición */
            30, 30,       /* tamaño */
            180,          /* velocidad (si Item lo usa) */
            0,            /* puntosVida */
            +16           /* puntosStamina */
        );

        /* Cargar imagen del sprite */
        this.sprite = loadImage("pocionStamina.png");
    }


    /* ============================================================
       ============================== DIBUJAR ======================
       ============================================================ */

    /*
     * Dibuja la poción en pantalla:
     *  - Si el sprite existe → se dibuja correctamente.
     *  - Si no existe → dibuja fallback (un rectángulo celeste).
     */
    @Override
    public void dibujar() {

        if (sprite != null) {
            image(sprite, x, y, ancho, alto);
            return;
        }

        /* Fallback visual si la imagen falla */
        fill(0, 180, 255); 
        rect(x, y, ancho, alto);
    }


    /* ============================================================
       ============================== EDITABLE =====================
       ============================================================ */

    /*
     * Permite cambiar el sprite desde afuera.
     * Útil si deseas cambiar el estilo visual del juego.
     */
    public void setSprite(PImage nuevoSprite) {
        this.sprite = nuevoSprite;
    }
}
