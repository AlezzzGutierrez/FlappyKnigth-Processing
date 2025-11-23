public class ObstaculoVivoBasico extends ObstaculoVivo {

    public ObstaculoVivoBasico(float x, float y) {
        super(
            x, y,
            40, 40,        // tamaño
            120,           // velocidad (px por segundo)
            20,            // daño
            2.0f           // seguirá al jugador por 2 segundos
        );
    }

    @Override
    public void dibujar() {
        fill(255, 100, 0); // naranja
        rect(x, y, ancho, alto);
    }
}
