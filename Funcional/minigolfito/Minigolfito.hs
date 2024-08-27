module Lib where
import PdePreludat
import GHC.Num (Num)
import GHC.Generics (prec)

-- Modelo inicial

data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Number,
  precisionJugador :: Number
} deriving (Eq, Show)

-- Jugadores de ejemplo

bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Number,
  precision :: Number,
  altura :: Number
} deriving (Eq, Show)

type Puntos = Number

-- Funciones útiles

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)

mayorSegun f a b
  | f a > f b = a
  | otherwise = b

----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------
-- Punto 1

type Palo = Habilidad -> Tiro

putter :: Palo
putter habilidad = UnTiro 
  {
    velocidad = 10,
    precision = 2 * precisionJugador habilidad,
    altura = 0
  }

madera :: Palo
madera habilidad = UnTiro 
  {
    velocidad = 100,
    precision = precisionJugador habilidad / 2,
    altura = 5
  }

hierros :: Number -> Palo
hierros n habilidad = UnTiro
  {
    velocidad = fuerzaJugador habilidad * n,
    precision = precisionJugador habilidad / n,
    altura = max (n-3) 0
  }

palos :: [Palo]
palos = [putter,madera] ++ map hierros [1..10]

-- Punto 2

golpe :: Palo -> Jugador -> Tiro
golpe unPalo = unPalo.habilidad

-- Punto 3
tiroDetenido = UnTiro 0 0 0

data Obstaculo = UnObstaculo {
  condicionSupera :: Tiro -> Bool, 
  condicionEfecto :: Tiro -> Tiro
  } deriving (Eq,Show)

tunelConRampita :: Obstaculo
tunelConRampita = UnObstaculo condicionesTunel efectoTunel 

condicionesTunel :: Tiro -> Bool
condicionesTunel unTiro = precision unTiro > 90 && altura unTiro == 0

efectoTunel :: Tiro -> Tiro
efectoTunel unTiro = unTiro
  {
    velocidad = velocidad unTiro * 2,
    precision = 100,
    altura = 0
  }

laguna :: Number -> Obstaculo
laguna largoLaguna = UnObstaculo condicionesLaguna (efectoLaguna largoLaguna)

condicionesLaguna :: Tiro -> Bool
condicionesLaguna unTiro = velocidad unTiro > 80 && (between 1 5 . altura) unTiro

efectoLaguna :: Number -> Tiro -> Tiro
efectoLaguna largoLaguna unTiro = unTiro {altura = altura unTiro / largoLaguna}

hoyo :: Obstaculo
hoyo = UnObstaculo condicionesHoyo efectoHoyo

condicionesHoyo :: Tiro -> Bool
condicionesHoyo unTiro = between 5 20 (velocidad unTiro) && altura unTiro == 0 && precision unTiro > 95   

efectoHoyo:: Tiro -> Tiro
efectoHoyo _ = tiroDetenido 

-- Punto 4

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles unJugador obstaculo = filter (superaObstaculo unJugador obstaculo) palos

superaObstaculo:: Jugador -> Obstaculo -> Palo -> Bool
superaObstaculo unJugador obstaculo palo =  condicionSupera obstaculo (golpe palo unJugador)

obstaculosConsecutivosSuperados :: Tiro -> [Obstaculo] -> Number
obstaculosConsecutivosSuperados _ [] = 0
obstaculosConsecutivosSuperados unTiro ((UnObstaculo condicion efecto) : restoObstaculos)
  | (not . condicion) unTiro = 0
  | condicion unTiro = obstaculosConsecutivosSuperados (efecto unTiro) restoObstaculos + 1

{- obstaculosConsecutivosSuperados' :: Tiro -> [Obstaculo] -> Number
obstaculosConsecutivosSuperados' unTiro = length . takeWhile (tiroSuperaObstaculo unTiro) -}

{- tiroPrueba = UnTiro 10 100 0

obstaculosPrueba = [tunelConRampita,tunelConRampita,hoyo] -}

paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil unJugador obstaculos = maximoSegun (flip obstaculosConsecutivosSuperados obstaculos . flip golpe unJugador) palos


-- Punto 5
jugadorTorneo = fst
puntosGanados = snd

padresPerdedores :: [(Jugador, Puntos)] -> [String]
padresPerdedores listaJugadores = (map (padre.jugadorTorneo) . filter (not . jugadorGano listaJugadores)) listaJugadores

jugadorGano :: [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
jugadorGano listaJugadores jugador =  (all ((puntosGanados jugador > ). puntosGanados) . filter (jugador /=)) listaJugadores