// tempano.seVeAzul()
// tempano.cuantoSeEnfria()
// masaSeAgua.esAtractiva()
// glaciar.tempanoPesoInicial()


class Tempano {
    const pesoTotal
    var tipoTempano

    method seVeAzul() = tipoTempano.seVeAzul(pesoTotal)
    method cuantoSeEnfria() = tipoTempano.cuantoSeEnfria(pesoTotal)
    method esGrande() = pesoTotal > 500
}

// Tipos de tempanos

object tempanoCompacto {
    const parteVisible = 0.15

    method seVeAzul(pesoTotal) = parteVisible * pesoTotal > 100
    method cuantoSeEnfria(pesoTotal) = 0.01 * pesoTotal 
}

object tempanoAireado {

    method seVeAzul(pesoTotal) = false
    method cuantoSeEnfria(pesoTotal) = 0.5
}

// Masa de agua y sus tipos

class MasaDeAgua {
    const tempanosFlotando = []
    const temperaturaAmbiente

    method esAtractiva() = tempanosFlotando.size() > 5 && tempanosFlotando.all({tempano => (tempano.esGrande() || tempano.seVeAzul())})

    method temperatura() = temperaturaAmbiente - self.gradosQueEnfrianTempanos()

    method gradosQueEnfrianTempanos() = tempanosFlotando.sum({tempano => tempano.cuantoSeEnfria()})

}

class Rio inherits MasaDeAgua {
    const velocidadBase

    override method temperatura() = super() + self.velocidadAgua()

    method velocidadAgua() = velocidadBase - self.cantidadTempanosGrandes()

    method cantidadTempanosGrandes() = tempanosFlotando.count({tempano => tempano.esGrande()})
}

// Glaciar

class Glaciar {
    var masa
    const temperatura = 1
    const desembocadura

    method tempanoPesoInicial() = (masa / 1000000) * desembocadura.temperatura()
    method temperatura() = temperatura
}