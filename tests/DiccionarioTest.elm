module DiccionarioTest exposing (suite)

import Datos.Diccionario as Diccionario
import Dominio.Palabra as Palabra
import Expect
import Set
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Datos.Diccionario"
        [ test "ninguna palabra se pierde al validar" <|
            \_ ->
                -- Si esta prueba falla, alguna entrada de `crudas`
                -- tiene tilde, longitud incorrecta o un carácter raro.
                List.length Diccionario.palabras
                    |> Expect.equal (List.length Diccionario.crudas)
        , test "no hay palabras repetidas" <|
            \_ ->
                Set.size (Set.fromList Diccionario.crudas)
                    |> Expect.equal (List.length Diccionario.crudas)
        , test "el diccionario no está vacío" <|
            \_ ->
                Expect.greaterThan 0 (List.length Diccionario.palabras)
        , test "contiene reconoce una palabra de la lista" <|
            \_ ->
                Palabra.desdeTexto "gatos"
                    |> Result.map Diccionario.contiene
                    |> Expect.equal (Ok True)
        , test "contiene rechaza una palabra que no está" <|
            \_ ->
                Palabra.desdeTexto "xkqzw"
                    |> Result.map Diccionario.contiene
                    |> Expect.equal (Ok False)
        ]
