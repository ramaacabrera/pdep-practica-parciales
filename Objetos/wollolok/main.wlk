// jugador.explotarFuente(fuenteRecurso)
// jugador.seRinde()

class Jugador {
   const recursos = [
    new Recurso(cantidad = 500, tipoRecurso = oro), // pondria 500 como para que pueda arrancar a minar
    new Recurso(cantidad = 0, tipoRecurso = comida), // puse 0 para que no tire error al crear nuevo Recurso
    new Recurso(cantidad = 0, tipoRecurso = madera),
    new Recurso(cantidad = 0, tipoRecurso = piedra)
   ]
   const equipo
   const edificios = []

   method edificios() = edificios

   method explotarFuente(fuenteRecurso){
    self.gastarRecurso(oro, 50)
    self.aumentarRecurso(fuenteRecurso.recursoQueAporta(), fuenteRecurso.cuantoAporta())

    fuenteRecurso.consecuenciasExplotacion()
   }

   method aumentarRecurso(tipoRecurso, cantidadAumento){
    self.buscarRecurso(tipoRecurso).aumentar(cantidadAumento)
   }

   method gastarRecurso(tipoRecurso, cantidadGasto){
    self.buscarRecurso(tipoRecurso).gastar(cantidadGasto)
   }

   method buscarRecurso(tipo) = recursos.find({recurso => recurso.tipoRecurso() == tipo})

   method seRinde(){
    const aliadosEnPie = equipo.aliadosEnPie()
    const cantidadAliados = aliadosEnPie.size()
    recursos.forEach({recurso => aliadosEnPie.forEach({aliado => aliado.aumentarRecurso(recurso.tipoRecurso(), recurso.cantidad() / cantidadAliados)})})

    self.vaciarRecursos()
    edificios.forEach({edificio => edificio.destruir()})
   }

   method vaciarRecursos(){
    recursos.forEach({recurso => recurso.cantidad(0)})
   }

   method estaEnPie() = ! self.tieneRecursos()

   method tieneRecursos() = recursos.any({recurso => !recurso.noVacio()})

   method construirEdificio(tipoEdificio){
    self.consumirRecursos(tipoEdificio.recursosConstruccion())
    self.nuevoEdificio(new Edificio(tipoEdificio = tipoEdificio, danio = 0, estadoEdificio = normal, duenio = self))
   }

   method nuevoEdificio(edificio){
    edificios.add(edificio)
   }

   method consumirRecursos(recursosAConsumir){
    recursosAConsumir.forEach({recurso => self.gastarRecurso(recurso.tipoRecurso(), recurso.cantidad())})
   }

}
// Recursos y sus tipos

class Recurso {
    var property cantidad
    const tipoRecurso

    method tipoRecurso() = tipoRecurso

    method gastar(gastado){
        self.puedeGastarse(cantidad)

        cantidad -= gastado
    }

    method aumentar(aumento){
        cantidad += aumento
    }

    method puedeGastarse(cantidadAGastar){
        if(cantidad < cantidadAGastar){
            throw new RecursoException(message = "No tiene la cantidad suficiente de" + tipoRecurso + "para ser gastado")
        }
    }

    method noVacio() = cantidad > 0 

    method resistenciaQueAporta() = tipoRecurso.resistenciaTipo(cantidad)
}

class RecursoException inherits DomainException{}

class TipoDeRecurso {
    const resistenciaTipo

    method resistenciaTipo(cantidad) = cantidad * resistenciaTipo
}

object oro inherits TipoDeRecurso(resistenciaTipo = 1){
    override method resistenciaTipo(cantidad){
        if(cantidad > 5000){
            return super(cantidad) * 2
        }
        return super(cantidad)
    }
}
object comida inherits TipoDeRecurso(resistenciaTipo = 1){}
object madera inherits TipoDeRecurso(resistenciaTipo = 5){}
object piedra inherits TipoDeRecurso(resistenciaTipo = 10){}
//supuse valores de resistencia que no fueron dados en el enunciado para que no tire error

// Fuentes de recursos naturales

class Mina {
    var recursoQueAporta
    var cuantoAporta

    method recursoQueAporta() = recursoQueAporta
    method cuantoAporta() = cuantoAporta

    method consecuenciasExplotacion(){}
}

class Bosque {
    var hayArboles = true

    method recursoQueAporta() = madera
    method cuantoAporta(){
        if(hayArboles){
            return 200
        }
        return 0
    }

    method consecuenciasExplotacion(){hayArboles = false}
}

// Equipos

class Equipo {
    var jugadores 

    method aliadosEnPie() = jugadores.filter({jugador => jugador.estaEnPie()})

    method fueDerrotado() = jugadores.all({jugador => !jugador.tieneRecursos()})

    method edificios() = jugadores.map({jugador => jugador.edificios()}).flatten()

    method edificioConveniente() = self.edificios().find({edificio => edificio.esConvenienteAtacar()})
}

// Edificios

class Edificio {
    const tipoEdificio
    var danio
    var estadoEdificio
    var duenio

    method tipoEdificio() = tipoEdificio
    method duenio() = duenio

    method duenio(nuevoDuenio){
        duenio = nuevoDuenio
        nuevoDuenio.nuevoEdificio()
    }

    method destruir(){
        estadoEdificio = destruido
    }

    method estaEnBuenEstado() = self.resistencia() >= self.resistenciaMax()

    method resistencia() = self.resistenciaMax() - danio

    method resistenciaMax() = estadoEdificio.resistenciaMax(tipoEdificio)

    method reparar(cantidad){
        danio = 0.max(danio - cantidad)
    }

    method recibirDanio(cantidad){
        danio += cantidad

        if(self.resistencia() == 0){
            self.destruir()
        }
    }

    method activarPoderEspecial(equipoContrario) {
        estadoEdificio.activarPoderEspecial(self, equipoContrario)
    }

    method esConvertible() = estadoEdificio.convertible(self)

    method esConvenienteAtacar() = estadoEdificio.esConvenienteAtacar(self)

    method mejorarEdificio() {
        self.validarPosibilidadMejora()
        duenio.consumirRecursos(tipoEdificio.recursosMejora())
        estadoEdificio = mejorado
        self.reparar(danio)
    }

    method validarPosibilidadMejora(){
        if(!estadoEdificio.permiteMejora()){
            throw new MejoraEdificioException(message = "El edificio no puede ser mejorado porque esta destruido o ya esta mejorado")
        }
    }
}

class MejoraEdificioException inherits DomainException{}

// estados de los edificios

object destruido{

    method resistenciaMax(tipoEdificio) = 0

    method activarPoderEspecial(edificio, equipoContrario){}

    method convertible(edificio) = false
    method esConvenienteAtacar(edificio) = false
    method permiteMejora() = false
}

class Activo {
    method resistenciaMax(tipoEdificio) = self.recursosQueDanResistencia(tipoEdificio).sum({recurso => recurso.resistenciaQueAporta()})
    method recursosQueDanResistencia(tipoEdificio)

    method activarPoderEspecial(edificio, equipoContrario){
        edificio.tipoEdificio().activarPoderEspecial(edificio, equipoContrario)
        equipoContrario.edificioConveniente().recibirDanio(50)
    }

    method esConvenienteAtacar(edificio) = edificio.tipoEdificio().esConvenienteAtacar() || !edificio.estaEnBuenEstado()
}

object normal inherits Activo {

    override method recursosQueDanResistencia(tipoEdificio) = tipoEdificio.recursosConstruccion()

    method convertible(edificio) {
        edificio.tipoEdificio().convertible(edificio)
    }

    method permiteMejora() = true
}

object mejorado inherits Activo{

    override method recursosQueDanResistencia(tipoEdificio) = tipoEdificio.recursosMejora()
    method permiteMejora() = false
    method convertible(edificio) = false

}

class TipoEdificio {

    method recursosConstruccion()

    method convertible(edificio) = true
    method esConvenienteAtacar() = false

    method recursosMejora() = self.recursosConstruccion().map({recurso => new Recurso(tipoRecurso = recurso.tipoRecurso(), cantidad = 1.5 * recurso.cantidad())})
}

object galeriaDeTiro inherits TipoEdificio{

    override method recursosConstruccion() = [
        new Recurso(tipoRecurso = oro, cantidad = 1000),
        new Recurso(tipoRecurso = madera, cantidad = 500),
        new Recurso(tipoRecurso = comida, cantidad = 350)
    ]

    method activarPoderEspecial(edificio, equipoContrario){
        const edificioAAtacar = equipoContrario.edificioConveniente()

        if(edificioAAtacar.estaEnBuenEstado()){
            edificioAAtacar.recibirDanio(100)
        }
        else{
            edificioAAtacar.recibirDanio(300)
        }
    }
}

object fuerte inherits TipoEdificio{

    override method recursosConstruccion() = [
        new Recurso(tipoRecurso = oro, cantidad = 2000),
        new Recurso(tipoRecurso = piedra, cantidad = 1500),
        new Recurso(tipoRecurso = comida, cantidad = 200),
        new Recurso(tipoRecurso = madera, cantidad = 300)
    ]

    method activarPoderEspecial(edificio, equipoContrario){
        if(edificio.estaEnBuenEstado()){
            edificio.duenio().agregarRecursos(comida, 500)
        }
        else{
            edificio.reparar(20)
        }
    }
}

object templo inherits TipoEdificio{

    override method recursosConstruccion() = [
        new Recurso(tipoRecurso = oro, cantidad = 8000),
        new Recurso(tipoRecurso = piedra, cantidad = 750),
        new Recurso(tipoRecurso = comida, cantidad = 500)
    ]

    method activarPoderEspecial(edificio, equipoContrario){
        const edificioEnemigoAConvertir = equipoContrario.edificios().find({edificio => edificio.esConvertible()})
        edificioEnemigoAConvertir.duenio(self)
    }

    override method convertible(edificio) = false
    override method esConvenienteAtacar() = true
}