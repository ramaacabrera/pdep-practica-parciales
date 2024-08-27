module Lib where
import PdePreludat
-- Funciones útiles

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)

mayorSegun f a b
  | f a > f b = a
  | otherwise = b

----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------

data Chofer = Chofer {
  nombreChofer :: String,
  kmAuto :: Number,
  viajesTomados :: [Viaje],
  condicionViaje :: Condicion
}

type Condicion = Viaje -> Bool

data Viaje = Viaje {
  fecha :: Fecha,
  cliente :: Cliente,
  costo :: Number
}

data Fecha =  Fecha {
  dia :: Number,
  mes :: Number,
  anio :: Number
}

data Cliente = Cliente {
  nombreCliente :: String,
  direccionCliente :: String
}

-- Punto 2

esMenorSegun :: (Viaje -> Number) -> Number -> Viaje -> Bool
esMenorSegun funcion numero = (numero <) . funcion

cualquierViaje :: Condicion
cualquierViaje _ = True

masDe200 :: Condicion
masDe200 = esMenorSegun costo 200

nombreMasNLetras :: Number -> Condicion
nombreMasNLetras = esMenorSegun (length . nombreCliente . cliente)

noViveEn :: String -> Condicion
noViveEn direccion = (direccion /=) . direccionCliente . cliente

-- Punto 3

lucas :: Cliente
lucas = Cliente "Lucas" "Victoria"

daniel :: Chofer
daniel = Chofer {
  nombreChofer = "Daniel", 
  kmAuto = 23500,
  viajesTomados = [Viaje (Fecha 20 04 2017) lucas 150],
  condicionViaje = noViveEn "Olivos"
}

alejandra :: Chofer
alejandra = Chofer {
  nombreChofer = "Alejandra",
  kmAuto = 180000,
  viajesTomados = [],
  condicionViaje = cualquierViaje
}

-- Punto 4

puedeTomarViaje ::  Chofer -> Viaje -> Bool
puedeTomarViaje = condicionViaje 

-- Punto 5

liquidacionChofer :: Chofer -> Number
liquidacionChofer = sum . map costo . viajesTomados 

-- Punto 6

realizarUnViaje :: Viaje -> [Chofer] -> Chofer
realizarUnViaje viaje = agregarViaje viaje . choferMenosViajes . choferesInteresados viaje

choferesInteresados :: Viaje -> [Chofer] -> [Chofer]
choferesInteresados viaje = filter (`condicionViaje` viaje)

choferMenosViajes :: [Chofer] -> Chofer
choferMenosViajes [chofer] = chofer
choferMenosViajes (chofer1:chofer2:restoChoferes) = choferMenosViajes (menosViajesEntre chofer1 chofer2 : restoChoferes)

menosViajesEntre :: Chofer -> Chofer -> Chofer
menosViajesEntre chofer1 chofer2 
  | (length . viajesTomados) chofer1 < (length . viajesTomados) chofer2 = chofer1
  | otherwise = chofer2

agregarViaje :: Viaje -> Chofer -> Chofer
agregarViaje viaje chofer = chofer {viajesTomados = viaje : viajesTomados chofer}

-- Punto 7


nitoInfy :: Chofer
nitoInfy = Chofer {
  nombreChofer = "Nito Infy",
  kmAuto = 70000,
  viajesTomados = repetirViaje (Viaje (Fecha 11 03 2017) lucas 50),
  condicionViaje = nombreMasNLetras 2 
}

repetirViaje :: Viaje -> [Viaje]
repetirViaje viaje = viaje : repetirViaje viaje

{-  No, al ser lista infinita de viajes no puede terminar nunca de calcular el costo de cada uno
    de los viajes .
    Si, ya que solo necesita ver la `condicionViaje` para saber eso, no utiliza la lista infinitas 
    de viajes.
 -}

-- Punto 8

gongNeng :: Ord b => b -> (b -> Bool) -> (a -> b) -> [a] -> b
gongNeng arg1 arg2 arg3 = max arg1 . head . filter arg2 . map arg3