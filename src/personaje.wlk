import wollok.game.*
import movimiento.*
import celdas.*

class Ente inherits Celda{
	var property vida = 3
	var property balas = 0
	var property puedeDisparar = true
	method perderVida(cantidad)
}

class Personaje inherits Ente{
    var property puedePasarNivel1 = false
    var property tipoProyectil = "bala"
    var property tieneUnArma = false
	var property estaSaltando = false
			
		const corazon1 = new Celda(
            x = 0,
            y = 9,
            image = "assets/jugador/corazon.png")
        const corazon2 = new Celda(
            x = 1,
            y = 9,
            image = "assets/jugador/corazon.png")
        const corazon3 = new Celda(
            x = 2,
            y = 9,
            image = "assets/jugador/corazon.png")	
            
 	// Metodo para saber si el personaje está en el aire
 	method estaEnElAire() {
 		// Obtiene todos los visuals del juego
 		const totalCeldas = game.allVisuals()
 		// Los filtra
 		const celdaAbajo = totalCeldas.filter({celda => (celda.x() == self.x()) and (celda.y() == self.y()-1)})
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
 	
 	override method interactuar(objeto){
 		self.perderVida(1)
 	}
 	
 	// Gravedad
 	method gravedad(){
 		if(self.estaEnElAire() && !estaSaltando) abajo.moverse(self, 1)
 	}
 	
 	// Metodo para que el objeto salte
 	method saltar(){
 		if(!self.estaEnElAire()){
 		 	arriba.moverse(self, 1)
 		 	estaSaltando = true
 		 	game.schedule(500, {self.estaSaltando(false) self.gravedad()})
 		}
 	}
	
	//Rellena o saca corazones del HUD
	method comprobarVida(){
		if(vida == 3){corazon3.image("assets/jugador/corazon.png")}
		if(vida < 3){corazon3.image("assets/jugador/corazonVacio.png")}
		if(vida == 2){corazon2.image("assets/jugador/corazon.png")}
		if(vida < 2){corazon2.image("assets/jugador/corazonVacio.png")}
		if(vida<1){corazon1.image("assets/jugador/corazonVacio.png")}
	}
	
	method gameOver(){
		game.removeVisual(self)
		const fondo = new Celda (
			image = "assets/fondos/gameover.png"
		)
		game.removeTickEvent("disparo NPC")
		game.addVisual(fondo)
	}
	
	override method perderVida(cantidad){
		vida -= cantidad
		self.comprobarVida()
		if(vida < 1) {self.gameOver()}
	}
	
	method llenarCargador(){
		balas = 7
	}
	
	method disminuirMunicion(){
		if(balas >=1) balas -= 1
	}
	
	method curar(cantidad){
		if(vida<3){
		vida += cantidad
		self.comprobarVida()
		}
	}
	
	method agarrarArma(){
		tieneUnArma = true
		self.image("assets/jugador/userakder.png")
	}
	
	method generarCorazones(){
		game.addVisual(corazon1)
		game.addVisual(corazon2)
		game.addVisual(corazon3)
	}
}   

class Npc inherits Ente{
	var property tipoProyectil = "fuego"
	const limiteIzquierdo = 0
	const limiteDerecho = 0
	var property irHaciaDerecha = false
	
	override method interactuar(objeto){
 		if(objeto.esUnProyectil()){self.perderVida(1)}
 	}
	method girar(){
		if (self.x() == limiteIzquierdo){self.irHaciaDerecha(true) self.image("assets/npc/npc1der.png")}
		if (self.x() == limiteDerecho){self.irHaciaDerecha(false) self.image("assets/npc/npc1izq.png")}
	}
	
	method movimientoNPC(){
		if (self.irHaciaDerecha()){derecha.moverse(self, 1) self.girar()}
		else {izquierda.moverse(self, 1) self.girar()}
	}
	
	override method perderVida(cantidad){
		var cantidadVida = self.vida()
		cantidadVida -= cantidad
		self.vida(cantidadVida)
		if(self.vida() < 1) {
			self.image("assets/npc/calavera.png")
			game.schedule(1000, {game.removeVisual(self)})
			game.removeTickEvent("disparo NPC")
		}
	}
}
 
	