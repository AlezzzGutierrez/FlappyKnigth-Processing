// ============================================================
// ==================== POCIÓN DE STAMINA ======================
// ============================================================
//
// Ítem que regenera stamina al jugador.
// Por defecto:
//     0 vida
//     +20 stamina
//     velocidad = 180 px/s
//
// ============================================================

public class PocionStamina extends Item {

    public PocionStamina(float x, float y) {

        super(
            x, y,
            30, 30,      // tamaño
            180,         // velocidad
            +20,           // puntosVida
            0 ,         // puntosStamina
             "item_pocionvida.png"
        );
    }

    @Override
    public void dibujar() {
       /*fill(0, 180, 255);  // celeste
        rect(x, y, ancho, alto);**/
         if (sprite!=null){
        image(sprite,x,y,ancho,alto);
        }else{
         fill(0, 255, 0);  // verde
        rect(x, y, ancho, alto);
        }
    }
}
