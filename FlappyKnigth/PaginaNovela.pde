/* ============================================================
   CLASE: PaginaNovela
   Representa una única página del modo historia (solo una imagen).
   ============================================================ */
class PaginaNovela {

    private PImage imagen;  /* Imagen que contiene esta página */

    /* ------------------------------------------------------------
       CONSTRUCTOR
       Recibe una imagen y la guarda
       ------------------------------------------------------------ */
    public PaginaNovela(PImage img) {
        this.imagen = img;
    }

    /* ------------------------------------------------------------
       DIBUJAR
       Muestra la imagen centrada en pantalla
       ------------------------------------------------------------ */
    public void dibujar() {

        float w = 400;
        float h = 500;

        /* Calcular posición centrada */
        float x = (width  - w) * 0.5f;
        float y = (height - h) * 0.5f;

        /* Dibujar imagen */
        image(imagen, x, y, w, h);
    }
}
