import wollok.game.*
import personaje.*
import movimiento.*
import celdas.*


object juego{
	method iniciarTablero(){
        game.width(20)
        game.height(10)
        game.cellSize(75)
        game.title("Diez Pesos para Diez Pesos")
	}
	method ponerMusica(){
		const sonido = game.sound("assets/soundtrack.mp3")
		sonido.shouldLoop(true)
		sonido.volume(0.5)
		game.schedule(500, {sonido.play()} )
	}
	
	method introduccion(){
		self.iniciarTablero()
		self.ponerMusica()
		game.boardGround("assets/fondos/fondo1.jpg")
		const pantalla1 = new Celda(image = "assets/fondos/inicio1.png")
		game.addVisual(pantalla1)
		const pantalla2 = new Celda(image = "assets/fondos/inicio2.png")
		game.schedule(5000, {game.removeVisual(pantalla1) game.addVisual(pantalla2)})
		game.schedule(10000, {game.removeVisual(pantalla2) self.iniciarJuego()})
		game.start()
	}
	method iniciarJuego(){
       	const personaje = new Personaje(image = "assets/jugador/user.png", esJugador = true)
       	
		keyboard.left().onPressDo({
        	izquierda.moverse(personaje, 1)
        	if(!personaje.tieneUnArma()){personaje.image("assets/jugador/userizq.png")}
        	else {personaje.image("assets/jugador/userakizq.png")}
        	})
        keyboard.right().onPressDo( { derecha.moverse(personaje,1)
        	if(!personaje.tieneUnArma()){personaje.image("assets/jugador/user.png")}
       		else {personaje.image("assets/jugador/userakder.png")}
        	})
        	//Tecla de salto
        keyboard.up().onPressDo( { personaje.saltar() } )
        	//Tecla para disparar
        keyboard.x().onPressDo( { sistemaDisparo.disparar(personaje) } )
       	
		game.addVisual(personaje)
    	self.generarElementos()
    	personaje.generarCorazones()
    	self.iniciarTimers(personaje)
   		game.onCollideDo(personaje, {obj => obj.interactuar(personaje)})      
	}
	
	//Cronometro que te da 1:30s para pasarte el Nivel, y el Tick de la Gravedad
	method iniciarTimers(personaje){
		game.schedule(90000, {
			game.removeVisual(personaje)
			const fondo = new Celda (
			image = "assets/fondos/gameover.png"
			)
		game.removeTickEvent("disparo NPC")
		game.addVisual(fondo)
		})
		game.onTick(500, "gravedad", {personaje.gravedad()})
	}
	
	// Generar Todos los Elementos
	method generarElementos(){
		self.generarPiso()
		self.generarObstaculos()
		self.generarBonus()
		self.generarNPC()
		self.generarDiezPesos()
		
	}
	
	method generarDiezPesos(){
		const diezPesos = new DiezPesos(
        	x = 19,
        	y = 7
        )
        game.addVisual(diezPesos)
        game.onTick(1000, "diezPesosHabla", {diezPesos.hablar()})
	}
	
	method generarPiso(){		
		//Genera el piso en las coordenadas x = [0;19], en la altura Y = -1
		20.times({i => game.addVisual(new Celda(
			x = -1+i,
			y = -1,
			esAterrizable = true
			
		))})
		////Genera el piso en las coordenadas x = [10;20], en la altura Y = 4
		11.times({i => game.addVisual(new Celda(
				x = 9+i,
				y = 4,
				esAterrizable = true
			
			))})
			
		3.times({i => game.addVisual(new Celda(
				x = 15+i,
				y = 3+i,
				esAterrizable = true
			))})
			
		game.addVisual(new Celda(
			x = 19,
			y = 6,
			esAterrizable = true
		))
	}
	
	method generarObstaculos(){
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 15,
			y = 0,
			esAterrizable = true
		))
		
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 16,
			y = 1,
			esAterrizable = true
		))
		
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 17,
			y = 2,
			esAterrizable = true
		))
		
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 15,
			y = 3,
			esAterrizable = true
		))
		
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 0,
			y = 6,
			esAterrizable = true
		))
		
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 1,
			y = 6,
			esAterrizable = true
		))
		
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 4,
			y = 6,
			esAterrizable = true
		))
		
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 6,
			y = 5,
			esAterrizable = true
		))
		
		game.addVisual(new Obstaculo(
			image = "assets/celdas/plataforma.png",
			x = 8,
			y = 4,
			esAterrizable = true
		))
		
		//Bordes Invisibles que no permiten te salgas del Escenario
		10.times({i => game.addVisual(new Obstaculo(
			x = -1,
			y = -1 + i,
			esAterrizable = true
		))})
		
		10.times({i => game.addVisual(new Obstaculo(
			x = 20,
			y = -1 + i,
			esAterrizable = true
		))})
	}	
	
	method generarBonus(){
		game.addVisual(new BonusBala(
			x = 16,
			y = 3
		))
		
		game.addVisual(new BonusBotiquin(
			x = 10,
			y = 5
		))
		game.addVisual(new Billete(
			x = 1,
			y = 7
		))
	}
	
	method generarNPC(){
		
		const npc1 = new Npc(
			image = "assets/npc/npc1izq.png",
			x = 15,
			y = 5,
			limiteIzquierdo = 10,
			limiteDerecho = 19,
			balas = 2
		)
		game.addVisual(npc1)
		game.onTick(1000, "disparo NPC", {sistemaDisparo.disparar(npc1)})
		game.onTick(2000, "movimiento NPC", {npc1.movimientoNPC()})
		
		const npc2 = new Npc(
			image = "assets/npc/npc2.png",
			x = 0,
			y = 7,
			balas = 2
		)
		game.addVisual(npc2)
		game.onTick(500, "disparo NPC", {sistemaDisparo.disparar(npc2)})
	}
	
}