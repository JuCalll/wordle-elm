module Dominio.Evaluacion exposing
    ( Estado(..)
    , LetraEvaluada
    , evaluar
    )

{-| Compara un intento contra la palabra objetivo y decide el estado
de cada letra.

El algoritmo usa dos pasadas para tratar correctamente las letras
repetidas: primero se resuelven las coincidencias exactas, y solo
las letras sobrantes quedan disponibles para las coincidencias
de posición incorrecta.

-}

import Dict exposing (Dict)
import Dominio.Palabra as Palabra exposing (Palabra)


type Estado
    = Correcta
    | PosicionIncorrecta
    | Ausente


type alias LetraEvaluada =
    { letra : Char
    , estado : Estado
    }


evaluar : { objetivo : Palabra, intento : Palabra } -> List LetraEvaluada
evaluar { objetivo, intento } =
    let
        letrasObjetivo =
            Palabra.aLetras objetivo

        letrasIntento =
            Palabra.aLetras intento

        parejas =
            List.map2 Tuple.pair letrasIntento letrasObjetivo

        inventario =
            parejas
                |> List.filter (\( i, o ) -> i /= o)
                |> List.map Tuple.second
                |> contar
    in
    segundaPasada inventario parejas


{-| Primera pasada implícita en `parejas`: si la letra del intento
coincide con la del objetivo en la misma posición, es `Correcta` y no
consume inventario. El resto se resuelve aquí, gastando el inventario
de izquierda a derecha.
-}
segundaPasada : Dict Char Int -> List ( Char, Char ) -> List LetraEvaluada
segundaPasada inventario parejas =
    case parejas of
        [] ->
            []

        ( intento, objetivo ) :: resto ->
            if intento == objetivo then
                LetraEvaluada intento Correcta
                    :: segundaPasada inventario resto

            else if disponible intento inventario then
                LetraEvaluada intento PosicionIncorrecta
                    :: segundaPasada (consumir intento inventario) resto

            else
                LetraEvaluada intento Ausente
                    :: segundaPasada inventario resto



-- INVENTARIO


contar : List Char -> Dict Char Int
contar letras =
    List.foldl
        (\letra acumulado ->
            Dict.update letra (Maybe.withDefault 0 >> (+) 1 >> Just) acumulado
        )
        Dict.empty
        letras


disponible : Char -> Dict Char Int -> Bool
disponible letra inventario =
    Dict.get letra inventario
        |> Maybe.withDefault 0
        |> (\n -> n > 0)


consumir : Char -> Dict Char Int -> Dict Char Int
consumir letra inventario =
    Dict.update letra (Maybe.map (\n -> n - 1)) inventario
