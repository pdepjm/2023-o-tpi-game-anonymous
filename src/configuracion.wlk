import wollok.game.*
import personaje.*
import movimiento.*
import celdas.*

object juego {
	method iniciarJuego(){
		
    	//Configuracion de celdas, tamaño y titulo
        game.width(20)
        game.height(10)
        game.cellSize(75)
        game.title("Juego de anonymous")
        	//Fondo
        game.boardGround("fondo.jpg")
        
        //Configuracion de teclas
        	//Teclas de movimiento
        keyboard.left().onPressDo( { movimiento.moverseHaciaIzquierda(personaje, 1) } )
        keyboard.right().onPressDo( { movimiento.moverseHaciaDerecha(personaje,1) } )
        keyboard.down().onPressDo( { movimiento.moverseHaciaAbajo(personaje,1) } )
        	//Tecla de salto
        keyboard.c().onPressDo( { personaje.saltar() } )
        	//Tecla para disparar
        keyboard.x().onPressDo( { personaje.disparar() } )
        
        //Generar personaje
        self.generarElementos()
        
       	//Ticks 
       	game.onTick(500, "gravedad", {personaje.gravedad()})
       	
       	//Colisiones (personaje)
        	//Colision para el rebote del personaje contra los objetos
        game.onCollideDo(personaje, {obj => personaje.rebotar(obj)})
        	//Colision para que el personaje agarre los bonus
        game.onCollideDo(personaje, {objeto => personaje.agarrarBonus(objeto)})
        
        
        //Iniciar Juego
        game.start()
	}
	
	// Generar elementos
	method generarElementos(){
		self.generarPiso()
		self.generarObstaculos()
		self.generarBonus()
		game.addVisual(personaje)
	}
	
	method generarPiso(){		
		//Genera el piso en la coordenada x [0;18] en la posición Y = 0
		19.times({i => game.addVisual(new Celda(
			x = -1+i,
			y = -1,
			esAterrizable = true,
			esObstaculo = true
		))})
		////Genera el piso en la coordenada x [10;20] en la posición Y = 4
		12.times({i => game.addVisual(new Celda(
			x = 9+i,
			y = 4,
			esAterrizable = true,
			esObstaculo = true
		))})
	}
	
	method generarObstaculos(){
		//test para probar rebote
		game.addVisual(new Celda(
			x = 15,
			y = 0,
			esAterrizable = true,
			esObstaculo = true
		))
		
		game.addVisual(new Celda(
			x = 16,
			y = 1,
			esAterrizable = true,
			esObstaculo = true
		))
	}
	
	method generarBonus(){
		game.addVisual(new BonusBala(
			x = 16,
			y = 3,
			esUnBonus = true,
			darBalas = 50
		))
	}
	
}
