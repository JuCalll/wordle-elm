module Dominio.Palabra exposing
    ( Error(..)
    , Palabra
    , aLetras
    , aTexto
    , descripcionError
    , desdeTexto
    , longitudRequerida
    )

{-| Representa una palabra válida del juego: exactamente cinco letras
del alfabeto español, sin tildes.

La única forma de obtener una `Palabra` es a través de `desdeTexto`,
que valida la entrada. Si tienes una `Palabra` en las manos, es válida.

-}

import Set exposing (Set)


{-| Tipo opaco: el constructor no se expone, así que ningún otro módulo
puede fabricar una `Palabra` saltándose la validación.
-}
type Palabra
    = Palabra (List Char)


type Error
    = LongitudIncorrecta Int
    | CaracterNoValido Char


longitudRequerida : Int
longitudRequerida =
    5


{-| Constructor inteligente. Normaliza a minúsculas y valida.
-}
desdeTexto : String -> Result Error Palabra
desdeTexto texto =
    let
        letras =
            texto
                |> String.trim
                |> String.toLower
                |> String.toList
    in
    if List.length letras /= longitudRequerida then
        Err (LongitudIncorrecta (List.length letras))

    else
        case List.filter (not << esLetraValida) letras of
            invalida :: _ ->
                Err (CaracterNoValido invalida)

            [] ->
                Ok (Palabra letras)


aTexto : Palabra -> String
aTexto (Palabra letras) =
    String.fromList letras


aLetras : Palabra -> List Char
aLetras (Palabra letras) =
    letras


descripcionError : Error -> String
descripcionError error =
    case error of
        LongitudIncorrecta n ->
            "La palabra debe tener "
                ++ String.fromInt longitudRequerida
                ++ " letras, y tiene "
                ++ String.fromInt n
                ++ "."

        CaracterNoValido caracter ->
            "El carácter '"
                ++ String.fromChar caracter
                ++ "' no es una letra válida."



-- INTERNO


esLetraValida : Char -> Bool
esLetraValida caracter =
    Set.member caracter alfabeto


alfabeto : Set Char
alfabeto =
    "abcdefghijklmnñopqrstuvwxyz"
        |> String.toList
        |> Set.fromList
