// ============================================================
// =============== OBSTÁCULO QUE CAE DESDE ARRIBA ===============
// ============================================================
//
// - Aparece en X aleatoria entre 500 y 1000
// - Siempre inicia en Y = -100
// - Se mueve hacia la izquierda (como todos)
// - Y también cae en Y con velocidad configurable
//
// ============================================================

public class ObstaculoQueCae extends Obstaculo {

    private float velocidadCaida = 90; // px/seg hacia abajo

    public ObstaculoQueCae(float x, float y) {
        super(
            x, y,
            40, 40,      // tamaño del obstáculo
            210,         // velocidad horizontal hacia la izquierda
            6           // daño
        );
    }

    @Override
    public void actualizar(float dt) {

        // movimiento normal (izquierda)
        super.actualizar(dt);

        // caída vertical
        y += velocidadCaida * dt;
    }

    @Override
    public void dibujar() {
        fill(255, 150, 0); // naranja
        rect(x, y, ancho, alto);
    }
}
