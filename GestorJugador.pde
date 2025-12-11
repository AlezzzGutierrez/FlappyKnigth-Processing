// ============================================================================
// GESTOR DEL JUGADOR ACTUAL – Clase Controladora
// ============================================================================

/* 
   NOTA GENERAL SOBRE LA CLASE
   ----------------------------
   • Esta clase funciona como UN "gestor" o "controller" del personaje actual.
   • NO hereda de ninguna otra clase.
   • Es una clase DEPENDIENTE de las clases hijas de Jugador:
        - Caballero
        - Arquero
        - Escudero
        - Mago
   • No utiliza PVectores (no corresponde a su propósito).
   • Es totalmente independiente de gráficos o físicas.
   • Solo administra qué instancia de Jugador está activa.
*/

class GestorJugadorActual {

  // ============================================================================
  // BLOQUE 1 — ATRIBUTOS PRIVADOS
  // ============================================================================
  /* 
     Encapsulación:
     ---------------
     • El jugador actual se mantiene privado para evitar que otras clases
       lo modifiquen directamente desde afuera.
     • Se expone solo mediante un getter seguro.
  */
  private Jugador jugadorActual;

  // ============================================================================
  // BLOQUE 2 — CONSTRUCTOR
  // ============================================================================
  public GestorJugadorActual() {
    
    /* 
       Instancia inicial:
       ------------------
       • Se elige Caballero como clase base por defecto.
       • Aquí se pueden cambiar las clases iniciales según diseño.
         (✔ EDITABLE)
    */
    jugadorActual = new Caballero("Jugador");
  }

  // ============================================================================
  // BLOQUE 3 — GETTERS / ENCAPSULACIÓN
  // ============================================================================
  public Jugador getJugador() {
    return jugadorActual; 
  }

  // ============================================================================
  // BLOQUE 4 — REROLL DE CLASE (Cambio aleatorio)
  // ============================================================================
  public void rerollearClase() {

    /* 
       OPERACIÓN MATEMÁTICA:
       ----------------------
       random(1) → genera un número "float" entre 0.0 y 1.0
       Ideal para probabilidades.
       
       Ejemplo:
       r = 0.32 → Caballero (40%)
       r = 0.55 → Arquero   (30%)
       r = 0.82 → Escudero  (20%)
       r = 0.94 → Mago      (10%)
    */
    float r = random(1);

    /* 
       Probabilidades:
       ----------------
       40% Caballero   → r < 0.40
       30% Arquero     → r < 0.70
       20% Escudero    → r < 0.90
       10% Mago        → r ≥ 0.90
       
       (EDITABLE: puedes modificar porcentajes sin romper lógica)
    */

if (r < 0.25f) {

    jugadorActual = new Caballero("Jugador");

} else if (r < 0.50f) {

    jugadorActual = new Arquero("Jugador");

} else if (r < 0.75f) {

    jugadorActual = new Escudero("Jugador");

} else {

    jugadorActual = new Mago("Jugador");
}

  }
}
