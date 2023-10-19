import wollok.game.*
import mecanica.*

object juego {
    
    method iniciarJuego(){
    	
    	
    	//Ajustes principales//
    	
    	//Configuracion de celdas, tamaño y titulo
        game.width(20)
        game.height(10)
        game.cellSize(75)
        
        //Fondo
        game.boardGround("fondo.jpg")
        
        //Cancion de fondo
        const musica = game.sound("musica.mp3")
		musica.shouldLoop(true)
		game.schedule(500, { musica.play()} )
		musica.volume(0.3)
 
        //Configuracion de teclas
        keyboard.left().onPressDo( { gere.moverseHaciaIzquierda(1) } )
        keyboard.right().onPressDo( { gere.moverseHaciaDerecha(1) } )
        keyboard.c().onPressDo( { gere.saltar() } )
        keyboard.s().onPressDo( { gere.ascensor() } )
        keyboard.z().onPressDo( { gere.dondeEstoy() } )
      	
      	//Generar elevadores
        game.addVisual(new Elevador(
        	posicionX = 12,
        	posicionY = 0       	
        ))
        game.addVisual(new Elevador(
        	posicionX = 12,
        	posicionY = 5       	
        ))
        //Generar cajas
        self.aparecerCajas()
        //Generar NPCS
        	//NPC1
        const npc1 = new Npc(
        	posicionX = 15,
			posicionY = 5,
			limiteIzquierdo = 10,
			limiteDerecho = 16,
			tipo = "1"
        )
        game.addVisual(npc1)
       		//NPC2
        const npc2 = new Npc(
        	posicionX = 15,
			posicionY = 0,
			limiteIzquierdo = 0,
			limiteDerecho = 16,
			tipo = "2"
        )
        game.addVisual(npc2)
        
        //Generar a diez Pesos
        game.addVisual(diezpeso)
        
        //Generar Personaje
        game.addVisual(gere)
        
        //ticks
        game.onTick(1000, "movimiento", { npc1.moverse() npc2.moverse()  })
        game.onTick(4000, "habla diez peso", {diezpeso.hablar()})
        game.onTick(500, "gravedad", {gere.gravedad()})
        
        
        //Cuando choca nuestro personaje con cualquier objeto
        game.onCollideDo(gere, {obj => gere.rebotar(obj)})
        
        
        //-----//
        game.start()
    }
    
    method aparecerCajas(){
        game.addVisual(new Caja(
        	posicionX = 5,
    		posicionY = 0
        ))
        game.addVisual(new Caja(
        	posicionX = 7,
    		posicionY = 0
        ))
        game.addVisual(new Caja(
        	posicionX = 7,
    		posicionY = 2
        ))
        game.addVisual(new Caja(
        	posicionX = 14,
    		posicionY = 5
        ))
      /*   game.addVisual(new Caja(
        	posicionX = 10,
    		posicionY = 5
        ))
         game.addVisual(new Caja(
         	posicionX = 10,
    		posicionY = 6
        ))
         game.addVisual(new Caja(
         	posicionX = 10,
    		posicionY = 7
        ))*/
    }
}