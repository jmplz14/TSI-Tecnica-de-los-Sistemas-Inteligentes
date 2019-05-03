package practica_busqueda;

import tools.Vector2d;
import tools.pathfinder.Node;

import javax.print.attribute.standard.NumberOfDocuments;
import java.util.ArrayList;

public class NodoEstrella{
    private int g,h,f,x,y;
    public ArrayList<Node> camino;

    public NodoEstrella(int x_nueva, int y_nueva){
        g = 0;
        h = 0;
        f = 0;
        x = x_nueva;
        y = y_nueva;
        camino = new ArrayList<Node>();

    }


    public int getG() {
        return g;
    }

    public void setG(int g) {
        this.g = g;
    }

    public int getH() {
        return h;
    }

    public void setH(int h) {
        this.h = h;
    }

    public int getF() {
        return f;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public void setF(int f) {
        this.f = f;
    }
    public void crearNuevo(){

    }



    public void cambiarValores(int g_nueva, int h_nueva){
        g = g_nueva;
        h = h_nueva;
        f = h + g;
    }
}
