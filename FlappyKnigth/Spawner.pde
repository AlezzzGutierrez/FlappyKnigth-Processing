public class Spawner {

    private float x, y;
    private float ancho = 200;
    private float alto = 100;

    private boolean entrando = true;
    private float yObjetivo;
    private float velocidad = 50;

    public Spawner(float x, float yInicial, float yDescenso) {
        this.x = x;
        this.y = yInicial;
        this.yObjetivo = yInicial + yDescenso; // baja 500
    }

    public void actualizar(float dt) {

        if (entrando) {
            y += velocidad * dt;

            if (y >= yObjetivo) {
                y = yObjetivo;
                entrando = false;
            }
        }
    }

    public boolean terminoEntrada() {
        return !entrando;
    }

    public float getX() { return x; }
    public float getY() { return y; }

    public void dibujar() {
        fill(200, 0, 200, 120);
        rect(x, y, ancho, alto);
    }
}
