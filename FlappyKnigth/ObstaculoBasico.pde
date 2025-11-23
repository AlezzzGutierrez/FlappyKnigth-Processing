public class ObstaculoBasico extends Obstaculo {

    public ObstaculoBasico(float x, float y) {
        super(
            x, y,
            40, 40,   // tamaño del cuadrado
            200,      // velocidad
            10        // daño
        );
    }

    @Override
    public void dibujar() {
        fill(255, 0, 0); // rojo
        rect(x, y, ancho, alto);
    }
}
