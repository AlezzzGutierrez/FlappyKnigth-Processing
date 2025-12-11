/* ============================================================
   =============== CLASE ABSTRACTA: NivelBase ==================
   Clase base que define:
   - Parallax
   - Obstáculos
   - Obstáculos vivos
   - Items
   - Lógica de victoria / derrota
   - Tiempo y control de juego
   ============================================================ */
public abstract class NivelBase {

    /* ============================================================
       =================== PARALLAX Y FONDOS =======================
       ============================================================ */

    /* Capas de parallax */
    protected ArrayList<Layer> fondos = new ArrayList<>();


    /* ============================================================
       ======================== TIEMPOS ============================
       ============================================================ */

    protected float duracionNivel;
    protected float tiempoTranscurrido = 0;

    protected float tiempoEntreObstaculos;
    protected float tiempoDesdeUltimoSpawn = 0;

    protected float tiempoEntreObstaculosVivos = 3.0f;
    protected float tiempoDesdeUltimoSpawnVivo = 0;

    /* ---- Items ---- */
    protected float tiempoEntreItems = 5f;
    protected float tiempoDesdeUltimoItem = 0;


    /* ============================================================
       ========================= ESTADOS ===========================
       ============================================================ */

    protected boolean completado = false;
    protected boolean irAVictoria = false;
    protected boolean irADerrota = false;


    /* ============================================================
       ========================= ENTIDADES =========================
       ============================================================ */

    protected ArrayList<Obstaculo> obstaculos;
    protected ArrayList<Item> items = new ArrayList<>();

    protected Jugador jugador;
    protected GestorJugadorActual gestorJugador;


    /* ============================================================
       ========================== MUSICA ===========================
       ============================================================ */

    protected String archivoMusica;


    /* ============================================================
       ======================== CONSTRUCTOR ========================
       ============================================================ */
    public NivelBase(
        float duracionNivel,
        float tiempoEntreObstaculos,
        GestorJugadorActual gestorJugador,
        String archivoMusica
    ) {
        this.duracionNivel = duracionNivel;
        this.tiempoEntreObstaculos = tiempoEntreObstaculos;
        this.gestorJugador = gestorJugador;
        this.archivoMusica = archivoMusica;

        /* Jugador del sistema */
        this.jugador = gestorJugador.getJugador();
        jugador.asignarNivel(this);

        /* Crear estructuras */
        this.obstaculos = new ArrayList<>();
    }



    /* ============================================================
       ===================== PARALLAX SETUP ========================
       ============================================================ */
    public void cargarFondos(String[] archivos, float[] velocidades) {

        fondos.clear();

        for (int i = 0; i < archivos.length; i++) {
            fondos.add(new Layer(archivos[i], velocidades[i]));
        }
    }



    /* ============================================================
       ======================== CREAR ITEM =========================
       ============================================================ */
    /* Método sobreescribible por los niveles */
    protected Item crearItem() {
        return null;
    }

    /* Método sobreescribible por niveles para obstáculos vivos */
    protected Obstaculo crearObstaculoVivo() {
        return null;
    }


    /* ============================================================
       ======================== ACTUALIZAR =========================
       ============================================================ */
    public void actualizar(float dt) {

        /* -------------------- Actualizar fondos -------------------- */
        for (Layer l : fondos) l.update(dt);


        /* -------------------- Spawn de items ----------------------- */
        tiempoDesdeUltimoItem += dt;

        if (tiempoDesdeUltimoItem >= tiempoEntreItems) {

            Item nuevo = crearItem();
            if (nuevo != null) items.add(nuevo);

            tiempoDesdeUltimoItem = 0;
        }


        /* -------------------- Jugador -------------------------- */
     jugador.regenerarStamina(dt);
jugador.actualizarControles();
jugador.actualizarFisica(dt);
jugador.actualizarInmunidad(dt);

// 🔹 Ahora cualquier clase hija (Caballero, Escudero, Arquero, Mago) ejecuta su propia animación
jugador.actualizar(dt);



        /* -------------------- Tiempos -------------------------- */
        tiempoTranscurrido += dt;
        tiempoDesdeUltimoSpawn += dt;
        tiempoDesdeUltimoSpawnVivo += dt;


        /* -------------------- Obstáculos básicos ---------------- */
        if (tiempoDesdeUltimoSpawn >= tiempoEntreObstaculos) {
            obstaculos.add(crearObstaculo());
            tiempoDesdeUltimoSpawn = 0;
        }


        /* -------------------- Obstáculos vivos ------------------ */
        if (tiempoDesdeUltimoSpawnVivo >= tiempoEntreObstaculosVivos) {

            Obstaculo vivo = crearObstaculoVivo();
            if (vivo != null) obstaculos.add(vivo);

            tiempoDesdeUltimoSpawnVivo = 0;
        }


        /* ============================================================
           =============== ACTUALIZAR OBSTÁCULOS ======================
           ============================================================ */

        for (int i = obstaculos.size() - 1; i >= 0; i--) {

            Obstaculo o = obstaculos.get(i);

            /* Si es vivo usa IA */
            if (o instanceof ObstaculoVivo) {
                ((ObstaculoVivo) o).actualizar(dt, jugador);
            } else {
                o.actualizar(dt);
            }

            /* ------------ Colisión con jugador ------------ */
            if (o.colisionaConJugador(
                jugador.getHitboxX(),
                jugador.getHitboxY(),
                jugador.getHitboxW(),
                jugador.getHitboxH()
            )) {
                o.aplicarDañoSiCorresponde(jugador, tiempoTranscurrido);
            }

            /* ------------ Si salió de pantalla ------------ */
            if (o.fueraDePantalla()) {
                obstaculos.remove(i);
            }
        }


        /* ============================================================
           ======================== ÍTEMS ==============================
           ============================================================ */

        for (int i = items.size() - 1; i >= 0; i--) {

            Item it = items.get(i);
            it.actualizar(dt);

            /* Colisión */
            if (it.colisionaConJugador(
                jugador.getHitboxX(),
                jugador.getHitboxY(),
                jugador.getHitboxW(),
                jugador.getHitboxH()
            )) {
                it.aplicarEfecto(jugador);
                items.remove(i);
                continue;
            }

            if (it.fueraDePantalla()) items.remove(i);
        }


        /* ============================================================
           ================= VICTORIA / DERROTA =======================
           ============================================================ */

        if (jugador.getVida() <= 0) irADerrota = true;

        if (tiempoTranscurrido >= duracionNivel && jugador.getVida() > 0) {
            completado = true;
            irAVictoria = true;
        }
    }



    /* ============================================================
       =========================== DIBUJAR =========================
       ============================================================ */
    public void dibujar() {

        /* Fondos */
        for (Layer l : fondos) l.display();

        /* Items */
        for (Item it : items) it.dibujar();

        /* Piso y techo */
        fill(0);
        rect(0, Jugador.PISO, width, 100);
        rect(0, Jugador.TECHO, width, -100);
        if (jugador.getHitboxY() + jugador.getHitboxH() >= Jugador.PISO ||
    jugador.getHitboxY() <= Jugador.TECHO) {
    jugador.setVida(0); // muerte instantánea
    jugador.dibujar();
}


        /* Jugador */
        jugador.dibujar();
        jugador.dibujarBarras();

        /* Obstáculos */
        for (Obstaculo o : obstaculos) o.dibujar();

        /* HUD */
        fill(255);
        textSize(20);
        
        text("Tiempo: " + int(duracionNivel - tiempoTranscurrido), width - 150, 40);
    }



    /* ============================================================
       ====================== MÉTODOS DE ESTADO ====================
       ============================================================ */
    public boolean debeIrAVictoria() { return irAVictoria; }
    public boolean debeIrADerrota() { return irADerrota; }
    public boolean fueCompletado() { return completado; }



    /* ============================================================
       ============ MÉTODOS DE HABILIDADES ESPECIALES =============
       ============================================================ */

    /* ------------------------------------------------------------
       Eliminar obstáculos en un rango cuadrado usando PVector
       ------------------------------------------------------------ */
    public void eliminarObstaculosCercanos(Jugador jugador, float rango) {

        PVector centro = new PVector(jugador.getHitboxX(), jugador.getHitboxY());

        for (int i = obstaculos.size() - 1; i >= 0; i--) {

            Obstaculo o = obstaculos.get(i);
            PVector pos = new PVector(o.getX(), o.getY());

            if (PVector.dist(pos, centro) <= rango) {
                obstaculos.remove(i);
            }
        }
    }



    /* ------------------------------------------------------------
       Eliminar el obstáculo más cercano
       ------------------------------------------------------------ */
    public void eliminarObstaculoMasCercano(Jugador jugador) {

        if (obstaculos.isEmpty()) return;

        PVector centro = new PVector(jugador.getHitboxX(), jugador.getHitboxY());

        Obstaculo objetivo = null;
        float distanciaMin = Float.MAX_VALUE;

        for (Obstaculo o : obstaculos) {

            PVector pos = new PVector(o.getX(), o.getY());
            float d = PVector.dist(pos, centro);

            if (d < distanciaMin) {
                distanciaMin = d;
                objetivo = o;
            }
        }

        if (objetivo != null) obstaculos.remove(objetivo);
    }



    /* ------------------------------------------------------------
       Caballero: elimina obstáculos en un rango delantero
       ------------------------------------------------------------ */
    public void eliminarObstaculosEnRangoCaballero(Jugador jugador) {

        PVector centro = new PVector(jugador.getHitboxX(), jugador.getHitboxY());

        float rangoX = 1000;
        float rangoY = jugador.getAlto() * 2;

        for (int i = obstaculos.size() - 1; i >= 0; i--) {

            Obstaculo o = obstaculos.get(i);
            PVector pos = new PVector(o.getX(), o.getY());

            float dx = pos.x - centro.x;
            float dy = abs(pos.y - centro.y);

            if (dx >= 0 && dx <= rangoX && dy <= rangoY) {
                obstaculos.remove(i);
            }
        }
    }



    /* ------------------------------------------------------------
       Arquero: elimina 4 obstáculos más cercanos
       ------------------------------------------------------------ */
    public void eliminar4ObstaculosMasCercanos(Jugador jugador) {

        if (obstaculos.isEmpty()) return;

        PVector centro = new PVector(jugador.getHitboxX(), jugador.getHitboxY());

        ArrayList<Obstaculo> copia = new ArrayList<>(obstaculos);

        copia.sort((a, b) -> {
            float da = PVector.dist(new PVector(a.getX(), a.getY()), centro);
            float db = PVector.dist(new PVector(b.getX(), b.getY()), centro);
            return Float.compare(da, db);
        });

        int cantidad = min(4, copia.size());

        for (int i = 0; i < cantidad; i++) obstaculos.remove(copia.get(i));
    }



    /* ------------------------------------------------------------
       Mago: elimina 20 obstáculos más cercanos
       ------------------------------------------------------------ */
    public void eliminar20ObstaculosMasCercanos(Jugador jugador) {

        if (obstaculos.isEmpty()) return;

        PVector centro = new PVector(jugador.getHitboxX(), jugador.getHitboxY());

        ArrayList<Obstaculo> copia = new ArrayList<>(obstaculos);

        copia.sort((a, b) -> {
            float da = PVector.dist(new PVector(a.getX(), a.getY()), centro);
            float db = PVector.dist(new PVector(b.getX(), b.getY()), centro);
            return Float.compare(da, db);
        });

        int cantidad = min(20, copia.size());

        for (int i = 0; i < cantidad; i++) obstaculos.remove(copia.get(i));
    }



    /* ============================================================
       ====================== AGREGAR OBSTÁCULO ====================
       ============================================================ */
    public void agregarObstaculo(Obstaculo o) {
        obstaculos.add(o);
    }



    /* ============================================================
       ========================== REINICIAR =========================
       ============================================================ */
    public void reiniciar() {

        tiempoTranscurrido = 0;
        tiempoDesdeUltimoSpawn = 0;

        irAVictoria = false;
        irADerrota = false;
        completado = false;

        obstaculos.clear();

        jugador = gestorJugador.getJugador();
        jugador.setVida(100);
        jugador.setStamina(60);
        jugador.resetearPosicion();
    }


    /* ============================================================
       =========== MÉTODO ABSTRACTO: fabricar obstáculo ============
       ============================================================ */
    protected abstract Obstaculo crearObstaculo();
}
