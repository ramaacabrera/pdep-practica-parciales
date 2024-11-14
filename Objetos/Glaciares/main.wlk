// tempano.seVeAzul()
// tempano.cuantoSeEnfria()
// masaSeAgua.esAtractiva()
// glaciar.tempanoPesoInicial()
// glaciar.desprendimiento()
// embarcacion.navegarPor(masaDeAgua)


class Tempano {
    var pesoTotal
    var property tipoTempano

    method pesoTotal() = pesoTotal
    method seVeAzul() = tipoTempano.seVeAzul(pesoTotal)
    method cuantoSeEnfria() = tipoTempano.cuantoSeEnfria(pesoTotal)
    method esGrande() = pesoTotal > 500
    method esAtractivo() = self.esGrande() || self.seVeAzul()
    method perdioPeso(cantidad){
        pesoTotal -= cantidad
        tipoTempano.efectoExtraNavegacion(self)
    }
}

// Tipos de tempanos

object tempanoCompacto {
    const parteVisible = 0.15

    method seVeAzul(pesoTotal) = parteVisible * pesoTotal > 100
    method cuantoSeEnfria(pesoTotal) = 0.01 * pesoTotal 
    method efectoExtraPeso(tempano) {
        if(!tempano.esGrande()){
            tempano.tipoTempano(tempanoAireado)
        }
    }
}


object tempanoAireado {

    method seVeAzul(pesoTotal) = false
    method cuantoSeEnfria(pesoTotal) = 0.5
    method efectoExtraNavegacion(tempano){}
}

// Masa de agua y sus tipos

object ambiente {
    var property temperatura = 20 // puse 20 por poner un numero y que no chille el error, pero el valor deberia ser seteado segun el ambiente en el que se encuentre
}

class MasaDeAgua {
    const tempanosFlotando = []
    

    method cantidadTempanosGrandes() = tempanosFlotando.count({tempano => tempano.esGrande()})

    method esAtractiva() = tempanosFlotando.size() > 5 && tempanosFlotando.all({tempano => tempano.esAtractivo()})

    method temperatura() = self.temperaturaAmbiente() - self.gradosQueEnfrianTempanos()

    method temperaturaAmbiente() = ambiente.temperatura()

    method gradosQueEnfrianTempanos() = tempanosFlotando.sum({tempano => tempano.cuantoSeEnfria()})

    method nuevoTempano(tempano){
        tempanosFlotando.add(tempano)
    }

    method puedeNavegar(embarcacion) 

    method efectoDeNavegar(){
        tempanosFlotando.forEach({tempano => tempano.navegoEmbarcacion()})
    }
}

class NoPuedeNavegarException inherits DomainException{}

class Lago inherits MasaDeAgua {

    override method puedeNavegar(embarcacion) {
        if(self.temperaturaAmbiente() < 0){
            throw new NoPuedeNavegarException(message = "Agua congelada")
        } 
        if(self.cantidadTempanosGrandes() > 20 && embarcacion.tamanio() < 10){
            throw new NoPuedeNavegarException(message = "Embarcacion grande para lago con muchos tempanos grandes")
        }
    }
}

class Rio inherits MasaDeAgua {
    const velocidadBase

    override method temperatura() = super() + self.velocidadAgua()

    method velocidadAgua() = velocidadBase - self.cantidadTempanosGrandes()

    override method puedeNavegar(embarcacion) {
        if(self.velocidadAgua() > embarcacion.fuerzaMotor()){
            throw new NoPuedeNavegarException(message = "Fuerza motor no suficiente")
        }
    }
}

// Glaciar

class Glaciar {
    var masa
    const temperatura = 1
    const desembocadura

    method tempanoPesoInicial() = (masa / 1000000) * desembocadura.temperatura()
    method temperatura() = temperatura

    method modificarMasa(valor){
        masa += valor
    }

    method desprendimiento() {
        const tempanoCompacto = new Tempano(pesoTotal = self.tempanoPesoInicial(), tipoTempano = tempanoCompacto)
        self.modificarMasa(-(tempanoCompacto.pesoTotal()))
        desembocadura.nuevoTempano(tempanoCompacto)
    }

    method nuevoTempano(tempano) {
         self.modificarMasa(tempano.pesoTotal())
    }
}

class Embarcacion {
    const tamanio
    const fuerzaMotor

    method fuerzaMotor() = fuerzaMotor
    method tamanio() = tamanio

    method navegarPor(masaDeAgua) {
        masaDeAgua.puedeNavegar(self)
        masaDeAgua.efectoDeNavegar()
    }
}