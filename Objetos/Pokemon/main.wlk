// pokemon.grositud()

class Pokemon {
    var vidaActual
    const vidaMax
    const movimientos = []
    var condicion = normal

    method sumaPoderMovimientos() = movimientos.sum({movimiento => movimiento.poder()})

    method grositud() = vidaMax * self.sumaPoderMovimientos()

    method recibirCura(puntosQueCura) {
        vidaActual = vidaMax.min(vidaActual + puntosQueCura)
    }

    method recibirDanio(danioRecibido) {
        vidaActual = 0.max(vidaActual - danioRecibido)
    }

    method aplicarCondicionEspecial(condicionEspecial){
        condicion = condicionEspecial
    }

    method lucharContra(contrincante){
        if(vidaActual == 0){
            throw new PokemonNoPuedeMoverseException(message = "El pokemon no esta vivo")
        }
        const movimientoAUsar = movimientos.findOrElse({movimiento => movimiento.estaDisponible()}, 
                                                    throw new NoTieneMovimientosException(message = "No tiene movimientos con usos restantes"))                                             
        condicion.intentaMoverse(self)
        movimientoAUsar.usarEntre(self, contrincante)
        
    }

    method normalizar(){
        condicion = normal
    }
}

class NoTieneMovimientosException inherits DomainException{}

class PokemonNoPuedeMoverseException inherits DomainException{}
class MovimientoSinUsosException inherits DomainException{}
class Movimientos {
    var usos

    method usarEntre(usuario, contrincante){
        if(! self.estaDisponible()){
            throw new MovimientoSinUsosException(message = "Usos agotados")
        }
        usos -= 1
        self.aplicarEfecto(usuario, contrincante)
    }

    method aplicarEfecto(usuario, contrincante)

    method estaDisponible() = usos > 0
}
class MovimientoCurativos {
    const puntosQueCura

    method poder() = puntosQueCura
    method aplicarEfecto(usuario, contrincante){
        usuario.recibirCura(puntosQueCura)
    }
}

class MovimientosDaninos {
    const danioQueProduce

    method poder() = 2 * danioQueProduce

    method aplicarEfecto(usuario, contrincante){
        contrincante.recibirDanio(danioQueProduce)
    }
}

class MovimientosEspeciales {
    const condicionEspecial

    method poder() = condicionEspecial.poder()

    method aplicarEfecto(usuario, contrincante) {
      contrincante.aplicarCondicionEspecial(condicionEspecial)
    }

}

class CondicionesEspeciales {
    method lePermiteMoverse() = 0.randomUpTo(2).roundUp().even()

    method intentaMoverse(pokemon) {
      if (! self.lePermiteMoverse()){
        throw new PokemonNoPuedeMoverseException(message = "Al pokemon la condicion no le permite moverse")
      }
    }
}
object suenio inherits CondicionesEspeciales{
    method poder() = 50
    override method intentaMoverse(pokemon) {
      super(pokemon)
      pokemon.normalizar()
    }

}
object paralisis inherits CondicionesEspeciales{
    method poder() = 30
}

class Confusion inherits CondicionesEspeciales {
    const turnosQueDura 

    method poder() = 40 * turnosQueDura

    override method intentaMoverse(pokemon) {
        if (! self.lePermiteMoverse()){
            pokemon.recibirDanio(20)
            throw new PokemonNoPuedeMoverseException(message = "Al pokemon la condicion no le permite moverse")
        }
        pokemon.aplicarCondicionEspecial(new Confusion(turnosQueDura = turnosQueDura - 1))
        if(turnosQueDura == 0 ){
            pokemon.normalizar()
        }
    }
}

object normal {
    method intentaMoverse() {}

}
