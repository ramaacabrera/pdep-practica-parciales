// familia.tieneLugar(animal)
// (persona o mascota).tieneProblema(animal)
// familia.puedeAdoptar(animal)
// veterinaria.familiasConMenoresSinMascotas()
// veterinaria.animalesSinPoderAdoptarse()
// veterinaria.familiasDisponibles()
// familia.adoptar(animal)
// 


object veterinaria {
    const familiasParaAdopcion = []
    const animalesParaDar = []

    method familiasConMenoresSinMascotas() = familiasParaAdopcion.count({fam => fam.tieneMenores() && fam.noTieneMascotas()})

    method animalesSinPoderAdoptarse() = animalesParaDar.filter({ animal => familiasParaAdopcion.all({fam => !fam.puedeAdoptar(animal)}) })

    method familiasDisponibles() = familiasParaAdopcion.filter({fam => animalesParaDar.all({animal => fam.puedeAdoptar(animal)})})

    method animalAdoptado(animal){
        animalesParaDar.remove(animal)
    }
}


class Familia {
    const integrantes = []
    const mascotas = []
    const tamanioCasa

    method tieneLugar(animal) = animal.espacioQueOcupa() < self.espacioLibre()

    method espacioLibre() = tamanioCasa - (self.espacioOcupado())

    method espacioOcupado() = integrantes.sum({int => int.espacioQueOcupa()}) + mascotas.sum({masc => masc.espacioQueOcupa()})

    method puedeAdoptar(animal) = self.tieneLugar(animal) && self.nadieTieneProblemaCon(animal)

    method nadieTieneProblemaCon(animal) = integrantes.all({int => !int.tieneProblema(animal)}) && mascotas.all({masc => !masc.tieneProblema(animal)})

    method tieneMenores() = integrantes.any({int => int.esMenorDeEdad()})

    method noTieneMascotas() = mascotas.isEmpty()

    method adoptar(animal){
        self.validarQuePuedeAdoptar(animal)
        mascotas.add(animal)
        veterinaria.animalAdoptado(animal)
    }

    method validarQuePuedeAdoptar(animal){
        if(!self.puedeAdoptar(animal)){
            throw new FamiliaNoPuedeAdoptarException(message = "La familia no puede adoptar al animal requerido")
        }
    }
}

class FamiliaNoPuedeAdoptarException inherits DomainException{}

class Persona {
    var edad
    const esAlergica
    const animalesNoPreferidos

    method espacioQueOcupa(){
        if(edad > 13){
            return 1
        }
        return 0.75
    }

    method tieneProblema(animal) = animalesNoPreferidos.contains(animal) || (esAlergica && animal.esPeludo())

    method esMenorDeEdad() = edad < 18
}

class Animal{
    const nombre

    method espacioQueOcupa()
    method esPeludo()

    method tieneProblema(animal)
}

class Perro inherits Animal{
    const raza

    override method espacioQueOcupa() = raza.espacioOcupadoRaza()
    override method esPeludo() = raza.esRazaPeluda()
    override method tieneProblema(animal) = raza.problematicaCon(animal)
}

class PerroSalvaje inherits Perro{

    override method esPeludo() = true 
    override method espacioQueOcupa() = 2 * super()
}

class Raza {
    const tamanioRaza // = object pequenia, = class Grande(espacioOcupadoRaza = ?)
    const esRazaPeluda

    method esRazaPeluda() = esRazaPeluda
    method problematicaCon(animal) = tamanioRaza.problematicaCon(animal)
}

object pequenia {

    method espacioOcupadoRaza() = 0.5

    method problematicaCon(animal) = animal.espacioQueOcupa() > self.espacioOcupadoRaza()
}

class Grande {
    const espacioOcupadoRaza

    method espacioOcupadoRaza() = espacioOcupadoRaza

    method problematicaCon(animal) = animal.espacioQueOcupa().between(0.5, self.espacioOcupadoRaza())
}

class Gato inherits Animal{
    const esMalaOnda

    override method espacioQueOcupa() = 0.5
    override method esPeludo() = true
    override method tieneProblema(animal) = esMalaOnda
}

class PezDorado inherits Animal{

    override method espacioQueOcupa() = 0
    override method esPeludo() = false
    override method tieneProblema(animal) = false
}
