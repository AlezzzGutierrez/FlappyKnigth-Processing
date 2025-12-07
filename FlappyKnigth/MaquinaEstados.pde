/* 
============================================================
=================== ESTADOS DEL JUEGO ======================
============================================================

  Esta enumeración define todos los "estados" o "pantallas"
  en las que puede encontrarse el juego.

  Cada valor representa una escena distinta:

    • MENU            → Pantalla principal
    • AJUSTES         → Opciones configurables del jugador
    • PERSONALIZACION → Edición de personaje u opciones visuales
    • MENUNIVELES     → Selección de niveles
    • NIVEL1/2/3      → Escenas jugables
    • VICTORIA        → Pantalla al ganar
    • DERROTA         → Pantalla al perder
    • NOVELAINICIO    → Cinemática o introducción
    • PAUSA           → Menú temporal de pausa
    • NOVELAFINAL     → Cinemática de cierre

------------------------------------------------------------
NOTAS IMPORTANTES:
------------------------------------------------------------

• Este archivo NO trabaja con Pvectors.
  No los necesita, ya que solo define estados estáticos.

• No requiere constructor, encapsulación adicional ni 
  instanciación de variables porque un enum en Java/Processing
  es una estructura completamente estática y auto-contenida.

• Es una clase **dependiente**, porque otras clases (gestor
  de escenas, main, escenas, etc.) la usan para definir el
  flujo del juego.

• Es totalmente editable:
  Puedes agregar o quitar estados sin afectar la arquitectura
  siempre que el gestor de escenas reconozca esos nuevos estados.

============================================================
*/

enum EstadoJuego {

    /* ============================================================
       ===================== ESTADOS PRINCIPALES ==================
       ============================================================ */

    MENU,             /* Pantalla principal del juego            */
    AJUSTES,          /* Configuración de audio, video, etc      */
    PERSONALIZACION,  /* Cambios cosméticos del personaje        */
    MENUNIVELES,      /* Selección de niveles jugables           */

    /* ============================================================
       ========================= NIVELES ==========================
       ============================================================ */

    NIVEL1,           /* Primer nivel                            */
    NIVEL2,           /* Segundo nivel                           */
    NIVEL3,           /* Tercer nivel                            */

    /* ============================================================
       ====================== RESULTADOS ==========================
       ============================================================ */

    VICTORIA,         /* Pantalla al completar un nivel           */
    DERROTA,          /* Pantalla al fallar un nivel              */

    /* ============================================================
       ======================== NOVELAS ===========================
       ============================================================ */

    NOVELAINICIO,     /* Cinemática o historia inicial             */
    PAUSA,            /* Estado de pausa temporal                  */
    NOVELAFINAL,       /* Cinemática final                          */
    TUTORIAL

}
