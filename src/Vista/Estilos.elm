module Vista.Estilos exposing
    ( acento
    , borde
    , colorDeEstado
    , colorTexto
    , fondo
    , superficie
    , tenue
    )

{-| Paleta y tokens visuales del juego.

Centralizar los colores aquí evita que los valores se repartan por
todas las vistas. Es el equivalente visual del principio de
responsabilidad única: un solo módulo decide cómo se ve el juego.

-}

import Dominio.Evaluacion exposing (Estado(..))


fondo : String
fondo =
    "#121213"


superficie : String
superficie =
    "#1e1e20"


borde : String
borde =
    "#3a3a3c"


acento : String
acento =
    "#565758"


tenue : String
tenue =
    "#818384"


colorTexto : String
colorTexto =
    "#ffffff"


{-| El compilador exige un color para cada variante de `Estado`.
Si mañana se agrega una nueva, este `case` deja de compilar.
-}
colorDeEstado : Estado -> String
colorDeEstado estado =
    case estado of
        Correcta ->
            "#538d4e"

        PosicionIncorrecta ->
            "#b59f3b"

        Ausente ->
            "#3a3a3c"
