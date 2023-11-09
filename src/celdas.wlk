import wollok.game.*
import movimiento.*
import configuracion.*

class Celda{
	var property miraIzquierda = false
    const esAterrizable = false
    var property image = "assets/celdas/piso.png"
    var property x = 0
    var property y = 0
    var property position = game.at(x, y)
	var property posicionAnteriorY = 0
	var property posicionAnteriorX = 0	
	var property esUnProyectil = false
	var property esJugador = false
	method esAterrizable() = esAterrizable
	
	method interactuar(objeto){}
	
	method animacionBonus(){
			const bonus = new Celda(
	 		x = self.x(),
	 		y = self.y(),
	 		image = "assets/bonus/bonus.png")
	 		game.addVisual(bonus)
	 		game.schedule(500,{game.removeVisual(bonus)})
	}
}

class Obstaculo inherits Celda{
	override method interactuar(personaje){
		if(personaje.posicionAnteriorX() > self.x()){
     			derecha.moverse(personaje, 1)
     		}
     		else if(personaje.posicionAnteriorX() < self.x()){
     			izquierda.moverse(personaje, 1)
     			}
     		else if(personaje.posicionAnteriorX() == self.x()){
     			abajo.moverse(personaje, 1)
     		} 
	}
}

class Billete inherits Celda{
	override method image() = "assets/bonus/diezPesos.png"
	
	override method interactuar(personaje) {
		if(personaje.esJugador()){
			game.removeVisual(self)
			self.animacionBonus()
	 		personaje.puedePasarNivel1(true)
 		}
 	}
}

class DiezPesos inherits Celda{
	override method image() = "assets/npc/diezPesosNPC.png"
	
	override method interactuar(personaje) {
		if(personaje.esJugador() and personaje.puedePasarNivel1()){
			game.clear()
			const pantallaFinal = new Celda(image = "assets/fondos/final.png")
			game.addVisual(pantallaFinal)
 		}
 	}
 	method hablar(){
 		game.say(self, "Die' Peso'")

 	}
}

class Bonus inherits Celda{
	override method image() = "assets/bonus/municion.png"
	method darBonus(personaje)
	method generarBonusAleatorio()
	
	override method interactuar(personaje){
		if(personaje.esJugador()){
			self.darBonus(personaje)	
		}
	}
	
	method estaEnSpawn(posx, posy) {
 		// Obtiene todos los visuals del juego
 		const totalCeldas = game.allVisuals()
 		// Los filtra
 		const celdasSpawn = totalCeldas.filter({celda => (celda.x() == posx and (celda.y() == posy))})
 		// Se fija si la lista no es vacia
 		if(celdasSpawn.size() == 1){
 			// Obtiene ese elemento 
 			const celda = celdasSpawn.head()
 			// Si la celda es aterrizable, puede generar un bonus encima
 			if(celda.esAterrizable()) return true
 		}
 		return false
 	}
}

class BonusBala inherits Bonus{
	override method darBonus(personaje) {
		game.removeVisual(self)
		self.animacionBonus()
 		personaje.agarrarArma()
 		personaje.llenarCargador()
 		game.schedule(3000, {self.generarBonusAleatorio()})	
	}
	
	override method generarBonusAleatorio(){
		var	x = (0..game.width()-1).anyOne()
		var	y = (0..game.height()-1).anyOne()
		if(self.estaEnSpawn(x, y)){
			game.addVisual(new BonusBala(
			x = x,
			y = y+1))
		}else{
			self.generarBonusAleatorio()
		}
	}
}

class BonusBotiquin inherits Bonus{
	const curarVida = 1
	override method image() = "assets/bonus/botiquin.png"
	
	override method darBonus(personaje){
		game.removeVisual(self)
		self.animacionBonus()
		personaje.curar(curarVida)
		game.schedule(3000, {self.generarBonusAleatorio()})	
	}
	
	override method generarBonusAleatorio(){
		var	x = (0..game.width()-1).anyOne()
		var	y = (0..game.height()-1).anyOne()
		if(self.estaEnSpawn(x, y)){
			game.addVisual(new BonusBotiquin(
			x = x,
			y = y+1))
		}else{
			self.generarBonusAleatorio()
		}
	}	
}