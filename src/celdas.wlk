import wollok.game.*

// Modelado de la clase celda
class Celda{
	var property miraIzquierda = false
    const esAterrizable = false
    const esObstaculo = false
    var property image = "piso.png"
    var property esUnBonus = false
    var property x = 0
    var property y = 0
    var property position = game.at(x, y)
	var property posicionAnteriorY = 0
	var property posicionAnteriorX = 0
 	 
	method esAterrizable() = esAterrizable
	method esObstaculo() = esObstaculo
	
}

// Clase para obtener los poderes
class Bonus inherits Celda{
	override method image() = "gecko.png"
	method darBonus(personaje)
}

class BonusBala inherits Bonus{
	const darBalas = 10
	override method darBonus(personaje) {
		var personajeBalas = personaje.balas()
		personajeBalas += darBalas
		personaje.balas(personajeBalas)
	}
}