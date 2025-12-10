public class Caballero extends Jugador {

    private ArrayList<PImage> animacionZ;
    private ArrayList<PImage> animacionX;
    private ArrayList<PImage> animacionActiva;
    private int frameActual;
    private float tiempoAnim;
    private float velocidadAnim;
    private boolean volverASpriteNormal; // bandera para resetear al terminar

    public Caballero(String nombre) {
        super(nombre, color(#17DFE8));

        this.ancho = 128;
        this.alto  = 100;

        spriteNormal   = loadImage("cabSword1.png");
        spriteEspecial = loadImage("cabSword2.png");
        spriteActual   = spriteNormal;

        animacionZ = new ArrayList<PImage>();
        animacionX = new ArrayList<PImage>();
        animacionActiva = null;
        frameActual = 0;
        tiempoAnim = 0f;
        velocidadAnim = 0.1f;
        volverASpriteNormal = false;

        // Sprites habilidad Z
        for (int i = 1; i <= 6; i++) {
            animacionZ.add(loadImage("cabSwordHabZ" + i + ".png"));
        }

        // Sprites habilidad X
        for (int i = 1; i <= 12; i++) {
            animacionX.add(loadImage("cabSwordHabX" + i + ".png"));
        }
    }

    @Override
    protected void habilidadZ() {
        if (getStamina() < 5) return;
        consumirStamina(5);

        sonidos.reproducirCorte();

        float rango = getAncho() * 3;
        if (nivelActual != null) {
            nivelActual.eliminarObstaculosCercanos(this, rango);
        }

        // Activar animación Z
        animacionActiva = animacionZ;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " usa TAJADA PESADA");
    }

    @Override
    protected void habilidadX() {
        if (getStamina() < 15) return;
        consumirStamina(15);

        sonidos.reproducirCortes();

        if (nivelActual != null) {
            nivelActual.eliminarObstaculosEnRangoCaballero(this);
        }

        // Activar animación X
        animacionActiva = animacionX;
        frameActual = 0;
        tiempoAnim = 0f;
        volverASpriteNormal = true;

        println(getNombre() + " usa GOLPE TERREMOTO");
    }

    @Override
    public void presionarSpace() {
        super.presionarSpace();
        spriteActual = spriteEspecial;
        tiempoSpriteEspecial = 1.0f;
    }

    public void actualizar(float dt) {
        actualizarFisica(dt);

        if (animacionActiva != null && !animacionActiva.isEmpty()) {
            tiempoAnim += dt;
            if (tiempoAnim >= velocidadAnim) {
                tiempoAnim = 0f;
                frameActual++;
                if (frameActual >= animacionActiva.size()) {
                    animacionActiva = null;
                    frameActual = 0;
                    if (volverASpriteNormal) {
                        spriteActual = spriteNormal;
                        volverASpriteNormal = false;
                    }
                }
            }
        }
    }

  
    @Override
public void dibujar() {
    if (animacionActiva != null && !animacionActiva.isEmpty()) {
        image(animacionActiva.get(frameActual), pos.x, pos.y - alto, ancho, alto);
    } else {
        image(spriteActual, pos.x, pos.y - alto, ancho, alto);
    }

    // 🔴 Debug: dibujar hitbox encima del sprite
    //dibujarHitbox();
}
}
