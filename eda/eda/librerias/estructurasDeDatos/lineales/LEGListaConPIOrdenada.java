package librerias.estructurasDeDatos.lineales;
import  librerias.estructurasDeDatos.modelos.ListaConPI;

/**
 * Write a description of class LEGListaConPIOrdenada here.
 *
 * @author Luis Lopez
 * @version 12/02/2019
 */
public class LEGListaConPIOrdenada<E extends Comparable<E>>
extends LEGListaConPI<E> 
implements ListaConPI<E> {

    /**
     * Inserta ordenadamente en la lista con PI
     *
     * @param   e objecte a inserir
     * @return  void, no retorna res   
     */
    public void insertar(E e) {
        inicio();
        while(!esFin() && e.compareTo(recuperar()) < 0) {
            siguiente();            
        }
        super.insertar(e);
    }
}
