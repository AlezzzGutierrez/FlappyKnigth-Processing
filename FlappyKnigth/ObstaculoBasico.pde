/* ---------------------------------------------------------
   Clase ObstaculoBasico
   ---------------------------------------------------------
   Esta clase HEREDA de Obstaculo
      (por lo tanto depende completamente de su estructura).

   Representa un obstáculo simple con un sprite estático.

   No utiliza PVector → Se recomienda migrar a PVector
      para mejorar claridad y evitar manejo manual de x/y.

   Clase completamente editable: puedes cambiar sprite,
      tamaño, daño, velocidad o el sistema de dibujo.
   --------------------------------------------------------- */

public class ObstaculoBasico extends Obstaculo {

    /* ---------------------------------------------------------
       BLOQUE: Atributos privados (encapsulación)
       ---------------------------------------------------------
       sprite → imagen que representa al obstáculo.
       Se inicializa en el constructor para evitar nulls.
       --------------------------------------------------------- */
    private PImage sprite;


    /* ---------------------------------------------------------
       BLOQUE: Constructor
       ---------------------------------------------------------
       x, y → posición inicial del obstáculo.
       super() → inicializa dimensiones, velocidad y daño.
       
       Todos los valores son editables.
       ---------------------------------------------------------
       NOTA: La operación matemática aquí es directa.
       No hay cálculos: solo asignaciones.
       --------------------------------------------------------- */
    public ObstaculoBasico(float x, float y) {

        // Llamada obligatoria a la clase padre
        super(
            x, y,
            40, 40,   // tamaño (ancho, alto)
            200,      // velocidad px/seg ← editable
            10        // daño aplicado ← editable
        );

        /* -----------------------------------------------------
           Cargar sprite estático del obstáculo
           Editable → cambia "rama1.png" por cualquier imagen.
           ----------------------------------------------------- */
        this.sprite = loadImage("rama1.png");
    }


    /* ---------------------------------------------------------
       BLOQUE: Dibujado en pantalla
       ---------------------------------------------------------
       Dibuja el sprite en las coordenadas x,y heredadas.

       Si sprite != null → dibuja la imagen.
       Si sprite == null → fallback: cuadrado rojo.
       ---------------------------------------------------------
       Matemática involucrada:
       - image(sprite, x, y, ancho, alto)
         → simple mapeo directo de posición y escala.

       No hay interpolación ni transformaciones complejas.
       --------------------------------------------------------- */
    @Override
    public void dibujar() {

        // Dibuja sprite si existe
        if (sprite != null) {
            image(sprite, x, y, ancho, alto);
            return;  // evita dibujar el rectángulo de emergencia
        }

        /* -----------------------------------------------------
           Fallback visual en caso de error cargando sprite
           ----------------------------------------------------- */
        fill(255, 0, 0);   // rojo
        rect(x, y, ancho, alto);
    }
}
