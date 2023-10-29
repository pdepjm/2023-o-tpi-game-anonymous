import wollok.game.*
import movimiento.*
import celdas.*


// Objeto personaje
object personaje{
     //Atributos//
    var property miraIzquierda = false
    var property balas = 0
    var property x = 0
    var property y = 0
    var property position = game.at(x,y)
	var property posicionAnteriorY = 0
	var property posicionAnteriorX = 0
	var property estaSaltando = false
	
	//Imagen del personaje
    method image() = "user.png"
    
   	//Metodo para agarrar los lvl up
 	method agarrarBonus(objeto){
 		if(objeto.esUnBonus()){
 			//agregar un dar recompensa
 			objeto.darBonus(self) 
 			game.removeVisual(objeto)
 			//Crear el bonus
 			const bonus = new Celda(
 				x = objeto.x(),
 				y = objeto.y(),
 				image = "bonus.png")
 			game.addVisual(bonus)
 			game.schedule(500,{game.removeVisual(bonus)})
 		}
 	}
 	
 		// Metodo para saber si el objeto está en el aire
 	method estaEnElAire() {
 		// Obtiene todos los visuals del juego
 		const totalCeldas = game.allVisuals()
 		// Los filtra
 		const celdaAbajo = totalCeldas.filter({celda => (celda.x() == x) and (celda.y() == y-1)})
 		// Se fija si la lista no es vacia
 		if (celdaAbajo.size() == 0) return celdaAbajo.size() == 0
 		else if(celdaAbajo.size() == 1){
 			// Obtiene ese elemento 
 			const celda = celdaAbajo.head()
 			// Si la celda de abajo no es aterrizable, te va a bajar
 			if(!celda.esAterrizable()) return true
 		}
 		return false
 	}
 	
 		// Gravedad
 	method gravedad(){
 		if(self.estaEnElAire() && !estaSaltando) movimiento.moverseHaciaAbajo(self, 1)
 	}
 	
 		// Metodo para que el objeto salte
 	method saltar(){
 		if(!self.estaEnElAire()){
 		 	movimiento.moverseHaciaArriba(self, 1)
 		 	estaSaltando = true
 		 	game.schedule(500, {self.estaSaltando(false) self.gravedad()})
 		}
 	}
 	
	// Metodo para que el objeto choque contra los obstaculos 		    
   method rebotar(objeto){
     	if(objeto.esObstaculo()){
     		if(posicionAnteriorX > objeto.x()){
     			movimiento.moverseHaciaDerecha(self, 1)
     		}
     		else if(posicionAnteriorX <= objeto.x()){
     			movimiento.moverseHaciaIzquierda(self, 1)
     		}     		
     	}    
    }
   
    // Metodo para disparar
    method disparar(){
    	if(balas > 0){
    		if(!miraIzquierda){
    			const bala = new Celda(
    			x = self.x(),
    			y = self.y(),
    			image = "balader.png")
    			game.addVisual(bala)
    			game.onTick(300, "moverBala", {movimiento.moverseHaciaDerecha(bala, 1)})
    			game.schedule(5000, {game.removeVisual(bala)})
    		}else{
    			const bala = new Celda(
    			x = self.x(),
    			y = self.y(),
    			image = "bala.png")
    			game.addVisual(bala)
    			game.onTick(300, "moverBala", {movimiento.moverseHaciaIzquierda(bala, 1)})
    			game.schedule(5000, {game.removeVisual(bala)})
    		}	
    		//Esto te disminuye una bala
    		balas -= 1
    	}
    }
}
 	
 
	