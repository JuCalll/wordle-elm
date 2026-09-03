module Dominio.Partida exposing
    ( Estado(..)
    , Partida
    , Rechazo(..)
    , actual
    , borrarLetra
    , descripcionRechazo
    , enviar
    , escribirLetra
    , estado
    , intentos
    , intentosRestantes
    , maximoIntentos
    , nueva
    , objetivo
    )

{-| El estado completo de una partida y sus transiciones.

Este módulo no conoce el diccionario ni la interfaz gráfica. Para
validar que un intento sea una palabra real recibe la función que hace
esa comprobación como parámetro, de modo que la lógica del juego no
depende de dónde salen los datos.

-}

import Dominio.Evaluacion as Evaluacion exposing (LetraEvaluada)
import Dominio.Palabra as Palabra exposing (Palabra)


type Estado
    = EnCurso
    | Ganada
    | Perdida


{-| Razones por las que un intento no se puede registrar.
-}
type Rechazo
    = PalabraIncompleta
    | PalabraDesconocida
    | PartidaFinalizada


type Partida
    = Partida Interno


type alias Interno =
    { objetivo : Palabra
    , intentos : List (List LetraEvaluada)
    , actual : List Char
    , estado : Estado
    }


maximoIntentos : Int
maximoIntentos =
    6


nueva : Palabra -> Partida
nueva palabraObjetivo =
    Partida
        { objetivo = palabraObjetivo
        , intentos = []
        , actual = []
        , estado = EnCurso
        }



-- TRANSICIONES


escribirLetra : Char -> Partida -> Partida
escribirLetra caracter (Partida interno) =
    if interno.estado /= EnCurso then
        Partida interno

    else if List.length interno.actual >= Palabra.longitudRequerida then
        Partida interno

    else if not (Palabra.esLetra caracter) then
        Partida interno

    else
        Partida
            { interno | actual = interno.actual ++ [ Char.toLower caracter ] }


borrarLetra : Partida -> Partida
borrarLetra (Partida interno) =
    if interno.estado /= EnCurso then
        Partida interno

    else
        Partida
            { interno
                | actual =
                    interno.actual
                        |> List.take (List.length interno.actual - 1)
            }


{-| Intenta registrar la palabra que el jugador tiene escrita.

El primer parámetro decide si una palabra es aceptable. En producción
será `Datos.Diccionario.contiene`; en las pruebas, cualquier función
que sirva al caso.

-}
enviar : (Palabra -> Bool) -> Partida -> Result Rechazo Partida
enviar estaEnDiccionario (Partida interno) =
    if interno.estado /= EnCurso then
        Err PartidaFinalizada

    else
        case Palabra.desdeTexto (String.fromList interno.actual) of
            Err _ ->
                Err PalabraIncompleta

            Ok intento ->
                if not (estaEnDiccionario intento) then
                    Err PalabraDesconocida

                else
                    Ok (registrar intento interno)



-- CONSULTAS


estado : Partida -> Estado
estado (Partida interno) =
    interno.estado


objetivo : Partida -> Palabra
objetivo (Partida interno) =
    interno.objetivo


intentos : Partida -> List (List LetraEvaluada)
intentos (Partida interno) =
    interno.intentos


actual : Partida -> List Char
actual (Partida interno) =
    interno.actual


intentosRestantes : Partida -> Int
intentosRestantes (Partida interno) =
    maximoIntentos - List.length interno.intentos


descripcionRechazo : Rechazo -> String
descripcionRechazo rechazo =
    case rechazo of
        PalabraIncompleta ->
            "Faltan letras."

        PalabraDesconocida ->
            "Esa palabra no está en el diccionario."

        PartidaFinalizada ->
            "La partida ya terminó."



-- INTERNO


registrar : Palabra -> Interno -> Partida
registrar intento interno =
    let
        evaluacion =
            Evaluacion.evaluar
                { objetivo = interno.objetivo, intento = intento }

        historial =
            interno.intentos ++ [ evaluacion ]

        acerto =
            Palabra.aTexto intento == Palabra.aTexto interno.objetivo
    in
    Partida
        { interno
            | intentos = historial
            , actual = []
            , estado = siguienteEstado acerto (List.length historial)
        }


siguienteEstado : Bool -> Int -> Estado
siguienteEstado acerto cantidadIntentos =
    if acerto then
        Ganada

    else if cantidadIntentos >= maximoIntentos then
        Perdida

    else
        EnCurso
