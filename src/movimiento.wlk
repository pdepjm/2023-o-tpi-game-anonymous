import wollok.game.*
import personaje.*
import celdas.*
//movimiento del personaje

object arriba{
	method moverse(objeto, cantidad){
        objeto.position(objeto.position().up(cantidad))
        objeto.posicionAnteriorY(objeto.y())
        objeto.posicionAnteriorX(objeto.x())
        var y = objeto.y()
        y += cantidad
        objeto.y(y)
    }
}

object abajo{
	method moverse(objeto, cantidad){
        objeto.position(objeto.position().down(cantidad))
        objeto.posicionAnteriorY(objeto.y()) 
        objeto.posicionAnteriorX(objeto.x())
        var y = objeto.y()
        y -= cantidad
        objeto.y(y)
    }
}

object izquierda{
	 method moverse(objeto, cantidad){
        objeto.position(objeto.position().left(cantidad))
        objeto.posicionAnteriorX(objeto.x())
		objeto.posicionAnteriorY(objeto.y()) 
        var x = objeto.x()
        x -= cantidad
        objeto.x(x)
        objeto.miraIzquierda(true)        
    }
}

object derecha{
	method moverse(objeto, cantidad){
        objeto.position(objeto.position().right(cantidad))
        objeto.posicionAnteriorX(objeto.x())
        objeto.posicionAnteriorY(objeto.y()) 
    	var x = objeto.x()
        x += cantidad
        objeto.x(x)
        objeto.miraIzquierda(false)
    }
}

//------------------- CAMBIAR A OTRO DOCUMENTO

object sistemaDisparo{
    method disparar(personaje)
        {
            if(personaje.esJugador()){
                if(personaje.balas() > 0 && personaje.puedeDisparar()){
                    if(!personaje.miraIzquierda()) proyectil.crearProyectil(derecha,personaje, personaje.tipoProyectil())
                    else proyectil.crearProyectil(izquierda,personaje, personaje.tipoProyectil())
            }
            //Esto te disminuye una bala
            var balas = personaje.balas()
            balas -= 1
            personaje.balas(balas)
            }
            else{
                if(personaje.puedeDisparar()){
                    if(!personaje.miraIzquierda()) proyectil.crearProyectil(derecha, personaje, personaje.tipoProyectil())
                    else proyectil.crearProyectil(izquierda, personaje, personaje.tipoProyectil())
                }
            }
        }
}



object proyectil inherits Celda{
    method crearProyectil(direccion, personaje, tipo){
        var aux
        if(!personaje.miraIzquierda()){aux = personaje.x()+1}
        else {aux = personaje.x()-1}
        const proyectil = new Celda(
                x = aux,
                y = personaje.y(),
                esUnProyectil = true,
                image = "assets/armas/"+tipo+direccion+".png")
                game.addVisual(proyectil)
                //timer para que no spameen el disparo
                personaje.puedeDisparar(false)
                game.onTick(100, "moverProyectil", {
                    direccion.moverse(proyectil, 1)})
                if (personaje.esJugador()){
                game.schedule(700, {
                    game.removeVisual(proyectil)
                    game.removeTickEvent("moverProyectil")
                    personaje.puedeDisparar(true)
                })                	
                }
                else {game.schedule(300, {
                    game.removeVisual(proyectil)
                    game.removeTickEvent("moverProyectil")
                    personaje.puedeDisparar(true)
                })}
                game.onCollideDo(proyectil, {obj => obj.interactuar(proyectil)})
    }
}
