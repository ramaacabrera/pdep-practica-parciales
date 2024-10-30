// pokemon.movimientoCurativo()

class Pokemon {
    var vidaActual
    var vidaMax
    var movimientos = []

    method sumaPoderMovimientos() = movimientos.sum({movimiento => movimiento.poder()})

    method grositud() = vidaMax * self.sumaPoderMovimientos()
}

class MovimientoCurativo {
    
}
