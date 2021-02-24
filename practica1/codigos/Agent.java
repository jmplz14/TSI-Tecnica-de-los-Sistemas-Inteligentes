package practica_busqueda;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tools.pathfinder.Node;
import tools.pathfinder.PathFinder;
import tracks.multiPlayer.tools.heuristics.SimpleStateHeuristic;
import tracks.singlePlayer.Test;

import javax.annotation.processing.SupportedSourceVersion;
import javax.print.attribute.standard.NumberOfDocuments;
import javax.swing.plaf.nimbus.State;
import java.awt.desktop.SystemSleepEvent;
import java.lang.reflect.Array;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Random;

/*class posicionMapa{
    int x,y;
    public posicionMapa(PosicionMapa){

    }
}*/
public class Agent extends BaseAgent{
    private PathFinder pf;
    private boolean analizarSectores;
    private Vector2d fescala;
    private Vector2d ultimaPos;
    private boolean solucionado;
    private int contador;
    private boolean esperarPiedras;
    private int gemasCogidas;
    private ArrayList<tools.pathfinder.Node> path;
    private int sinMovimiento;
    private boolean gemasConseguidas;
    public Agent(StateObservation so, ElapsedCpuTimer elapsedTimer){
        super(so, elapsedTimer);
        ArrayList<Integer> tiposObs = new ArrayList();
        solucionado = false;
        tiposObs.add(0);
        tiposObs.add(7);
        analizarSectores = false;
        path = new ArrayList<tools.pathfinder.Node>();
        pf = new PathFinder(tiposObs);
        pf.VERBOSE = false;
        contador = 0;
        gemasCogidas = 0;
        sinMovimiento = 0;
        pf.run(so);
        esperarPiedras = false;
        gemasConseguidas = false;
        fescala = new Vector2d(so.getWorldDimension().width / so.getObservationGrid().length, so.getWorldDimension().height / so.getObservationGrid()[0].length);
        ultimaPos = new Vector2d(so.getAvatarPosition().x / fescala.x, so.getAvatarPosition().y / fescala.y);
    }

    private   int numeroGemasCogidas(StateObservation stateObs){
        int nGemas = 0;
        if(stateObs.getAvatarResources().isEmpty() != true){
            nGemas = stateObs.getAvatarResources().get(6);
        }
        return nGemas;
    }

    private void eliminarPosicionUtilizada(StateObservation stateObs){
        Vector2d avatar = new Vector2d(stateObs.getAvatarPosition().x/fescala.x, stateObs.getAvatarPosition().y/fescala.y);
        if(((avatar.x != ultimaPos.x) || (avatar.y != ultimaPos.y)) && !path.isEmpty()){
            path.remove(0);
        }
    }

    private Vector2d transformarPuntoEscala(Vector2d posicion){
       Vector2d escalado = new Vector2d();
       escalado.x = posicion.x /fescala.x;
       escalado.y = posicion.y /fescala.y;

       return  escalado;
    }

    private void obtenerCaminioPortal(StateObservation stateObs, Vector2d avatar,  ArrayList<practica_busqueda.Observation>[][] mapa, practica_busqueda.Observation portal){
        /*Vector2d portal;
        ArrayList<core.game.Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());*/

        estrella(stateObs, (int) avatar.x, (int) avatar.y, portal.getX(), portal.getY(), mapa);
        //path = pf.getPath(avatar,portal);
    }

    private int heuristicaGema(StateObservation stateObs, practica_busqueda.Observation gema){
        int puntuacion = 0;
        Vector2d pos_inicial = new Vector2d();
        pos_inicial.y = gema.getY() - 1;
        pos_inicial.x = gema.getX() - 1;

        ArrayList<practica_busqueda.Observation> piedras = getBouldersList(stateObs);
        for(int i = 0; i < 3; i++){
            for(int j = 0; j < 3; j ++){
                for (int z = 0; z < piedras.size(); z++) {
                    if(pos_inicial.x + i == piedras.get(z).getX() && pos_inicial.y + j == piedras.get(z).getY() ){
                        puntuacion += 1;
                    }
                }
            }
        }



        return puntuacion;
    }

    private boolean obteneCaminoGema(StateObservation stateObs, Vector2d avatar,ArrayList<practica_busqueda.Observation>[][] mapa,ArrayList<practica_busqueda.Observation> gemas){
        Vector2d gema;
        float puntuacion;
        PlayerObservation jugador = getPlayer(stateObs);
        ArrayList<core.game.Observation>[] posiciones = stateObs.getResourcesPositions(stateObs.getAvatarPosition());


        boolean hay_camino = false;
        do{
            int i = 0;
            int mejor_posicion = 0;
            practica_busqueda.Observation mejor_gema = null;
            float mejor_puntuacion = 20000;

            for (practica_busqueda.Observation gema_actual : gemas) {
                puntuacion = jugador.getEuclideanDistance(gema_actual);
                if (puntuacion < mejor_puntuacion) {
                    mejor_gema = gema_actual;
                    mejor_puntuacion = puntuacion;
                    mejor_posicion = i;
                }
                i++;
            }
            Vector2d destino = new Vector2d();
            //destino = transformarPuntoEscala(posiciones[0].get(0).position);*/
            destino.x = mejor_gema.getX();
            destino.y = mejor_gema.getY();
            hay_camino = estrella(stateObs, jugador.getX(), jugador.getY(), mejor_gema.getX(), mejor_gema.getY(), mapa);

            if(!hay_camino){

                gemas.remove(mejor_posicion);

            }else{
                break;
            }
        }while(!hay_camino && gemas.size() != 0);
        if(!hay_camino) {
            esperarPiedras = true;
            path = null;
        }
        //path = pf.getPath(avatar,destino);
        /*for (int i = 0; i < path.size(); i++){
            System.out.print(path.get(i).position.x);
            System.out.print(":");
            System.out.println(path.get(i).position.y);
        }*/
        return hay_camino;

    }



    private Types.ACTIONS elegirSiguienteAccion(StateObservation stateObs, Vector2d avatar){
        Types.ACTIONS siguienteaccion;
        tools.pathfinder.Node siguientePos = path.get(0);
        if(siguientePos.position.x != avatar.x){
            if(siguientePos.position.x > avatar.x){
                siguienteaccion = Types.ACTIONS.ACTION_RIGHT;
            }else {
                siguienteaccion = Types.ACTIONS.ACTION_LEFT;
            }
        }else{
            if(siguientePos.position.y > avatar.y){
                siguienteaccion = Types.ACTIONS.ACTION_DOWN;
            }else {
                siguienteaccion = Types.ACTIONS.ACTION_UP;
            }
        }
        return siguienteaccion;
    }



    private int verticeConMenorF( ArrayList<NodoEstrella> lista){
        NodoEstrella actual = null;
        NodoEstrella mejor_nodo = lista.get(0);
        int pos_mejor_nodo = 0;
        for(int i = 1; i < lista.size(); i++ ){
            actual = lista.get(i);
            if(mejor_nodo.getF() > actual.getF()){
                mejor_nodo = actual;
                pos_mejor_nodo = i;
            }
        }


        return pos_mejor_nodo;
    }

    private int distanciaManhattan(NodoEstrella b1, int x_final, int y_final){
        return (Math.abs(b1.getX() - x_final) + Math.abs(b1.getY() - y_final));
    }


    private ArrayList<NodoEstrella> getAdyacentes(StateObservation stateObs, NodoEstrella actual, int x_final, int y_final, ArrayList<practica_busqueda.Observation>[][] mapa){


        NodoEstrella arriba, derecha, izquierda, abajo;
        ArrayList<NodoEstrella> adyacentes = new ArrayList<NodoEstrella>();
        int max_x = (int) (stateObs.getWorldDimension().width/fescala.x);
        int max_y = (int) (stateObs.getWorldDimension().height/fescala.y);

        Vector2d anterior = new Vector2d(actual.getX(), actual.getY());
        tools.pathfinder.Node nodo_anterior = new tools.pathfinder.Node(anterior);



        //arriba
        if((actual.getY() - 1) >= 0){
            arriba = new NodoEstrella(actual.getX(),actual.getY() - 1);
            arriba.camino = new ArrayList<Node>(actual.camino);
            arriba.camino.add(nodo_anterior);
            arriba.cambiarValores(actual.getG()+1, distanciaManhattan(arriba,x_final,y_final));
            adyacentes.add(0,arriba);

        }

        if((actual.getY() + 1) < max_y ){
            abajo = new NodoEstrella(actual.getX(),actual.getY() + 1);
            abajo.camino = new ArrayList<Node>(actual.camino);
            abajo.camino.add(nodo_anterior);
            abajo.cambiarValores(actual.getG()+1, distanciaManhattan(abajo,x_final,y_final));
            adyacentes.add(0,abajo);

        }

        if((actual.getX() + 1) < max_x){
            derecha = new NodoEstrella(actual.getX() + 1,actual.getY());
            derecha.camino = new ArrayList<Node>(actual.camino);
            derecha.camino.add(nodo_anterior);
            derecha.cambiarValores(actual.getG()+1, distanciaManhattan(derecha,x_final,y_final));
            adyacentes.add(0,derecha);

        }

        if((actual.getX() - 1) >= 0){
            izquierda = new NodoEstrella(actual.getX() - 1,actual.getY());
            izquierda.camino = new ArrayList<Node>(actual.camino);
            izquierda.camino.add(nodo_anterior);
            izquierda.cambiarValores(actual.getG()+1, distanciaManhattan(izquierda,x_final,y_final));
            adyacentes.add(0,izquierda);

        }


        return adyacentes;

    }

    private int comprobarLista(ArrayList<NodoEstrella> lista, NodoEstrella nodo){
        int encontrado = -1;
        int i = 0;
        for(NodoEstrella nodo_actual : lista){
            if(nodo.getX() == nodo_actual.getX() && nodo.getY() == nodo_actual.getY()){
                encontrado = i;
                break;
            }
            i++;
        }
        return encontrado;
    }

    private boolean estrella(StateObservation stateObs,int x_inicio, int y_inicio, int x_final, int y_final,ArrayList<practica_busqueda.Observation>[][] mapa){
        int num_pasadas = 0;

        //nos quedamos con el mapa y el jugador



        //inicamos el nodo actual a null
        NodoEstrella actual = null;

        //creamos el nodo inicio y le damos los valores a g, h y f
        NodoEstrella inicio = new NodoEstrella(x_inicio,y_inicio);

        inicio.cambiarValores(0,distanciaManhattan(inicio, x_final, y_final));






        //creamos la lista de abiertos y introducimos el nodo inicial.
        ArrayList<NodoEstrella> listaAbierta = new ArrayList<NodoEstrella>(),listaCerrada = new ArrayList<NodoEstrella>();
        listaAbierta.add(inicio);


        do{
            //System.out.println(num_pasadas);
            num_pasadas++;
            int pos_mejor = verticeConMenorF(listaAbierta);;
            //Se coge el que menos f tiene y lo metemos en cerrado
            actual = listaAbierta.get(pos_mejor);
            listaAbierta.remove(pos_mejor);
            listaCerrada.add(actual);

            //si es el destiono hemos llegado.
            if(actual.getX() == x_final && actual.getY() == y_final){


                path = actual.camino;
                Vector2d ultimo = new Vector2d(actual.getX(), actual.getY());
                tools.pathfinder.Node nodo_anterior = new tools.pathfinder.Node(ultimo);
                path.add(nodo_anterior);
                path.remove(0);
                /*System.out.println("Camino");
                for (int i = 0; i < actual.camino.size(); i++){
                    System.out.print(actual.camino.get(i).position.x);
                    System.out.print(":");
                    System.out.println(actual.camino.get(i).position.y);
                }
                System.out.println();*/

                return true;
            }else{
                ArrayList<NodoEstrella> adyacentes = getAdyacentes(stateObs, actual, x_final, y_final, mapa);
                //System.out.println(adyacentes.size());
                for(NodoEstrella nuevo_adyacente : adyacentes){

                    ArrayList<practica_busqueda.Observation> tipo = mapa[nuevo_adyacente.getX()][nuevo_adyacente.getY()];
                    boolean valido = true;

                    for(practica_busqueda.Observation nuevo_tipo : tipo){

                        if(nuevo_tipo.getType() == ObservationType.WALL || nuevo_tipo.getType() == ObservationType.BOULDER){
                            valido = false;
                            break;
                        }
                    }

                    if(valido){

                        int esta_abierto = comprobarLista(listaAbierta,nuevo_adyacente);
                        int esta_cerrado = comprobarLista(listaCerrada,nuevo_adyacente);
                        if(esta_abierto == -1  && esta_cerrado == -1){
                            //System.out.println("añadido a abierto");
                            listaAbierta.add(nuevo_adyacente);
                            ;


                        }else {
                            if(esta_abierto != -1){
                                NodoEstrella nodo_abierto = listaAbierta.get(esta_abierto);
                                if(nuevo_adyacente.getG() < nodo_abierto.getG()){
                                    nodo_abierto.camino = nuevo_adyacente.camino;
                                    nodo_abierto.setG(nuevo_adyacente.getG());
                                    nodo_abierto.setF(nodo_abierto.getG() + nodo_abierto.getH());
                                }
                            }
                        }
                    }

                }

            }

            //

        }while (listaAbierta.size() != 0);
        path = new ArrayList<tools.pathfinder.Node>();
        return false;
    }

    private boolean caminoCortado(StateObservation stateObs, Vector2d avatar){
        boolean cortado = false;
        ArrayList<practica_busqueda.Observation> piedras = getBouldersList(stateObs);
        Vector2d superior = new Vector2d();
        superior.x = avatar.x - 1;
        superior.y = avatar.y;
        for (int i = 0; i < piedras.size() && !cortado; i++) {
            if(superior.x == piedras.get(i).getX() && superior.y == piedras.get(i).getY() ){
                cortado = true;

            }
        }
        return cortado;
    }

    private boolean  peligroPiedra(StateObservation stateObs, Vector2d avatar){
        //tenemos elegida la pasocion que vamos a tomar mirar si se tiene que evitar piedra
        Vector2d superior = new Vector2d();
        superior.x = avatar.x;
        superior.y = avatar.y-2;
        ArrayList<practica_busqueda.Observation> piedras = getBouldersList(stateObs);
        boolean parada = false;
        for (int i = 0; i < piedras.size() && !parada; i++) {
            if(superior.x == piedras.get(i).getX() && superior.y == piedras.get(i).getY() ){
                parada = true;

            }
        }

        Types.ACTIONS siguiente = elegirSiguienteAccion(stateObs, avatar);

        if(parada){
            if(siguiente != Types.ACTIONS.ACTION_UP) {
                parada = false;
            }
        }

        return parada;
    }

    private boolean piedraDelante(StateObservation stateObs, Vector2d avatar){

        /*Vector2d superior = new Vector2d();
        superior.x = avatar.x;
        superior.y = avatar.y-2;*/
        ArrayList<practica_busqueda.Observation> piedras = getBouldersList(stateObs);
        boolean parada = false;
        if(path.get(1).position.x > avatar.x) {

            for (int i = 0; i < piedras.size() && !parada; i++) {
                if (avatar.x + 1 == piedras.get(i).getX() && avatar.y == piedras.get(i).getY()) {

                    parada = true;
                    break;

                }
            }
        }else {

            if (path.get(1).position.x < avatar.x) {
                for (int i = 0; i < piedras.size() && !parada; i++) {
                    if (avatar.x - 1 == piedras.get(i).getX() && avatar.y == piedras.get(i).getY()) {
                        parada = true;
                        break;

                    }
                }
            }
        }
        //Types.ACTIONS siguiente = elegirSiguienteAccion(stateObs, avatar);

        /*if(parada){
            if(siguiente != Types.ACTIONS.ACTION_USE) {
                parada = false;
            }
        }*/

        return parada;
    }

    public boolean peligroBicho(StateObservation stateObs, Vector2d avatar,int distancia){
        boolean peligroBicho = false;
        ArrayList<practica_busqueda.Observation> escorpienos = getScorpionsList(stateObs);
        ArrayList<practica_busqueda.Observation> murcielagos = getBatsList(stateObs);
        for(int i = 0; i < escorpienos.size() && !peligroBicho; i++){
            if(path.get(distancia).position.x == escorpienos.get(i).getX() && path.get(distancia).position.y == escorpienos.get(i).getY()){


                peligroBicho = true;
            }
        }

        for(int i = 0; i < murcielagos.size() && !peligroBicho; i++){
            if(path.get(distancia).position.x == murcielagos.get(i).getX() && path.get(distancia).position.y == murcielagos.get(i).getY()){
                peligroBicho = true;
            }
        }


        return peligroBicho;
    }

    @Override

    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
        Vector2d avatar = new Vector2d(stateObs.getAvatarPosition().x/fescala.x, stateObs.getAvatarPosition().y/fescala.y);

        if(!esperarPiedras) {
            eliminarPosicionUtilizada(stateObs);


            int nGemas = numeroGemasCogidas(stateObs);
            if (nGemas != gemasCogidas) {

                gemasCogidas = nGemas;
                path = new ArrayList<tools.pathfinder.Node>();
            }

            if (path.isEmpty()) {
                if (nGemas >= 9) {
                    gemasConseguidas = true;
                    ArrayList<practica_busqueda.Observation>[][] mapa = getObservationGrid(stateObs);
                    practica_busqueda.Observation portal = getExit(stateObs);
                    obtenerCaminioPortal(stateObs, avatar, mapa, portal);
                } else {

                    ArrayList<practica_busqueda.Observation>[][] mapa = getObservationGrid(stateObs);

                    ArrayList<practica_busqueda.Observation> gemas = new ArrayList<>(getGemsList(stateObs));
                    obteneCaminoGema(stateObs, avatar, mapa, gemas);
                }
            }

        }else{
            ArrayList<practica_busqueda.Observation>[][] mapa = getObservationGrid(stateObs);
            ArrayList<practica_busqueda.Observation> gemas = new ArrayList<>(getGemsList(stateObs));
            boolean hay_camino = obteneCaminoGema(stateObs, avatar, mapa, gemas );
            if(hay_camino){
                esperarPiedras = false;
            }


        }

        if(path != null){
            Types.ACTIONS siguienteaccion =Types.ACTIONS.ACTION_NIL;
            //if(!esperarPiedras) {
            siguienteaccion = elegirSiguienteAccion(stateObs, avatar);
            //}


            if(peligroPiedra(stateObs, avatar)){
                PlayerObservation jugador = getPlayer(stateObs);
                if(path.size() > 2) {
                    path = new ArrayList<tools.pathfinder.Node>();
                    ArrayList<practica_busqueda.Observation>[][] mapa = getObservationGrid(stateObs);
                    ArrayList<practica_busqueda.Observation> lista = new ArrayList<practica_busqueda.Observation>();
                    practica_busqueda.Observation muro = new practica_busqueda.Observation((int) avatar.x, (int) avatar.y - 1, ObservationType.WALL);
                    lista.add(muro);
                    mapa[(int) avatar.x][(int) avatar.y - 1] = lista;
                    ArrayList<practica_busqueda.Observation> gemas = new ArrayList<practica_busqueda.Observation>(getGemsList(stateObs));
                    boolean hay_camino = obteneCaminoGema(stateObs, avatar, mapa,gemas);

                    if(!hay_camino){
                        //System.out.println("Dentro de hay camino");
                        boolean colocar = estrella(stateObs,(int) avatar.x, (int)  avatar.y, (int) avatar.x-1, (int) avatar.y - 1,mapa) ;
                        if(colocar){
                            //System.out.println("Dentro izquierda");
                            esperarPiedras = false;
                            /*for (int i = 0; i < path.size(); i++){
                                System.out.print(path.get(i).position.x);
                                System.out.print(":");
                                System.out.println(path.get(i).position.y);
                            }*/

                            siguienteaccion = elegirSiguienteAccion(stateObs, avatar);

                        }else {
                            siguienteaccion = Types.ACTIONS.ACTION_NIL;
                        }

                    }else{
                        if(!esperarPiedras) {
                            siguienteaccion = elegirSiguienteAccion(stateObs, avatar);
                        }else{
                            siguienteaccion = Types.ACTIONS.ACTION_NIL;
                        }
                    }

                }




            }else if(path.size() >= 2 && piedraDelante(stateObs,avatar)){
                if(!gemasConseguidas) {
                    ArrayList<practica_busqueda.Observation>[][] mapa = getObservationGrid(stateObs);
                    ArrayList<practica_busqueda.Observation> gemas = new ArrayList<practica_busqueda.Observation>(getGemsList(stateObs));
                    obteneCaminoGema(stateObs, avatar, mapa, gemas);
                }else{
                    gemasConseguidas = true;
                    ArrayList<practica_busqueda.Observation>[][] mapa = getObservationGrid(stateObs);
                    practica_busqueda.Observation portal = getExit(stateObs);
                    obtenerCaminioPortal(stateObs, avatar, mapa, portal);
                }
            }else if(path.size() >= 1 && peligroBicho(stateObs,avatar,0)){
                ArrayList<practica_busqueda.Observation>[][] mapa = getObservationGrid(stateObs);
                ArrayList<practica_busqueda.Observation> lista = new ArrayList<practica_busqueda.Observation>();
                practica_busqueda.Observation muro = new practica_busqueda.Observation((int)path.get(0).position.x, (int) path.get(0).position.y, ObservationType.WALL);
                lista.add(muro);
                mapa[(int) avatar.x][(int) avatar.y - 1] = lista;

                if(!gemasConseguidas) {

                    ArrayList<practica_busqueda.Observation> gemas = new ArrayList<practica_busqueda.Observation>(getGemsList(stateObs));
                    obteneCaminoGema(stateObs, avatar, mapa, gemas);
                }else{
                    gemasConseguidas = true;

                    practica_busqueda.Observation portal = getExit(stateObs);
                    obtenerCaminioPortal(stateObs, avatar, mapa, portal);
                }
            }else if(path.size() >= 2 && peligroBicho(stateObs,avatar,1)){
                ArrayList<practica_busqueda.Observation>[][] mapa = getObservationGrid(stateObs);
                ArrayList<practica_busqueda.Observation> lista = new ArrayList<practica_busqueda.Observation>();
                practica_busqueda.Observation muro = new practica_busqueda.Observation((int)path.get(1).position.x, (int) path.get(1).position.y, ObservationType.WALL);
                lista.add(muro);
                mapa[(int) avatar.x][(int) avatar.y - 1] = lista;

                if(!gemasConseguidas) {

                    ArrayList<practica_busqueda.Observation> gemas = new ArrayList<practica_busqueda.Observation>(getGemsList(stateObs));
                    obteneCaminoGema(stateObs, avatar, mapa, gemas);
                }else{
                    gemasConseguidas = true;

                    practica_busqueda.Observation portal = getExit(stateObs);
                    obtenerCaminioPortal(stateObs, avatar, mapa, portal);
                }
            }

            ultimaPos = avatar;

            //System.out.println(elapsedTimer.elapsedMillis());
            return siguienteaccion;


        }else {

            return Types.ACTIONS.ACTION_NIL;
        }


    }



}

/*public class Agent extends BaseAgent{
    public Agent(StateObservation so, ElapsedCpuTimer elapsedTimer){
        super(so, elapsedTimer);
    }

    @Override
    public Types.ACTIONS act(StateObservation stateobs, ElapsedCpuTimer elapsedTimer){

        return Types.ACTIONS.ACTION_NIL;
    }
}*/
