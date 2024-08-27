module Lib where
import PdePreludat

-- Modelo Inicial --

data Aspecto = UnAspecto {
  tipoDeAspecto :: String,
  grado :: Number
} deriving (Show, Eq)

type Situacion = [Aspecto]

mejorAspecto :: Aspecto -> Aspecto -> Bool
mejorAspecto mejor peor = grado mejor < grado peor

mismoAspecto :: Aspecto -> Aspecto -> Bool
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2

buscarAspecto :: Aspecto -> [Aspecto] -> Aspecto
buscarAspecto aspectoBuscado = head.filter (mismoAspecto aspectoBuscado)

buscarAspectoDeTipo :: String -> [Aspecto] -> Aspecto
buscarAspectoDeTipo tipo = buscarAspecto (UnAspecto tipo 0)

reemplazarAspecto :: Aspecto -> [Aspecto] -> [Aspecto]
reemplazarAspecto aspectoBuscado situacion = aspectoBuscado : filter (not.mismoAspecto aspectoBuscado) situacion

----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------
-- Punto 1

modificarAspecto :: (Number -> Number) -> Aspecto -> Aspecto
modificarAspecto modificador aspecto = aspecto { grado = (modificador . grado) aspecto }

situacionMejorQueOtra :: Situacion -> Situacion -> Bool
situacionMejorQueOtra situacion1 = flip all situacion1 . busquedaYComparacion 

busquedaYComparacion :: Situacion -> Aspecto -> Bool
busquedaYComparacion situacion aspecto = (mejorAspecto aspecto . buscarAspecto aspecto) situacion

modificarSituacion :: (Number -> Number) -> String -> Situacion -> Situacion
modificarSituacion modificador tipo situacion = (flip reemplazarAspecto situacion . modificarAspecto modificador . buscarAspectoDeTipo tipo) situacion

-- Punto 2

type Personalidad = Situacion -> Situacion

data Gema = UnaGema {
  nombre :: String,
  fuerza :: Number,
  personalidad :: Personalidad
}

vidente :: Personalidad
vidente = modificarSituacion (/ 2) "incertidumbre" . modificarSituacion (subtract 10) "tension"

relajada :: Number -> Personalidad
relajada nivelRelajada = modificarSituacion (subtract 30) "tension" . modificarSituacion (+ nivelRelajada) "peligro"

rubi :: Gema
rubi = UnaGema "Rubi" 10 vidente

esmeralda :: Gema
esmeralda = UnaGema "Esmeralda" 8 (relajada 4)

-- Punto 3

leGana :: Gema -> Gema -> Situacion -> Bool
leGana gema1 gema2 situacion = esMasFuerte gema1 gema2 && situacionMejorQueOtra (personalidad gema1 situacion) (personalidad gema2 situacion)

esMasFuerte :: Gema -> Gema -> Bool
esMasFuerte gema1 gema2 = fuerza gema1 >= fuerza gema2

-- Punto 4

fusion :: Situacion -> Gema -> Gema -> Gema
fusion situacion gema1 gema2 = UnaGema (nombreFusion gema1 gema2) (fuerzaFusion gema1 gema2 situacion) (personalidadFusion gema1 gema2)

nombreFusion :: Gema -> Gema -> String
nombreFusion gema1 gema2 
  | nombre gema1 == nombre gema2 = nombre gema1
  | otherwise = nombre gema1 ++ nombre gema2 

personalidadFusion :: Gema -> Gema -> Personalidad
personalidadFusion gema1 gema2 = personalidad gema1 . personalidad gema2 . modificarTodosAspectos (subtract 10)

modificarTodosAspectos :: (Number -> Number) -> Situacion -> Situacion
modificarTodosAspectos modificador = modificarSituacion modificador "tension" . modificarSituacion modificador "incertidumbre" . modificarSituacion modificador "peligro"

fuerzaFusion :: Gema -> Gema -> Situacion -> Number
fuerzaFusion gema1 gema2 situacion
  | sonCompatibles gema1 gema2 situacion = (fuerza gema1 + fuerza gema2) * 10
  | otherwise = ((7 *) . fuerza) (gemaDominante gema1 gema2 situacion)

sonCompatibles :: Gema -> Gema -> Situacion -> Bool
sonCompatibles gema1 gema2 situacion = situacionMejorQueOtra (personalidadFusion gema1 gema2 situacion) ((personalidad gema1 . personalidad gema2) situacion)

gemaDominante :: Gema -> Gema -> Situacion-> Gema
gemaDominante gema1 gema2 situacion
  | leGana gema1 gema2 situacion = gema1
  | otherwise = gema2

-- Punto 5

fusionGrupal :: Situacion -> [Gema] -> Gema
fusionGrupal situacion = foldl1 (fusion situacion) 

-- Punto 6

-- ???????????
