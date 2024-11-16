//posta.esMejorCompetidor(unVikingo, otroVikingo)
// torneo.jugar()

object torneo {
    const participantesTorneo = []
    const dragonesDisponibles = []
    const postas = [] // [pesca, combate, new Carrera(km = distancia)]

    method jugar() {
        postas.forEach({posta => posta.jugarPosta(participantesTorneo, dragonesDisponibles)})
    }

    method participantesTorneo() = participantesTorneo
    method dragonesDisponibles() = dragonesDisponibles

    method dragonElegido(dragon){
        dragonesDisponibles.remove(dragon)
    }
}

class Posta {
    var participantesPosta
    method esMejorCompetidor(unVikingo, otroVikingo)

    method jugarPosta(participantesTorneo, dragonesDisponibles){
        self.inscribirParticipantes(participantesTorneo, dragonesDisponibles)
        self.registrarResultados()
        self.efectosPostCompeticion()
    }

    method inscribirParticipantes(participantesTorneo, dragonesDisponibles){
        participantesPosta = participantesTorneo.map({participante => participante.comoConvieneParticipar(self, dragonesDisponibles)}).filter({participante => participante.puedeParticipar(self)})
        participantesPosta.forEach({p => p.efectoInscripcion()})
    }

    method registrarResultados() {
        participantesPosta.sortBy({unParticipante, otroParticipante => self.esMejorCompetidor(unParticipante, otroParticipante)})
    }

    method efectosPostCompeticion() {
        participantesPosta.forEach({participante => participante.sufrirEfectos(self)})
    }

    method hambreQueProduce()
}

class NoPuedeParticiparException inherits DomainException{}

class Pesca inherits Posta {

    override method esMejorCompetidor(unVikingo, otroVikingo) = unVikingo.pescadoQueLevanta() > otroVikingo.pescadoQueLevanta()

    override method hambreQueProduce() = 5
}

class Combate inherits Posta {

    override method esMejorCompetidor(unVikingo, otroVikingo) = unVikingo.danioQueProduce() > otroVikingo.danioQueProduce()

    override method hambreQueProduce() = 10
} 

class Carrera inherits Posta {
    const kmDistancia

    override method esMejorCompetidor(unVikingo, otroVikingo) = unVikingo.velocidad() > otroVikingo.velocidad()

    override method hambreQueProduce() = kmDistancia
}

class Vikingo {
    var property peso
    var property inteligencia
    var property velocidad
    var property barbarosidad
    var property nivelHambre // un numero entre 0 y 100 (porcentaje)
    var property item

    method pescadoQueLevanta() = 0.5 * peso + 2 * barbarosidad

    method danioQueProduce() = barbarosidad + item.danioExtra()

    method velocidad() = velocidad

    method hambreQueGanaria(valor) = nivelHambre + valor

    method aumentaHambre(valor) {
        nivelHambre = 100.min(self.hambreQueGanaria(valor))
    }

    method sufrirEfectos(posta) {
        self.aumentaHambre(posta.hambreQueProduce())
    }

    method puedeParticipar(posta) = self.hambreQueGanaria(posta.hambreQueProduce()) < 100

    method puedeMontar(dragon) = dragon.puedeSerMontado(self)

    method montaDragon(dragon){
        if(!self.puedeMontar(dragon)){
            throw new MonturaException(message = "El vikingo no puede montar al dragon")
        }
        return new Jinete(vikingo = self, dragon = dragon)
    }

    method comoConvieneParticipar(posta, dragones){
        const dragonesMontables = dragones.filter({dragon => self.puedeMontar(dragon)})
        const posiblesParticipaciones = dragonesMontables.map({dragon => self.montaDragon(dragon)}) + [self]
        
        return posiblesParticipaciones.fold(self, {mejorParticipacion, jinete => 
            if (posta.esMejorCompetidor(mejorParticipacion, jinete)){
                mejorParticipacion
            }
            else jinete
            })
    }

    method efectoInscripcion(){}
}

class MonturaException inherits DomainException{}

object patapez inherits Vikingo(peso = 100, inteligencia = 5, nivelHambre = 0, velocidad = 10, barbarosidad = 15, item = new Comestible(energiaQueDa = 10)){
    // Supuse todos esos valores para poder instanciarlo sin que me tire error, entiendo que deberian ser datos a agregar propios del vikingo
    
    override method puedeParticipar(posta) = self.hambreQueGanaria(posta.hambreQueProduce()) < 50

    override method hambreQueGanaria(valor) = 2 * super(valor)

    override method sufrirEfectos(posta) {
        super(posta)
        self.comer()
    }

    method comer(){
        self.reduceHambre(item.energiaQueDa())
    }

    method reduceHambre(valor){
        nivelHambre = 0.max(nivelHambre - valor)
    }
}


class Item {
    method danioExtra()
}

class Arma inherits Item {
    var danio

    override method danioExtra() = danio
}

class Comestible inherits Item{
    var energiaQueDa

    method energiaQueDa() = energiaQueDa
    override method danioExtra() = 0
}


class Dragon {
    var velocidadBase = 60
    var peso

    method velocidadVuelo() = velocidadBase - peso
    method danioQueProduce()
    method velocidadBase() = velocidadBase

    method puedeSerMontado(vikingo) = self.requisitosMontura().all({requisito => requisito.pasaRequisito(self, vikingo)})
    method cuantoPuedeCargar() = 0.2 * peso
    method requisitosMontura() = #{requisitoBase}
}

class FuriaNocturna inherits Dragon {
    var danioQueProduce

    override method velocidadVuelo() = 3 * super()
    override method danioQueProduce() = danioQueProduce
}

class NadderMortifero inherits Dragon() {
    var inteligencia

    method inteligencia() = inteligencia

    override method requisitosMontura() = super().union(#{requisitoInteligencia})

    override method danioQueProduce() = 150
}

class Gronckle inherits Dragon() {
    override method velocidadBase() = super()/2
    override method danioQueProduce() = 5 * peso
}

object chimuelo inherits FuriaNocturna(danioQueProduce = 50, peso = 100) {
    override method requisitosMontura() = super().union(#{new RequisitoItem(itemNecesario = "Sistema de Vuelo")})
}

class Requisito {
    method pasaRequisito(dragon, vikingo)
}

object requisitoBase inherits Requisito {
    override method pasaRequisito(dragon, vikingo) = vikingo.peso() < dragon.cuantoPuedeCargar()
}

class RequisitoBarbarosidad inherits Requisito{
    var limite

    override method pasaRequisito(dragon, vikingo) = vikingo.barbarosidad() > limite
}

class RequisitoItem inherits Requisito{
    var itemNecesario
    override method pasaRequisito(dragon, vikingo) = vikingo.item().nombre() == itemNecesario
}

object requisitoInteligencia inherits Requisito{
    override method pasaRequisito(dragon, vikingo) = dragon.inteligencia() > vikingo.inteligencia()
}


class Jinete {
    const dragon
    const vikingo

    method pescadoQueLevanta() = dragon.cuantoPuedeCargar() - vikingo.peso()

    method danioQueProduce() = dragon.danioQueProduce() + vikingo.danioQueProduce()

    method velocidad() = dragon.velocidadVuelo() - vikingo.peso()

    method sufrirEfectos(posta) = vikingo.aumentaHambre(5)

    method puedeParticipar(posta) = vikingo.hambreQueGanaria(5) < 100

    method efectoInscripcion() {
        torneo.dragonElegido(dragon)
    }
}
