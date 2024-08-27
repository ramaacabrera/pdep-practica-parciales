module Lib where
import PdePreludat

----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------

-- Punto 1

data Personaje = Personaje {
  nombre :: String,
  edad :: Number,
  energia :: Number,
  habilidades :: [String],
  planeta :: String
}

data Guantelete = Guantelete {
  material :: String,
  gemas :: [Gema]
}

type Universo = [Personaje]

chasquido :: Universo -> Universo
chasquido universo = take (div (length universo) 2) universo

-- Punto 2

aptoPendex :: Universo -> Bool
aptoPendex = any ((45>) . edad)

energiaTotal :: Universo -> Number
energiaTotal [] = 0
energiaTotal universo =  (sum . map energia . filter (masDeXHabilidades 1)) universo

masDeXHabilidades :: Number -> Personaje -> Bool
masDeXHabilidades valor personaje = (length . habilidades) personaje > valor

-- Punto 3

type Gema = Personaje -> Personaje

gemaMente :: Number -> Gema
gemaMente = quitarEnergia

-- Supongo que un personaje no podria tener una energia negativa
quitarEnergia :: Number -> Personaje -> Personaje
quitarEnergia valor personaje = personaje { energia = (max 0 . subtract valor . energia) personaje} 

gemaAlma :: String -> Gema
gemaAlma habilidadAEliminar personaje = quitarEnergia 10 personaje {habilidades = eliminarHabilidad habilidadAEliminar personaje}

eliminarHabilidad :: String -> Personaje -> [String]
eliminarHabilidad habilidadAEliminar = filter (/= habilidadAEliminar) . habilidades

gemaEspacio :: String -> Gema
gemaEspacio planeta personaje = quitarEnergia 20 personaje{planeta = planeta}

gemaPoder :: Gema 
gemaPoder personaje = personaje {energia = 0, habilidades = habilidadesGemaPoder personaje}

habilidadesGemaPoder :: Personaje -> [String]
habilidadesGemaPoder personaje 
  | (not . masDeXHabilidades 2) personaje  = []
  | otherwise = habilidades personaje

gemaTiempo :: Gema
gemaTiempo personaje = quitarEnergia 50 personaje {edad = max 18 (((`div` 2) . edad) personaje)}

gemaLoca :: Gema -> Gema
gemaLoca gema = gema . gema

-- Punto 4

guanteleteEjemplo :: Guantelete
guanteleteEjemplo = Guantelete {
  material = "Goma",
  gemas = [gemaTiempo, gemaAlma "usar Mjolnir", (gemaLoca . gemaAlma) "programacion en Haskell"]
}

-- Punto 5

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas personaje = foldr ($) personaje gemas

-- Punto 6

menorSegun :: Ord b => (a->b) -> a -> a -> a
menorSegun f a b
  | f a < f b = a
  | otherwise = b

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa = gemaMasPoderosaEntre . gemas

gemaMasPoderosaEntre :: [Gema] -> Personaje -> Gema
gemaMasPoderosaEntre [gema] _ = gema
gemaMasPoderosaEntre (gema1:gema2:restoGemas) personaje
  | (energia.gema1) personaje < (energia.gema2) personaje = gemaMasPoderosaEntre (gema1:restoGemas) personaje
  | otherwise = gemaMasPoderosaEntre (gema2:restoGemas) personaje

-- Punto 7
{- 
 - "gemaMasPoderosa punisher guanteleteDeLocos"
  No se podria utilizar debido a que el guante tiene infinitas gemas por lo que gemaMasPoderosa
  no podria determinar nunca cual es la mas poderosa, debido a que hay infinitas
 
 - "usoLasTresPrimerasGemas guanteleteDeLocos punisher"
  Esta funcion, a diferencia de la anterior, si tendria un resultado, ya que haskell
  entiende que solo va a necesitar los primeros tres elementos de la lista de gemas
  por lo que solo va a generar esos tres elementos necesarios y luego va a proceder
  a ejecutar.
  
 -}

