// ============================================================
// ======================= NIVEL BASE ==========================
// ============================================================
public abstract class NivelBase {

    // ---------------- PARALLAX -----------------
    protected ArrayList<Layer> fondos = new ArrayList<>();

    // ---------------- TIEMPOS -------------------
    protected float duracionNivel;
    protected float tiempoTranscurrido = 0;

    protected float tiempoEntreObstaculos;
    protected float tiempoDesdeUltimoSpawn = 0;

    // ---------------- ESTADOS -------------------
    protected boolean completado = false;
    protected boolean irAVictoria = false;
    protected boolean irADerrota = false;

    // ---------------- ENTIDADES -----------------
    protected ArrayList<Obstaculo> obstaculos;
    protected Jugador jugador;
    protected GestorJugadorActual gestorJugador;

    // ---------------- MUSICA ---------------------
    protected String archivoMusica;
    

// ----------------- ÍTEMS -------------------
protected ArrayList<Item> items = new ArrayList<>();

protected float tiempoEntreItems = 5.0f; // cada cuántos segundos aparece 1 ítem
protected float tiempoDesdeUltimoItem = 0;


    
    // Tiempo entre obstaculos vivos
protected float tiempoEntreObstaculosVivos = 3.0f;
protected float tiempoDesdeUltimoSpawnVivo = 0;




    // ============================================================
    // ----------------------- CONSTRUCTOR -------------------------
    // ============================================================
    public NivelBase(
        float duracionNivel,
        float tiempoEntreObstaculos,
        GestorJugadorActual gestorJugador,
        String archivoMusica
    ) {
        this.duracionNivel = duracionNivel;
        this.tiempoEntreObstaculos = tiempoEntreObstaculos;
        this.gestorJugador = gestorJugador;

        this.jugador = gestorJugador.getJugador();
        this.archivoMusica = archivoMusica;

        obstaculos = new ArrayList<>();
        
        jugador.asignarNivel(this);

    }



    // ============================================================
    // ----------------------- PARALLAX SETUP ----------------------
    // ============================================================
    public void cargarFondos(String[] archivos, float[] velocidades) {
        fondos.clear();

        for (int i = 0; i < archivos.length; i++) {
            fondos.add(new Layer(archivos[i], velocidades[i]));
        }
    }
    
    // ============================================================
    // ----------------------- Crear Item ----------------------
    // ============================================================
    
protected Item crearItem() {
    return null; // por defecto no crea ninguno
}





    // ============================================================
    // ------------------------- ACTUALIZAR ------------------------
    // ============================================================
    public void actualizar(float dt) {

        // ---------------- Fondos (Parallax) -----------------
        for (Layer l : fondos) {
            l.update(dt);
        }
        
        // ------- Tiempo para ítems --------
// Tiempo
tiempoDesdeUltimoItem += dt;

// Spawnear ítems
if (tiempoDesdeUltimoItem >= tiempoEntreItems) {
    items.add(crearItem());
    tiempoDesdeUltimoItem = 0;
}



        // ---------------- Jugador ----------------
        jugador.regenerarStamina(dt);

        jugador.actualizarControles();
        jugador.actualizarFisica(dt);
        
        jugador.actualizarInmunidad(dt);
        



        // ---------------- Tiempo ------------------
        tiempoTranscurrido += dt;
        tiempoDesdeUltimoSpawn += dt;
        tiempoDesdeUltimoSpawnVivo += dt;


        // ---------------- Spawnear obstáculos -----
        if (tiempoDesdeUltimoSpawn >= tiempoEntreObstaculos) {
            obstaculos.add(crearObstaculo());
            tiempoDesdeUltimoSpawn = 0;
        }
        
// ---------------- Spawnear obstáculos vivos -----
if (tiempoDesdeUltimoSpawnVivo >= tiempoEntreObstaculosVivos) {

    obstaculos.add(crearObstaculoVivo());

    tiempoDesdeUltimoSpawnVivo = 0;
}


        // ---------------- Obstáculos --------------
for (int i = obstaculos.size() - 1; i >= 0; i--) {

    Obstaculo o = obstaculos.get(i);

    if (o instanceof ObstaculoVivo) {
        ((ObstaculoVivo)o).actualizar(dt, jugador);
    } else {
        o.actualizar(dt);
    }

    // colisión con jugador
    if (o.colisionaConJugador(
        jugador.getHitboxX(),
        jugador.getHitboxY(),
        jugador.getHitboxW(),
        jugador.getHitboxH()
    )) {
        o.aplicarDañoSiCorresponde(jugador, tiempoTranscurrido);
    }

    // eliminar si se fue a la izquierda
    if (o.fueraDePantalla()) {
        obstaculos.remove(i);
    }
}

// ---------------- ÍTEMS ----------------
for (int i = items.size() - 1; i >= 0; i--) {

    Item it = items.get(i);
    it.actualizar(dt);

    // colisión con jugador
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

    // eliminar si salió de pantalla
    if (it.fueraDePantalla()) {
        items.remove(i);
    }
}



        // ---------------- Derrota ----------------
        if (jugador.getVida() <= 0) {
            irADerrota = true;
        }

        // ---------------- Victoria ----------------
        if (tiempoTranscurrido >= duracionNivel && jugador.getVida() > 0) {
            completado = true;
            irAVictoria = true;
        }
    }


protected Obstaculo crearObstaculoVivo() {
    return null; // por defecto ningún nivel usa obstáculos vivos
}



    // ============================================================
    // --------------------------- DIBUJAR -------------------------
    // ============================================================
    public void dibujar() {

        // ---------- Fondos (Parallax) --------------
        for (Layer l : fondos) {
            l.display();
        }
        
                // ---------- Dibyujar Items --------------
for (Item it : items) {
    it.dibujar();
}


        // ---------- Piso y techo -------------------
        fill(0);
        rect(0, Jugador.PISO, width, 100);
        rect(0, Jugador.TECHO, width, -100);

        // ---------- Jugador ------------------------
jugador.dibujar();

// ---------- HUD (Jugador) ------------------
jugador.dibujarBarras();



        // ---------- Obstáculos ---------------------
        for (Obstaculo o : obstaculos) {
            o.dibujar();
        }

        // ---------- HUD ----------------------------
        fill(255);
        textSize(20);
        text("Vida: " + jugador.getVida(), 80, 40);
        text("Tiempo: " + int(duracionNivel - tiempoTranscurrido), width - 150, 40);
    }



    // ============================================================
    // --------------------------- ESTADOS -------------------------
    // ============================================================
    public boolean debeIrAVictoria() { return irAVictoria; }
    public boolean debeIrADerrota() { return irADerrota; }
    public boolean fueCompletado() { return completado; }
    
    // ============================================================
// ELIMINAR OBSTÁCULOS CERCA DEL JUGADOR
// ============================================================
public void eliminarObstaculosCercanos(Jugador jugador, float rango) {

    for (int i = obstaculos.size() - 1; i >= 0; i--) {

        Obstaculo o = obstaculos.get(i);

        // distancia simple con matemática básica
        float dx = abs(o.getX() - jugador.getHitboxX());
        float dy = abs(o.getY() - jugador.getHitboxY());

        // si está dentro del rango → eliminar
        if (dx <= rango && dy <= rango) {
            obstaculos.remove(i);
        }
    }
}

// ============================================================
// ELIMINAR SOLO EL OBSTÁCULO MÁS CERCANO AL JUGADOR
// ============================================================
public void eliminarObstaculoMasCercano(Jugador jugador) {

    if (obstaculos.isEmpty()) return;

    Obstaculo objetivo = null;
    float distanciaMinima = Float.MAX_VALUE;

    for (Obstaculo o : obstaculos) {

        float dx = abs(o.getX() - jugador.getHitboxX());
        float dy = abs(o.getY() - jugador.getHitboxY());
        float distancia = dx + dy; // distancia simple

        if (distancia < distanciaMinima) {
            distanciaMinima = distancia;
            objetivo = o;
        }
    }

    // eliminar el objetivo encontrado
    if (objetivo != null) {
        obstaculos.remove(objetivo);
    }
}

// ============================================================
// ELIMINAR OBSTÁCULOS EN RANGO AMPLIO (HABILIDAD X CABALLERO)
// ============================================================
public void eliminarObstaculosEnRangoCaballero(Jugador jugador) {

    float rangoY = jugador.getAlto() * 2; // dos veces el alto del jugador
    float rangoX = 1000;                   // 1000 px hacia adelante

    float jx = jugador.getHitboxX();
    float jy = jugador.getHitboxY();

    for (int i = obstaculos.size() - 1; i >= 0; i--) {

        Obstaculo o = obstaculos.get(i);

        float dx = o.getX() - jx;     // IMPORTANTE: solo obstáculos delante
        float dy = abs(o.getY() - jy);

        // condición: delante y dentro de la ventana definida
        if (dx >= 0 && dx <= rangoX && dy <= rangoY) {
            obstaculos.remove(i);
        }
    }
}

// ============================================================
// ELIMINAR LOS 4 OBSTÁCULOS MÁS CERCANOS (HABILIDAD X ARQUERO)
// ============================================================
public void eliminar4ObstaculosMasCercanos(Jugador jugador) {

    if (obstaculos.isEmpty()) return;

    // Lista temporal con distancias
    ArrayList<Obstaculo> copia = new ArrayList<>(obstaculos);

    // Ordenar por distancia al jugador (ascendente)
    copia.sort((a, b) -> {

        float da = abs(a.getX() - jugador.getHitboxX()) + 
                   abs(a.getY() - jugador.getHitboxY());

        float db = abs(b.getX() - jugador.getHitboxX()) + 
                   abs(b.getY() - jugador.getHitboxY());

        return Float.compare(da, db);
    });

    // Eliminar hasta 4 obstáculos si existen
    int cantidad = min(4, copia.size());

    for (int i = 0; i < cantidad; i++) {
        obstaculos.remove(copia.get(i));
    }
}

// ============================================================
// ELIMINAR LOS 20 OBSTÁCULOS MÁS CERCANOS (HABILIDAD X - MAGO)
// ============================================================
public void eliminar20ObstaculosMasCercanos(Jugador jugador) {

    if (obstaculos.isEmpty()) return;

    // Crear copia para ordenar
    ArrayList<Obstaculo> copia = new ArrayList<>(obstaculos);

    // Orden por distancia al jugador
    copia.sort((a, b) -> {

        float da = abs(a.getX() - jugador.getHitboxX()) + 
                   abs(a.getY() - jugador.getHitboxY());

        float db = abs(b.getX() - jugador.getHitboxX()) + 
                   abs(b.getY() - jugador.getHitboxY());

        return Float.compare(da, db);
    });

    // Eliminar hasta 20 obstáculos
    int cantidad = min(20, copia.size());

    for (int i = 0; i < cantidad; i++) {
        obstaculos.remove(copia.get(i));
    }
}

//invocar dragon

public void agregarObstaculo(Obstaculo o) {
    obstaculos.add(o);
}



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



    // ============================================================
    // ----------- MÉTODO ABSTRACTO (fabricar obstáculo) ----------
    // ============================================================
    protected abstract Obstaculo crearObstaculo();
}
