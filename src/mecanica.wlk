import wollok.game.*



object gere {
    
    //Atributos//
    var posicionX = 0
    var posicionY = 0
    var posicionAnteriorX = 0
    var posicionAnteriorY = 0
    var property position = game.at(posicionX,posicionY)
    var property estaSaltando = false
    var property estaArriba = false
    
    //Obtener posicion actual//
    method x() = posicionX
    method y() = posicionY
    
    //Imagen del personaje
    method image() = "user.png"
    
    //Movimiento//
    /* Cuando te moves, te moves una posicion y modifica la variable de posicion actual (todo esto sirve para futuras comparaciones)*/
    method moverseHaciaArriba(cantidad){        
        self.position(position.up(cantidad))
        posicionAnteriorY = posicionY
        posicionY += cantidad
        estaArriba = false
    }
    method moverseHaciaAbajo(cantidad){
        self.position(position.down(cantidad))
        posicionAnteriorY = posicionY
        posicionY -= cantidad
        estaArriba = false
    }
    method moverseHaciaIzquierda(cantidad){
        self.position(position.left(cantidad))
        posicionAnteriorX = posicionX
        posicionX -= cantidad
        estaArriba = false
    }
    method moverseHaciaDerecha(cantidad){
        self.position(position.right(cantidad))
        posicionAnteriorX = posicionX
        posicionX += cantidad  
        estaArriba = false 
    }
    
	   
    //Agregar un timer para que primero caiga antes de saltar.
    method saltar(){
    	if(!estaSaltando){
    		self.moverseHaciaArriba(1)
	        self.estaSaltando(true)
	        game.schedule(500, {self.moverseHaciaAbajo(1) self.estaSaltando(false)})
    	}   
    }
    
    //Para saber las coordenadas
    method dondeEstoy(){
    	game.say(self, posicionX.toString() + ", " + posicionY.toString())
    }
    
    method gravedad(){
    	if(!estaSaltando && !estaArriba){
    		if(posicionY >=1 && posicionY <5){
    			self.moverseHaciaAbajo(1)
    		}
    		else if(posicionY >=6 && posicionY <10){
    			self.moverseHaciaAbajo(1)
    		}
    		else if(posicionY >=5 && posicionY <10 && posicionX < 10){
    			self.moverseHaciaAbajo(1)
    		}
    		else if(posicionY < 0){
    			self.moverseHaciaArriba(1)
    		}
    		//Aprovecho y pongo los limites aca
    		else if(posicionX < 0){
    			self.moverseHaciaDerecha(1)
    		}
    	} 
    }
    
    //Acá hay que poner que comparen las posiciones x de ambos obejetos, es decir la pos x del objeto sea igual que la pos x del ascensor
    //Esto es para que el personaje suba el ascensor
    method ascensor(){
    	if (posicionX == 12 && posicionY == 0){
    		self.moverseHaciaArriba(5)
    		
    	}
    	else if (posicionX == 12 && posicionY == 5){
    		self.moverseHaciaAbajo(5)
    	}
    }

	//Esto pasa cuando se encuentra con un obstaculo (puede ser una caja o un npc)
     method rebotar(objeto){
     	if(objeto.esObstaculo() && !(objeto.esNpc())){
     		if(posicionAnteriorY > objeto.posicionY()){
     			self.moverseHaciaArriba(1)
     			estaArriba = true
     		}
     		else if(posicionAnteriorX > objeto.posicionX()){
     			self.moverseHaciaDerecha(1)
     		}
     		else if(posicionAnteriorX <= objeto.posicionX()){
     			self.moverseHaciaIzquierda(1)
     		}     		
     		//game.say(self, objeto.posicionX().toString())
     	}    
    }
}
/*Los NPC tiene una posicion por default, y solamente se mueven sobre el eje x, de izquierda a derecha. hay que hacer que se muevan aleatoreamente*/
class Npc{
	var posicionX = 0
    const posicionY = 0
    var property position = game.at(posicionX,posicionY)
	//Margen de movimiento
	const limiteIzquierdo = 0
	const limiteDerecho = 0
	var flag = true
	//Tipo de npc
	const tipo = "1"
	//Obtener posicion actual//
    method posicionX() = posicionX
    method posicionY() = posicionY
	//Imagen del NPC
	method image() = "npc" + tipo +".png"
	//Si es un obstaculo (para la funcion rebotar)
	method esObstaculo() = true
	method esNpc() = true
	


	//metodo de movimiento
	method moverse(){
        
   		//Hacer que se muevan de manera aleatoria en el eje x
        if(!(posicionX == limiteIzquierdo) && flag){
        	self.position(position.left(1))
        	posicionX -=1
        }
        else if ((posicionX == limiteDerecho) && !(flag)){
     		self.position(position.left(1))
        	posicionX -=1
        	flag = true
     	}
     	else if (!(posicionX == limiteIzquierdo) && !(flag)){
     		self.position(position.right(1))
        	posicionX +=1
     	}
        else{
        	self.position(position.right(1))
        	posicionX +=1
        	flag = false
        }
    }
}

//objeto a rescatar
object diezpeso{
	const posicionX = 19
    const posicionY = 7
    var property position = game.at(posicionX,posicionY)
    //Obtener posicion actual//
    method posicionX() = posicionX
    method posicionY() = posicionY
	//Imagen del objeto
	method image() = "rehen.png"
	method esObstaculo() = false
	method hablar() = game.say(self, "Diez peso'")
}

/*Elevadores: permiten al usuario subir del piso a la terraza y viceversa */
class Elevador {
	const posicionX = 0
    const posicionY = 0
    var property position = game.at(posicionX,posicionY)
	//Obtener posicion actual//
    method posicionX() = posicionX
    method posicionY() = posicionY
	method image() = "elevator.png"
	//Al ser false, no va a rebotar. Pero si va a cumplir lo de subir por el ascensor
	method esObstaculo() = false
	method esNpc() = false
}


//Objeto para hacer de obstaculo
class Caja {
	const posicionX = 0
    const posicionY = 0
    var property position = game.at(posicionX,posicionY)
    //Obtener posicion actual//
    method posicionX() = posicionX
    method posicionY() = posicionY
    method image() = "caja.png"
    method esObstaculo() = true
    method esNpc() = false
}




