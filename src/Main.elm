module Main exposing (main)

{-| Punto de entrada de la aplicación.

Este módulo conecta el dominio con la interfaz. No contiene lógica de
juego: toda decisión sobre qué es válido o quién ganó vive en
`Dominio`. Aquí solo se traducen eventos del usuario en mensajes, y
mensajes en nuevos estados.

-}

import Browser
import Browser.Events
import Datos.Diccionario as Diccionario
import Dominio.Palabra as Palabra exposing (Palabra)
import Dominio.Partida as Partida exposing (Partida)
import Html exposing (Html)
import Json.Decode as Decode
import Random
import Vista.Tablero



-- MODELO


type alias Model =
    { partida : Partida
    , aviso : Maybe String
    }


type Msg
    = PalabraSorteada Palabra
    | LetraPresionada Char
    | BorrarPresionado
    | EnviarPresionado
    | PartidaReiniciada
    | TeclaIgnorada


init : () -> ( Model, Cmd Msg )
init _ =
    ( { partida = Partida.nueva Palabra.porDefecto
      , aviso = Nothing
      }
    , sortearPalabra
    )


{-| Un `Cmd` no ejecuta nada. Es la DESCRIPCIÓN de un efecto que el
runtime de Elm llevará a cabo, devolviendo el resultado como un `Msg`.
-}
sortearPalabra : Cmd Msg
sortearPalabra =
    Random.generate PalabraSorteada Diccionario.generador



-- ACTUALIZACIÓN


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PalabraSorteada palabra ->
            ( { partida = Partida.nueva palabra, aviso = Nothing }
            , Cmd.none
            )

        LetraPresionada caracter ->
            ( { model
                | partida = Partida.escribirLetra caracter model.partida
                , aviso = Nothing
              }
            , Cmd.none
            )

        BorrarPresionado ->
            ( { model
                | partida = Partida.borrarLetra model.partida
                , aviso = Nothing
              }
            , Cmd.none
            )

        EnviarPresionado ->
            case Partida.enviar Diccionario.esAceptada model.partida of
                Ok siguiente ->
                    ( { partida = siguiente, aviso = Nothing }
                    , Cmd.none
                    )

                Err rechazo ->
                    ( { model
                        | aviso = Just (Partida.descripcionRechazo rechazo)
                      }
                    , Cmd.none
                    )

        PartidaReiniciada ->
            ( model, sortearPalabra )

        TeclaIgnorada ->
            ( model, Cmd.none )



-- SUSCRIPCIONES


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyDown (Decode.map desdeTecla (Decode.field "key" Decode.string))


desdeTecla : String -> Msg
desdeTecla tecla =
    case tecla of
        "Enter" ->
            EnviarPresionado

        "Backspace" ->
            BorrarPresionado

        otra ->
            case String.uncons otra of
                Just ( caracter, "" ) ->
                    LetraPresionada caracter

                _ ->
                    TeclaIgnorada



-- VISTA


view : Model -> Html Msg
view model =
    Vista.Tablero.ver
        { partida = model.partida
        , aviso = model.aviso
        , alPresionarLetra = LetraPresionada
        , alBorrar = BorrarPresionado
        , alEnviar = EnviarPresionado
        , alReiniciar = PartidaReiniciada
        }



-- PROGRAMA


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
