// ============================================================
// ====================== POCIÓN DE VIDA =======================
// ============================================================
//
// Ítem que cura vida al jugador cuando lo toca.
// Por defecto:
//     +10 vida
//     0 stamina
//     velocidad = 180 px/s
//
// ============================================================

public class PocionVida extends Item {

    public PocionVida(float x, float y) {

        super(
            x, y,
            30, 30,   // tamaño pequeño
            180,      // velocidad (igual que obstáculo)
            +10,      // puntosVida
            0,         // puntosStamina
            "item_pocionvida.png"
        );
    }

    @Override
    public void dibujar() {
       /* fill(0, 255, 0);  // verde
        rect(x, y, ancho, alto);**/
        if (sprite!=null){
        image(sprite,x,y,ancho,alto);
        }else{
         fill(0, 255, 0);  // verde
        rect(x, y, ancho, alto);
        }
    }
}
