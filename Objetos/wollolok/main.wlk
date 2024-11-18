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
   const edificios

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
    edificios.add(new Edificio(tipoEdificio = tipoEdificio, danio = 0, estadoEdificio = normal, duenio = self))
   }

   method consumirRecursos(recursosAConsumir){
    recursosAConsumir.forEach({recurso => self.gastarRecurso(recurso.tipoRecurso(), recurso.cantidad())})
   }

   method validarRecursos
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

}

// Edificios

class Edificio {
    const tipoEdificio
    var danio
    var estadoEdificio
    var duenio

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
}

// estados de los edificios

object destruido{

    method resistenciaMax(tipoEdificio) = 0

    method activarPoderEspecial(edificio, equipoContrario){}
}

object normal {

    method resistenciaMax(tipoEdificio) = tipoEdificio.recursosConstruccion().sum({recurso => recurso.resistenciaQueAporta()})

    method activarPoderEspecial(edificio, equipoContrario){
        
    }
}

class TipoEdificio {

    method recursosConstruccion()
}

object galeriaDeTiro inherits TipoEdificio{

    override method recursosConstruccion() = [
        new Recurso(tipoRecurso = oro, cantidad = 1000),
        new Recurso(tipoRecurso = madera, cantidad = 500),
        new Recurso(tipoRecurso = comida, cantidad = 350)
    ]
}

object fuerte inherits TipoEdificio{

    override method recursosConstruccion() = [
        new Recurso(tipoRecurso = oro, cantidad = 2000),
        new Recurso(tipoRecurso = piedra, cantidad = 1500),
        new Recurso(tipoRecurso = comida, cantidad = 200),
        new Recurso(tipoRecurso = madera, cantidad = 300)
    ]
}

object templo inherits TipoEdificio{

    override method recursosConstruccion() = [
        new Recurso(tipoRecurso = oro, cantidad = 8000),
        new Recurso(tipoRecurso = piedra, cantidad = 750),
        new Recurso(tipoRecurso = comida, cantidad = 500)
    ]
}