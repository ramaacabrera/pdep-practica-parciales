module Lib where
import PdePreludat

----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------

-- Punto 1
type Recurso = String

data Pais = Pais {
    ingresoPerCapita :: Number,
    poblacionSectorPublico :: Number,
    poblacionSectorPrivado :: Number,
    recursosNaturales :: [Recurso],
    deudaFMI :: Number -- Las deudas siempre estan expresadas en millones de dolares
} deriving (Eq,Show)

namibia :: Pais
namibia = Pais {
    ingresoPerCapita = 4140,
    poblacionSectorPublico = 400000,
    poblacionSectorPrivado = 650000,
    recursosNaturales = ["mineria","ecoturismo"],
    deudaFMI = 50 -- 50 equivale a 50 millones de dolares
}

-- Punto 2

type Estrategia = Pais -> Pais

prestarMillonesAlPais :: Number -> Estrategia
prestarMillonesAlPais dineroAPrestar = modificarDeudaPais (1.5 * dineroAPrestar)

modificarDeudaPais :: Number -> Pais -> Pais
modificarDeudaPais valorAModificar pais = pais {deudaFMI = deudaFMI pais + valorAModificar}

reducirPuestosSectorPublico :: Number -> Estrategia
reducirPuestosSectorPublico puestosAReducir pais = pais {
    poblacionSectorPublico = poblacionSectorPublico pais - puestosAReducir, 
    ingresoPerCapita = reduccionIngresoPerCapita puestosAReducir pais
}

reduccionIngresoPerCapita :: Number -> Pais -> Number
reduccionIngresoPerCapita puestosAReducir pais
    | puestosAReducir > 100 = ingresoPerCapita pais - ( 0.2 * ingresoPerCapita pais)
    | otherwise = ingresoPerCapita pais - (0.15 * ingresoPerCapita pais)

entregarRecursoNatural :: Recurso -> Estrategia
entregarRecursoNatural recursoNatural = modificarDeudaPais (-2) . eliminarRecurso recursoNatural 

eliminarRecurso :: Recurso -> Pais -> Pais
eliminarRecurso recursoNatural pais = pais {recursosNaturales = filter (/= recursoNatural) (recursosNaturales pais)}

blindaje :: Estrategia
blindaje pais = (reducirPuestosSectorPublico 500 . prestarMillonesAlPais (productoBrutoInterno pais / 2)) pais

productoBrutoInterno :: Pais -> Number
productoBrutoInterno pais = ingresoPerCapita pais * (poblacionSectorPublico pais + poblacionSectorPrivado pais)

-- Punto 3

type Receta = [Estrategia]

recetaEjemplo :: Receta
recetaEjemplo = [prestarMillonesAlPais 200, entregarRecursoNatural "mineria"]

aplicarReceta :: Receta -> Pais -> Pais
aplicarReceta receta pais = foldr ($) pais receta

-- > aplicarReceta recetaEjemplo namibia

-- Punto 4

puedenZafar :: [Pais] -> [Pais]
puedenZafar = filter (tieneXRecursoNatural "petroleo")

tieneXRecursoNatural :: String -> Pais -> Bool
tieneXRecursoNatural recurso = elem recurso . recursosNaturales

deudaTotalAFavor :: [Pais] -> Number
deudaTotalAFavor = sum . map deudaFMI

-- Punto 5

recetasOrdenadas :: Pais -> [Receta] -> Bool
recetasOrdenadas _ [receta] = True
recetasOrdenadas pais (receta1:receta2:restoRecetas) = 
        (productoBrutoInterno . aplicarReceta receta1) pais <= (productoBrutoInterno . aplicarReceta receta2) pais && recetasOrdenadas pais (receta2:restoRecetas)