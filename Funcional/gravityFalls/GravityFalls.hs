module Lib where
import PdePreludat
import GHC.Windows (failIfFalse_)
----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------

find :: (a->Bool) -> [a] -> a
find condicion = head . filter condicion

-- Parte 1

type Item = String

data Persona = Persona {
  edad :: Number,
  items :: [Item],
  experiencia :: Number
} deriving (Eq,Show)

data Criatura = Criatura {
  peligrosidad :: Number,
  condicionDeshacerse :: Persona -> Bool
} deriving (Eq,Show)

siempredetras :: Criatura
siempredetras = Criatura {
  peligrosidad = 0,
  condicionDeshacerse = condicionSiempredetras
}

condicionSiempredetras :: Persona -> Bool
condicionSiempredetras _ = False

gnomos :: Number -> Criatura
gnomos cantidadGnomos = Criatura {
  peligrosidad = 2 ^ cantidadGnomos,
  condicionDeshacerse = condicionGnomos
}

condicionGnomos :: Persona -> Bool
condicionGnomos =  elem "sopladorDeHojas" . items

fantasmas :: Number -> (Persona -> Bool) -> Criatura
fantasmas categoria condicionFantasmas = Criatura {
  peligrosidad = categoria * 20,
  condicionDeshacerse = condicionFantasmas
}

seEnfrentaCriatura :: Persona -> Criatura -> Persona
seEnfrentaCriatura persona criatura 
  | condicionDeshacerse criatura persona = seDeshaceDeLaCriatura criatura persona
  | otherwise = seEscapa persona

seDeshaceDeLaCriatura :: Criatura -> Persona -> Persona
seDeshaceDeLaCriatura criatura persona = persona {experiencia = ((experiencia persona +) . peligrosidad) criatura}

seEscapa :: Persona -> Persona
seEscapa persona = persona {experiencia = experiencia persona + 1}

expGanada :: Persona -> [Criatura] -> Number
expGanada persona = diferenciaExpEntrePersonas persona . enfrentamientoSucesivoCriaturas persona

enfrentamientoSucesivoCriaturas :: Persona -> [Criatura] -> Persona
enfrentamientoSucesivoCriaturas = foldl seEnfrentaCriatura  

diferenciaExpEntrePersonas :: Persona -> Persona -> Number
diferenciaExpEntrePersonas persona1 = abs . (experiencia persona1 -) . experiencia

-- Ejemplo

ramiro :: Persona
ramiro = Persona 20 ["sopladorDeHojas","deslizadorCosmico","disfrazDeOveja"] 8

fantasmaEjemplo1 :: Criatura
fantasmaEjemplo1 = fantasmas 3 condFantasma1

condFantasma1 :: Persona -> Bool
condFantasma1 persona = edad persona < 13 && elem "disfrazDeOveja" (items persona)

fantasmaEjemplo2 :: Criatura
fantasmaEjemplo2 = fantasmas 1 condFantasma2

condFantasma2 :: Persona -> Bool
condFantasma2 persona = experiencia persona > 10 

{- 
> expGanada ramiro [siempredetras, gnomos 10, fantasmaEjemplo1, fantasmaEjemplo2]
1046 
-}

-- Parte 2

zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf _ _ [] _ = []
zipWithIf _ _ _ [] = []
zipWithIf funcionAplicacion condicion lista1 lista2
  | (not . condicion . head) lista2 = head lista2 : (zipWithIf funcionAplicacion condicion lista1 . tail) lista2
  | otherwise = funcionAplicacion  (head lista1) (head lista2) : zipWithIf funcionAplicacion condicion (tail lista1) (tail lista2)

abecedarioDesde :: Char -> [Char]
abecedarioDesde letra = [letra..'z'] ++ init ['a'..letra]

desencriptarLetra :: Char -> Char -> Char
desencriptarLetra letraClave letraEncriptada = (snd . find (esLetraBuscada letraEncriptada) . abecedarioEncriptacion) letraClave

abecedarioEncriptacion :: Char ->[(Char,Char)]
abecedarioEncriptacion letraClave = zip (abecedarioDesde letraClave) (abecedarioDesde 'a')

esLetraBuscada :: Char -> (Char,Char) -> Bool
esLetraBuscada letraBuscada = (letraBuscada ==) . fst

cesar :: Char -> String -> String
cesar letraClave txtEncriptado = zipWithIf desencriptarLetra esLetra (listaClaveCesar letraClave txtEncriptado) txtEncriptado

listaClaveCesar :: Char -> String -> [Char]
listaClaveCesar letraClave = flip replicate letraClave . length 

esLetra :: Char -> Bool
esLetra = (flip elem . abecedarioDesde) 'a'

{- 
> map (flip cesar "jrzel zrfaxal!") (abecedarioDesde 'a')
[ "jrzel zrfaxal!"
, "iqydk yqezwzk!"
, "hpxcj xpdyvyj!"
, "gowbi wocxuxi!"
, "fnvah vnbwtwh!"
, "emuzg umavsvg!"
, "dltyf tlzuruf!"
, "cksxe skytqte!"
, "bjrwd rjxspsd!"
, "aiqvc qiwrorc!"
, "zhpub phvqnqb!"
, "ygota ogupmpa!"
, "xfnsz nftoloz!"
, "wemry mesnkny!"
, "vdlqx ldrmjmx!"
, "uckpw kcqlilw!"
, "tbjov jbpkhkv!"
, "sainu iaojgju!"
, "rzhmt hznifit!"
, "qygls gymhehs!"
, "pxfkr fxlgdgr!"
, "owejq ewkfcfq!"
, "nvdip dvjebep!"
, "mucho cuidado!"
, "ltbgn bthczcn!"
, "ksafm asgbybm!"
] -}

vigenere :: String -> String -> String
vigenere txtClave txtEncriptado = zipWithIf desencriptarLetra esLetra (listaClaveVigenere txtClave txtEncriptado) txtEncriptado

listaClaveVigenere :: String -> String -> String
listaClaveVigenere txtClave = flip take (cycle txtClave) . length