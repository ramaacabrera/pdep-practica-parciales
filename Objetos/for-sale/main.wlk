// operacion.comision()
// inmobiliaria.mejorEmpleadoSegun...()

object inmobiliaria {
    const porcentajeComision = 0.015
    const empleados = #{}

    method porcentajeComision() = porcentajeComision

    method mejorEmpleadoSegun(criterio) = empleados.max({empleado => criterio.regla(empleado)}) 
}

object segunTotalComisiones {
    method regla(empleado) = empleado.totalComisiones()
}
object segunCantidadOpsCerradas {
    method regla(empleado) = empleado.operacionesCerradas().size()
}
object segunCantidadReservas {
    method regla(empleado) = empleado.reservasRealizadas().size()
}

class Empleado {
    const operacionesCerradas = #{}
    const reservas = #{}

    method operacionesCerradas() = operacionesCerradas

    method reservasRealizadas() = reservas

    method totalComisiones() = self.operacionesCerradas().sum({operacion => operacion.comision()})
}

class Operacion{
    const inmueble
    var estado

    method comision()
}

object cerrada {}
object reservada {}

class Alquiler inherits Operacion {
    const mesesAlquilados

    override method comision() = (mesesAlquilados * inmueble.valor()) / 50000 
}

class Venta inherits Operacion {

    override method comision() = inmueble.valor() * inmobiliaria.porcentajeComision()
}

class Inmueble {
    const tamanio
    const cantidadAmbientes
    const zona

    method valor() = self.valorPropio() + zona.valor()

    method valorPropio()
}

class Casa inherits Inmueble {
    const valorParticular

    override method valorPropio() = valorParticular
}

class PH inherits Inmueble {

    override method valorPropio() = (14000 * tamanio).max(500000)
}

class Departamento  inherits Inmueble {

    override method valorPropio() = 350000 * cantidadAmbientes

}

class Zona {
    var property valor 
}
