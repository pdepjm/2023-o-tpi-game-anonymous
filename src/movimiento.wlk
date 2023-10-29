import wollok.game.*
import personaje.*
//movimiento del personaje

object movimiento{
	method moverseHaciaArriba(objeto, cantidad){
        objeto.position(objeto.position().up(cantidad))
        objeto.posicionAnteriorY(objeto.y())
        var y = objeto.y()
        y += cantidad
        objeto.y(y)
    }
    method moverseHaciaAbajo(objeto, cantidad){
        objeto.position(objeto.position().down(cantidad))
        objeto.posicionAnteriorY(objeto.y()) 
        var y = objeto.y()
        y -= cantidad
        objeto.y(y)
    }
    method moverseHaciaIzquierda(objeto, cantidad){
        objeto.position(objeto.position().left(cantidad))
        objeto.posicionAnteriorX(objeto.x())
       	var x = objeto.x()
        x -= cantidad
        objeto.x(x)
        objeto.miraIzquierda(true)
    }
    method moverseHaciaDerecha(objeto, cantidad){
        objeto.position(objeto.position().right(cantidad))
        objeto.posicionAnteriorX(objeto.x())
    	var x = objeto.x()
        x += cantidad
        objeto.x(x)
        objeto.miraIzquierda(false)
    }
}
