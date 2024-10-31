// operacion.comision()

class Operacion{
    const inmueble
    const empleado

    method comision()
}

class Alquiler inherits Operacion {
    const mesesAlquilados

    override method comision() = (mesesAlquilados * inmueble.valor()) / 50000 
}

class Venta inherits Operacion {
    const porcentajeComision = 0.015

    override method comision() = inmueble.valor() * porcentajeComision
}

class Inmueble {
    var tamanio
    var cantidadAmbientes
    const operacion

    method valor()
}

class Casa inherits Inmueble {
    const valorParticular

    override method valor() = valorParticular
}

class PH inherits Inmueble {

    override method valor() = (14000 * tamanio).max(500000)
}

class Departamento  inherits Inmueble {

    override method valor() = 350000 * cantidadAmbientes
}
