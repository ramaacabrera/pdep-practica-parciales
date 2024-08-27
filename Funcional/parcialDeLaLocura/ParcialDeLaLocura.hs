module Lib where
import PdePreludat

----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------

-- Modelo Inicial

data Investigador = Investigador {
    nombre :: String,
    cordura :: Number,
    items :: [Item],
    sucesosEvitados :: [String]
} deriving (Show, Eq)

data Item = Item {
    nombreItem :: String,
    valor :: Number
} deriving (Show,Eq)

maximoSegun :: Ord a1 => (a2 -> a1) -> [a2] -> a2
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b 
    | f a > f b = a
    | otherwise = b

deltaSegun :: (b -> Number) -> (b -> b) -> b -> Number
deltaSegun ponderacion transformacion valor = abs ((ponderacion . transformacion) valor - ponderacion valor)

-- Punto 1

queEnloquezca :: Number -> Investigador -> Investigador
queEnloquezca valor investigador = investigador {cordura = max 0 (valor + cordura investigador)}

hallaItem :: Item -> Investigador -> Investigador
hallaItem itemNuevo = queEnloquezca (valor itemNuevo) . agregarItem itemNuevo

-- Punto 2

algunoTieneItem :: String -> [Investigador] -> Bool
algunoTieneItem nombreItem = any (tieneItem nombreItem)

tieneItem :: String -> Investigador -> Bool
tieneItem nombre = elem nombre . map nombreItem . items

-- Punto 3

lider :: [Investigador] -> Investigador
lider = maximoSegun potencial

potencial :: Investigador -> Number
potencial (Investigador _ 0 _ _) = 0
potencial investigador = (cordura investigador * experiencia investigador) + (valor . itemMasValor) investigador

experiencia :: Investigador -> Number
experiencia investigador = 1 + ((3 *) . length . sucesosEvitados) investigador

itemMasValor :: Investigador -> Item
itemMasValor = maximoSegun valor . items

-- Punto 4

deltaCorduraTotal :: Number -> [Investigador] -> Number
deltaCorduraTotal valor = sum . map (deltaSegun cordura (queEnloquezca valor))

deltaPotencialPrimerIntegrante :: [Investigador] -> Number
deltaPotencialPrimerIntegrante valor = undefined -- ??????????

-- Punto 5

data Suceso = Suceso {
    descripcion :: String,
    consecuencias :: [Investigador] -> [Investigador],
    puedenEvitar :: [Investigador] -> Bool
} deriving (Show, Eq)

sucesoEjemplo1 :: Suceso
sucesoEjemplo1 = Suceso {descripcion = "Despertar de un antiguo", consecuencias = consecuenciasEjemplo1, puedenEvitar = algunoTieneItem "Necronomicon" }

consecuenciasEjemplo1 :: [Investigador] -> [Investigador]
consecuenciasEjemplo1 = pierdenPrimerIntegrante . todosEnloquecen 10

todosEnloquecen :: Number -> [Investigador] -> [Investigador]
todosEnloquecen = map . queEnloquezca 

pierdenPrimerIntegrante :: [Investigador] -> [Investigador]
pierdenPrimerIntegrante (investigador1:restoInvestigadores) = restoInvestigadores 

sucesoEjemplo2 :: Suceso
sucesoEjemplo2 = Suceso {descripcion = "Ritual en Innsmouth", consecuencias = consecuenciasEjemplo2, puedenEvitar = (100 <).potencial.lider}

dagaMaldita :: Item
dagaMaldita = Item {nombreItem = "Daga Maldita", valor = 3}

consecuenciasEjemplo2 :: [Investigador] -> [Investigador]
consecuenciasEjemplo2  = enfrenten sucesoEjemplo1 . todosEnloquecen 2 . primeroHalla dagaMaldita

primeroHalla :: Item -> [Investigador] -> [Investigador]
primeroHalla item (investigador1 : restoInvestigadores) = agregarItem item investigador1 : restoInvestigadores

agregarItem :: Item -> Investigador -> Investigador
agregarItem item investigador = investigador {items = item : items investigador}

-- Punto 6

enfrenten :: Suceso -> [Investigador] -> [Investigador]
enfrenten suceso investigadores 
    | puedenEvitar suceso investigadores = map (agregarSuceso suceso) investigadores
    | otherwise = consecuencias suceso investigadores

agregarSuceso :: Suceso -> Investigador -> Investigador
agregarSuceso suceso investigador = investigador {sucesosEvitados = descripcion suceso : sucesosEvitados investigador} 

-- Punto 7

masAterrador :: [Suceso] -> [Investigador] -> Suceso
masAterrador [suceso] _ = suceso
masAterrador (suceso1:suceso2:restoSucesos) investigadores 
    | (deltaCorduraTotal 0 .  enfrenten suceso1) investigadores >  (deltaCorduraTotal 0 .  enfrenten suceso2) investigadores = masAterrador (suceso1 : restoSucesos) investigadores
    | otherwise = masAterrador (suceso2 : restoSucesos) investigadores

