module Dominio.Teclado exposing
    ( disposicion
    , estados
    )

{-| El estado visual del teclado.

Este módulo no guarda nada: deriva el color de cada tecla a partir del
historial de intentos. Así el teclado no puede desincronizarse del
tablero, porque ambos leen la misma fuente.

Cuando una letra aparece con estados distintos en intentos distintos,
se conserva el mejor: verde gana sobre amarillo, y amarillo sobre gris.

-}

import Dict exposing (Dict)
import Dominio.Evaluacion exposing (Estado(..), LetraEvaluada)


{-| Distribución QWERTY en español, con la ñ en su lugar habitual.
-}
disposicion : List (List Char)
disposicion =
    [ String.toList "qwertyuiop"
    , String.toList "asdfghjklñ"
    , String.toList "zxcvbnm"
    ]


estados : List (List LetraEvaluada) -> Dict Char Estado
estados historial =
    historial
        |> List.concat
        |> List.foldl acumular Dict.empty



-- INTERNO


acumular : LetraEvaluada -> Dict Char Estado -> Dict Char Estado
acumular evaluada mapa =
    Dict.update evaluada.letra (conservarMejor evaluada.estado) mapa


conservarMejor : Estado -> Maybe Estado -> Maybe Estado
conservarMejor nuevo anterior =
    case anterior of
        Nothing ->
            Just nuevo

        Just previo ->
            if prioridad nuevo > prioridad previo then
                Just nuevo

            else
                Just previo


{-| Orden de preferencia entre estados. Al ser un `case` sobre un tipo
cerrado, agregar un estado nuevo en el futuro obliga al compilador a
exigir su prioridad aquí.
-}
prioridad : Estado -> Int
prioridad estado =
    case estado of
        Ausente ->
            0

        PosicionIncorrecta ->
            1

        Correcta ->
            2
