# Wordle en Elm — Guía de construcción para tres personas

Guía completa para levantar el proyecto desde cero: instalación, Git colaborativo
y todo el código comentado línea por línea.

**Nivel asumido:** ninguno de los tres conoce Elm. Toda la sintaxis se explica
la primera vez que aparece.

**Duración estimada:** entre 4 y 6 horas, repartidas en 6 rondas de trabajo.

---

## Índice

- [Cómo usar esta guía](#cómo-usar-esta-guía)
- [Parte 0 — Instalación del entorno](#parte-0--instalación-del-entorno)
- [Parte 1 — El repositorio y el reparto del trabajo](#parte-1--el-repositorio-y-el-reparto-del-trabajo)
- [Parte 2 — Sintaxis mínima de Elm](#parte-2--sintaxis-mínima-de-elm)
- [Ronda 1 — Palabra (los tres juntos)](#ronda-1--palabra-los-tres-juntos)
- [Ronda 2 — Evaluación, Diccionario y Estadísticas](#ronda-2--evaluación-diccionario-y-estadísticas)
- [Ronda 3 — Partida, Teclado y Almacenamiento](#ronda-3--partida-teclado-y-almacenamiento)
- [Ronda 4 — Las vistas](#ronda-4--las-vistas)
- [Ronda 5 — Main y el HTML (los tres juntos)](#ronda-5--main-y-el-html-los-tres-juntos)
- [Anexos](#anexos)

---

## Cómo usar esta guía

El proyecto está partido en **rondas**. Cada ronda tiene tres tareas
independientes, una por persona, que se pueden hacer al mismo tiempo sin
pisarse. Al final de cada ronda todo el mundo sincroniza y pasa a la siguiente.

A los tres integrantes los llamamos **A**, **B** y **C**. Repártanselos al
principio y no los cambien, porque las tareas de cada ronda están pensadas
para que nadie toque el archivo de otro.

Los bloques marcados así explican sintaxis nueva de Elm:

> **Sintaxis nueva:** aquí se explica un símbolo o construcción que aparece por
> primera vez.

Y estos marcan la conexión con la materia:

> **En clase vimos:** relación con las diapositivas del curso.

---

## Parte 0 — Instalación del entorno

Esto lo hace **cada uno en su computador**. Si alguien ya lo tiene, que salte
a la sección que le falte.

### 0.1 Node.js — cuidado con la versión

Elm no necesita Node para funcionar, pero sus herramientas sí, y aquí hay una
trampa que ya nos costó una hora.

**Instala Node 20 LTS, no la última versión.** Con Node 24, la herramienta
`elm-test` falla con un error críptico (`ENOENT ... elmTestOutput.js`) aunque
el código esté perfecto.

Descarga la versión **20.x LTS** de [nodejs.org](https://nodejs.org) e
instálala con las opciones por defecto.

Verifica en una terminal nueva:

```powershell
node --version
npm --version
```

Debe responder algo que empiece por `v20.`

> **Si ya tienes Node 24 instalado:** la forma limpia de tener varias versiones
> es `nvm-windows`. Desinstala Node, instala nvm-windows desde su página de
> GitHub, y luego `nvm install 20` y `nvm use 20`.

### 0.2 Elm y sus herramientas

Con Node listo, en una terminal:

```powershell
npm install -g elm elm-format elm-test
```

- **elm** — el compilador. Traduce tu código a JavaScript.
- **elm-format** — formatea el código automáticamente. Deja de discutir sobre
  espacios y comas.
- **elm-test** — ejecuta las pruebas.

Verifica:

```powershell
elm --version        # debe decir 0.19.1
elm-format --help
elm-test --version   # debe empezar por 0.19.1
```

> Si `elm --version` no responde, cierra y vuelve a abrir la terminal: el PATH
> se actualiza solo al abrir una nueva.

### 0.3 IntelliJ IDEA y el plugin

1. Instala **IntelliJ IDEA Community** (gratuita) desde jetbrains.com.
   Con correo universitario también puedes pedir Ultimate gratis, pero no hace
   falta.

2. Abre IntelliJ y ve a `Settings > Plugins > Marketplace`. Busca **"Elm"** e
   instala el que se llama **"Elm Language"**, de *Elm Tooling*.

   > **Importante:** hay varios plugins de Elm en el Marketplace y los otros
   > están abandonados. Si tienes más de uno instalado, el IDE puede negarse a
   > arrancar con un error que no parece tener relación. Instala solo ese.

3. Reinicia el IDE.

4. Ve a `Settings > Languages & Frameworks > Elm` y confirma que detectó las
   rutas de `elm`, `elm-format` y `elm-test`. Activa también el formateo
   automático al guardar: te va a ahorrar la mitad de los errores de sintaxis.

### 0.4 Git

Si no lo tienen, instálenlo desde [git-scm.com](https://git-scm.com).
Después, **cada uno** configura su identidad:

```powershell
git config --global user.name "Su Nombre"
git config --global user.email "sucorreo@ejemplo.com"
git config --global init.defaultBranch main
git config --global core.editor notepad
```

Las dos últimas líneas evitan dos problemas concretos: que Git cree la rama
como `master` en lugar de `main`, y que abra el editor Vim cuando pida un
mensaje de commit (salir de Vim sin saber cómo es un clásico).

### 0.5 Una advertencia sobre dónde guardar el proyecto

**No pongan la carpeta del proyecto dentro de OneDrive, Google Drive o
Dropbox.** La sincronización en tiempo real puede mover archivos justo cuando
Git o el compilador los están usando, y produce errores muy difíciles de
diagnosticar.

Usen algo como `C:\dev\wordle-elm` o `C:\Users\SuUsuario\Proyectos\wordle-elm`.

---

## Parte 1 — El repositorio y el reparto del trabajo

### 1.1 Reparto por rondas

| Ronda | Integrante A | Integrante B | Integrante C |
|---|---|---|---|
| 1 | *Los tres juntos:* `Dominio/Palabra.elm` | | |
| 2 | `Dominio/Evaluacion.elm` | `Datos/Diccionario.elm` | `Dominio/Estadisticas.elm` |
| 3 | `Dominio/Partida.elm` | `Dominio/Teclado.elm` | `Datos/Almacenamiento.elm` + `Vista/Estilos.elm` |
| 4 | `Vista/TecladoVirtual.elm` | `Vista/Tablero.elm` | `Vista/Estadisticas.elm` |
| 5 | *Los tres juntos:* `Main.elm` + `index.html` | | |

**Por qué este orden.** Los módulos tienen dependencias: `Evaluacion` necesita
`Palabra`, `Partida` necesita `Evaluacion`, y así. Dentro de cada ronda, las
tres tareas son independientes entre sí y solo dependen de rondas anteriores.
Por eso pueden trabajar en paralelo sin bloquearse.

**Regla de oro:** nadie edita un archivo que no le tocó. Si necesitas algo de
otro módulo, ya está en `main` porque se fusionó en la ronda anterior.

### 1.2 Estructura final del proyecto

```
wordle-elm/
├── elm.json                    configuración y dependencias
├── index.html                  la página que carga el juego
├── .gitignore
├── src/
│   ├── Main.elm                conecta todo; único módulo con ports
│   ├── Dominio/                la lógica del juego (no sabe que existe HTML)
│   │   ├── Palabra.elm
│   │   ├── Evaluacion.elm
│   │   ├── Partida.elm
│   │   ├── Teclado.elm
│   │   └── Estadisticas.elm
│   ├── Datos/                  datos y traducción hacia afuera
│   │   ├── Diccionario.elm
│   │   └── Almacenamiento.elm
│   └── Vista/                  todo lo que pinta (no calcula nada)
│       ├── Estilos.elm
│       ├── Tablero.elm
│       ├── TecladoVirtual.elm
│       └── Estadisticas.elm
└── tests/                      una prueba por módulo de dominio
    ├── PalabraTest.elm
    ├── EvaluacionTest.elm
    ├── DiccionarioTest.elm
    ├── PartidaTest.elm
    ├── TecladoTest.elm
    └── EstadisticasTest.elm
```

Esa separación en tres carpetas es el corazón del diseño: **`Dominio` no
importa nada de `Vista`**. Se puede probar entero sin abrir un navegador.

### 1.3 Solo el integrante A: crear el repositorio

```powershell
mkdir C:\dev\wordle-elm
cd C:\dev\wordle-elm
elm init
```

`elm init` pregunta si crea `elm.json`; responde `y`. Eso genera el archivo de
configuración y la carpeta `src/`.

Instala las dependencias que vamos a necesitar:

```powershell
elm install elm/random
elm install elm/json
```

Crea las carpetas:

```powershell
mkdir src\Dominio, src\Datos, src\Vista
```

Prepara las pruebas:

```powershell
elm-test init
```

Eso crea `tests/` con un archivo de ejemplo. **Bórralo**, porque vamos a poner
los nuestros:

```powershell
Remove-Item tests\Example.elm -ErrorAction SilentlyContinue
```

Crea el archivo `.gitignore` en la raíz con este contenido:

```
elm-stuff/
elm.js
dist/
.idea/
*.iml
```

- `elm-stuff/` son artefactos de compilación, se regeneran solos.
- `elm.js` es la salida del compilador, no código fuente.
- `.idea/` es la configuración local de IntelliJ de cada uno.

Primer commit y subida:

```powershell
git init
git add .
git commit -m "chore: inicializa proyecto Elm con estructura de carpetas"
git branch -M main
```

Ahora, en GitHub: crea un repositorio **vacío** (sin README, sin .gitignore)
llamado `wordle-elm`. Copia la URL y:

```powershell
git remote add origin https://github.com/TU_USUARIO/wordle-elm.git
git push -u origin main
```

Por último, invita a los otros dos: en el repositorio, `Settings > Collaborators
> Add people`, con sus usuarios de GitHub. Ellos reciben un correo y deben
aceptar la invitación.

### 1.4 Integrantes B y C: clonar

Una vez aceptada la invitación:

```powershell
cd C:\dev
git clone https://github.com/USUARIO_DE_A/wordle-elm.git
cd wordle-elm
```

Ábranlo en IntelliJ con `File > Open` y seleccionando la carpeta `wordle-elm`.
No usen `File > New Project`: IntelliJ no tiene plantilla de Elm.

### 1.5 La receta de cada ronda

Este ciclo se repite **cinco veces**, una por ronda. Apréndanselo, porque es
el flujo real de trabajo en equipo.

**Al empezar tu tarea:**

```powershell
git checkout main          # vuelve a la rama principal
git pull                   # baja lo que fusionaron los demás
git checkout -b feat/nombre-de-tu-modulo    # crea tu rama
```

**Mientras trabajas**, guarda avances cuando termines algo coherente:

```powershell
git add .
git commit -m "feat: descripcion corta de lo que hiciste"
```

**Al terminar:**

```powershell
elm-test                   # que pasen las pruebas
git push -u origin feat/nombre-de-tu-modulo
```

Y en GitHub: entra al repositorio, aparece una franja con
**"Compare & pull request"**. Ábrelo, escribe dos líneas explicando qué hace
tu módulo, y créalo.

**La revisión.** Aquí está la parte valiosa de trabajar entre tres: **otro
integrante** entra al PR, mira la pestaña *Files changed*, y deja al menos un
comentario o una aprobación. No es burocracia: es la única forma de que los
tres entiendan todo el código, y mañana van a exponer los tres.

Cuando esté aprobado, quien abrió el PR le da **Merge pull request**, y
acepta borrar la rama.

**Cuando los tres terminaron la ronda**, todos hacen:

```powershell
git checkout main
git pull
```

Y arranca la ronda siguiente.

### 1.6 Convención de mensajes de commit

Usamos **Conventional Commits**, que es el estándar más extendido:

| Prefijo | Cuándo |
|---|---|
| `feat:` | funcionalidad nueva |
| `fix:` | corrección de un error |
| `refactor:` | reorganizar sin cambiar el comportamiento |
| `test:` | agregar o arreglar pruebas |
| `docs:` | documentación |
| `chore:` | configuración, dependencias, mantenimiento |

El historial queda legible: `git log --oneline` cuenta la historia del
proyecto por funcionalidades.

### 1.7 Si aparece un conflicto

Con este reparto es improbable, porque nadie toca el archivo de otro. Pero si
dos personas modifican `elm.json` en la misma ronda, puede pasar.

Git marca el archivo así:

```
<<<<<<< HEAD
lo que hay en tu rama
=======
lo que venía de main
>>>>>>> main
```

Se resuelve **a mano**: borras las tres líneas de marcas y dejas el contenido
correcto, que casi siempre es la unión de ambos. Luego:

```powershell
git add archivo-en-conflicto
git commit
```

No entren en pánico: un conflicto no rompe nada, solo pide que un humano
decida.

---

## Parte 2 — Sintaxis mínima de Elm

**Lean esto antes de escribir una sola línea.** Son quince minutos que ahorran
dos horas de confusión.

### La idea que lo explica todo

En Elm **no hay instrucciones, solo expresiones**. Nada "se ejecuta para
cambiar algo": todo *produce un valor*. No existe la asignación, no existen los
ciclos, y una vez que un nombre queda amarrado a un valor, no se puede cambiar.

Si vienen de Java o C, el reflejo de "guardo esto en una variable y luego la
modifico" no funciona aquí. En su lugar: **construyes un valor nuevo a partir
del anterior**.

### Definiciones y tipos

```elm
edad : Int
edad =
    20
```

La primera línea es la **anotación de tipo**: se lee "edad es un Int". La
segunda y tercera son la definición. El compilador puede deducir los tipos
solo, pero escribirlos es obligatorio por convención: son la mejor
documentación que existe.

`edad` **no es una variable**: no se puede reasignar. Escribir `edad = 21` más
abajo es un error de compilación.

### Funciones

```elm
sumar : Int -> Int -> Int
sumar a b =
    a + b
```

La anotación se lee: "recibe un Int, recibe otro Int, devuelve un Int". Las
flechas separan los parámetros; **la última es siempre el resultado**.

Y se llaman **sin paréntesis ni comas**:

```elm
sumar 2 3        -- da 5
```

Los paréntesis solo se usan para agrupar:

```elm
sumar 2 (sumar 3 4)      -- da 9
```

### Tipos básicos

| Tipo | Ejemplo |
|---|---|
| `Int` | `42` |
| `Float` | `3.14` |
| `String` | `"hola"` (comillas dobles) |
| `Char` | `'a'` (comillas simples) |
| `Bool` | `True`, `False` (con mayúscula) |
| `List Int` | `[ 1, 2, 3 ]` |
| `( Int, String )` | `( 1, "uno" )` — una tupla |

### `if` es una expresión

```elm
mayorDeEdad : Int -> String
mayorDeEdad años =
    if años >= 18 then
        "adulto"

    else
        "menor"
```

El `else` es **obligatorio**, y las dos ramas deben devolver el mismo tipo.
No existe un `if` sin `else`, porque una expresión siempre tiene que producir
un valor.

### `let ... in` para nombres locales

```elm
areaCirculo : Float -> Float
areaCirculo radio =
    let
        pi =
            3.1416

        cuadrado =
            radio * radio
    in
    pi * cuadrado
```

Lo que se define entre `let` e `in` solo existe dentro de esa función.

### Registros

Son como los `record` de Pascal o los objetos sin métodos:

```elm
type alias Persona =
    { nombre : String
    , edad : Int
    }

juan : Persona
juan =
    { nombre = "Juan", edad = 20 }

juan.nombre        -- "Juan"
```

`type alias` no crea un tipo nuevo: le pone un nombre corto a una forma.

**Actualizar un registro** tiene sintaxis propia:

```elm
mayor =
    { juan | edad = 21 }
```

Se lee: "un registro igual a `juan`, pero con `edad` valiendo 21".
**No modifica `juan`**: crea uno nuevo. `juan.edad` sigue siendo 20.

> **En clase vimos:** esto se parece a la actualización selectiva de Pascal
> (`unafecha.dia := 10`), pero es lo contrario. Aquí no se toca ninguna celda:
> se construye un valor nuevo. Es la regla del "todo o nada" de los
> almacenables, con sintaxis cómoda.

### Tipos personalizados

Son la herramienta más potente del lenguaje:

```elm
type Estado
    = Correcta
    | PosicionIncorrecta
    | Ausente
```

`Estado` es un tipo nuevo con exactamente tres valores posibles. `Correcta`,
`PosicionIncorrecta` y `Ausente` se llaman **constructores**.

Las variantes pueden llevar datos:

```elm
type Error
    = LongitudIncorrecta Int
    | CaracterNoValido Char
```

`LongitudIncorrecta 3` es un valor de tipo `Error` que lleva un número dentro.

### `case ... of` — desarmar valores

```elm
descripcion : Estado -> String
descripcion estado =
    case estado of
        Correcta ->
            "verde"

        PosicionIncorrecta ->
            "amarillo"

        Ausente ->
            "gris"
```

El compilador **exige que cubras todas las variantes**. Si mañana agregas una
cuarta, este `case` deja de compilar hasta que decidas qué hacer con ella. Eso
no es una molestia: es la garantía de que no hay casos olvidados.

Cuando la variante lleva datos, el `case` los extrae:

```elm
case error of
    LongitudIncorrecta n ->
        "tiene " ++ String.fromInt n ++ " letras"

    CaracterNoValido c ->
        "el carácter " ++ String.fromChar c ++ " no vale"
```

### `Maybe` y `Result` — el fin de los nulos

En Elm **no existe `null`**. Cuando algo puede faltar, se dice en el tipo:

```elm
type Maybe a
    = Just a
    | Nothing
```

`Dict.get 'x' miDiccionario` devuelve `Maybe Int`: o `Just 5`, o `Nothing`.
No puedes usar el número sin antes decidir qué pasa si no está.

Y cuando algo puede fallar **con una razón**:

```elm
type Result error valor
    = Ok valor
    | Err error
```

Es exactamente el mismo mecanismo que `Array.get` devolviendo `Maybe`: el
error deja de ser una excepción y pasa a ser un dato que alguien tiene que
atender.

### Listas y el operador `::`

```elm
[ 1, 2, 3 ]              -- una lista
1 :: [ 2, 3 ]            -- lo mismo: pone el 1 al frente
[ 1, 2 ] ++ [ 3, 4 ]     -- concatena: [1,2,3,4]
```

`::` se lee "cons" y sirve tanto para construir como para **desarmar** en un
`case`:

```elm
case lista of
    [] ->
        "vacía"

    primero :: resto ->
        "empieza con algo y le sigue una cola"
```

Esa es la base de la recursión sobre listas, que reemplaza a los ciclos.

### Los operadores que más van a ver

| Operador | Nombre | Qué hace |
|---|---|---|
| `\|>` | pipe | `x \|> f` es lo mismo que `f x` |
| `<\|` | pipe inverso | `f <\| x` es lo mismo que `f x` |
| `>>` | composición | `f >> g` es "primero f, luego g" |
| `<<` | composición inversa | `f << g` es "primero g, luego f" |
| `++` | concatenar | listas y textos |
| `::` | cons | agrega al frente de una lista |
| `/=` | distinto | el `!=` de otros lenguajes |

El `|>` es el que más van a usar. Convierte esto:

```elm
Set.fromList (String.toList (String.toLower texto))
```

en esto, que se lee de izquierda a derecha:

```elm
texto
    |> String.toLower
    |> String.toList
    |> Set.fromList
```

### Funciones anónimas

```elm
\x -> x * 2
```

La barra invertida es una lambda. `\_ -> 5` es una función que ignora su
argumento (el guion bajo significa "no me importa este valor").

### Comentarios

```elm
-- comentario de una línea

{- comentario
   de varias líneas -}

{-| Comentario de documentación. Va justo antes de la función y las
herramientas de Elm lo usan para generar documentación.
-}
```

### Módulos

```elm
module Dominio.Palabra exposing (Palabra, desdeTexto)
```

El nombre del módulo **debe coincidir con la ruta del archivo**:
`Dominio.Palabra` vive en `src/Dominio/Palabra.elm`. El `exposing` lista lo
que el resto del proyecto puede usar; lo demás queda privado.

Para importar:

```elm
import Dominio.Palabra as Palabra exposing (Palabra)
```

- `as Palabra` — abrevia el nombre para escribir `Palabra.desdeTexto`.
- `exposing (Palabra)` — trae el tipo directamente, para poder escribir
  `Palabra` en las anotaciones sin prefijo.

### La indentación importa

Elm no usa llaves ni punto y coma. La estructura del código la marca la
indentación, como en Python. Si la indentación está mal, no compila.

**Por eso activen `elm-format` al guardar.** Formatea el archivo solo y les
evita la inmensa mayoría de estos errores.

---

## Ronda 1 — Palabra (los tres juntos)

Esta primera la hacen **los tres mirando la misma pantalla**. Es el módulo más
pequeño y el que fija el estilo de todo lo demás.

Cree la rama uno solo (digamos A), y los otros dos siguen la explicación:

```powershell
git checkout main
git pull
git checkout -b feat/dominio-palabra
```

### Qué resuelve este módulo

Una sola cosa: **garantizar que una palabra del juego no se pueda construir
mal**. Cinco letras, del alfabeto español, sin tildes. Si tienes una `Palabra`
en las manos, ya está validada.

### El archivo: `src/Dominio/Palabra.elm`

```elm
-- El nombre del módulo debe coincidir con la ruta: src/Dominio/Palabra.elm
-- El bloque `exposing` es la lista de lo que sale al exterior.
module Dominio.Palabra exposing
    ( Palabra              -- el TIPO, pero NO su constructor (ver abajo)
    , Error(..)            -- el tipo Error Y sus constructores (eso son los ..)
    , longitudRequerida
    , desdeTexto
    , aTexto
    , aLetras
    , esLetra
    , descripcionError
    , porDefecto
    )

{-| Representa una palabra válida del juego: exactamente cinco letras
del alfabeto español, sin tildes.

La única forma de obtener una `Palabra` es a través de `desdeTexto`,
que valida la entrada. Si tienes una `Palabra`, es válida.

-}

-- Set es un conjunto: sirve para preguntar "¿está este elemento?" rápido.
-- `exposing (Set)` nos deja escribir `Set Char` en las anotaciones.
import Set exposing (Set)


{-| TIPO OPACO. Este es el concepto más importante del módulo.

`Palabra` envuelve una lista de caracteres. Pero como arriba expusimos
`Palabra` y NO `Palabra(..)`, el constructor queda privado: ningún otro
archivo del proyecto puede escribir `Palabra ['x']` y saltarse la validación.

Es el reemplazo de `private` en Elm.
-}
type Palabra
    = Palabra (List Char)


{-| Las dos razones por las que un texto puede no ser una palabra válida.
Cada variante lleva un dato: el número de letras que tenía, o el carácter
que sobraba.
-}
type Error
    = LongitudIncorrecta Int
    | CaracterNoValido Char


{-| Una constante. Se usa en todo el proyecto en lugar del número 5 suelto,
para que cambiar la longitud del juego sea tocar una sola línea.
-}
longitudRequerida : Int
longitudRequerida =
    5


{-| CONSTRUCTOR INTELIGENTE: la única puerta de entrada al tipo.

Recibe texto crudo (lo que el usuario escribió) y devuelve `Ok palabra`
si es válida, o `Err razon` si no lo es.
-}
desdeTexto : String -> Result Error Palabra
desdeTexto texto =
    let
        -- Normalizamos antes de validar, leyendo de arriba hacia abajo:
        letras =
            texto
                |> String.trim      -- quita espacios de los extremos
                |> String.toLower   -- "GATOS" pasa a "gatos"
                |> String.toList    -- "gatos" pasa a ['g','a','t','o','s']
    in
    -- Primera comprobación: la longitud.
    -- `/=` es "distinto de".
    if List.length letras /= longitudRequerida then
        Err (LongitudIncorrecta (List.length letras))

    else
        -- Segunda comprobación: que todos los caracteres sean letras válidas.
        -- `List.filter` se queda con los que cumplen la condición.
        -- `not << esLetra` es "la negación de esLetra", es decir:
        -- nos quedamos con los caracteres que NO son letras válidas.
        case List.filter (not << esLetra) letras of
            -- Si la lista de inválidos tiene al menos un elemento,
            -- `invalida` es el primero y `_` es el resto (que ignoramos).
            invalida :: _ ->
                Err (CaracterNoValido invalida)

            -- Si la lista de inválidos está vacía, todo está bien.
            -- Aquí SÍ podemos usar el constructor `Palabra`, porque estamos
            -- dentro de su propio módulo.
            [] ->
                Ok (Palabra letras)


{-| Convierte de vuelta a texto.

Fíjate en el parámetro: `(Palabra letras)`. Eso es desempaquetado directo
en la firma: como `Palabra` tiene un solo constructor, Elm permite abrirlo
ahí mismo y quedarnos con la lista de dentro.
-}
aTexto : Palabra -> String
aTexto (Palabra letras) =
    String.fromList letras


{-| Devuelve las letras sueltas. Lo va a usar el módulo de evaluación.
-}
aLetras : Palabra -> List Char
aLetras (Palabra letras) =
    letras


{-| Traduce un error a un mensaje para el usuario.

El `case` cubre las dos variantes de `Error`. Si mañana agregamos una
tercera, el compilador va a exigir que la manejemos aquí.
-}
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


{-| Un valor de respaldo.

Hay sitios donde el sistema de tipos exige una `Palabra` y todavía no hay
ninguna disponible (al arrancar la aplicación, antes del sorteo). En vez de
inventar un `null` que no existe en Elm, damos una palabra real.

Este módulo es el único que puede construir una `Palabra` sin pasar por
`desdeTexto`, porque es el dueño del constructor.
-}
porDefecto : Palabra
porDefecto =
    Palabra (String.toList "gatos")


{-| ¿Es este carácter una letra del alfabeto que aceptamos?

La exponemos porque el módulo `Partida` la necesita para filtrar las teclas
que el usuario presiona.
-}
esLetra : Char -> Bool
esLetra caracter =
    Set.member (Char.toLower caracter) alfabeto



-- INTERNO
-- Todo lo que va debajo de aquí NO está en el `exposing` de arriba,
-- así que es privado del módulo.


{-| El alfabeto español sin tildes. La ñ sí está.

Se construye una sola vez y se reutiliza. Un `Set` responde
"¿está este elemento?" mucho más rápido que una lista.
-}
alfabeto : Set Char
alfabeto =
    "abcdefghijklmnñopqrstuvwxyz"
        |> String.toList
        |> Set.fromList
```

> **En clase vimos:**
>
> - **Tipo opaco = encapsulación.** Exponer `Palabra` sin los `(..)` es lo que
>   en Java sería declarar el campo `private`. Los demás módulos dependen de la
>   *interfaz* (las funciones), no de cómo guardamos los datos por dentro. Si
>   mañana cambiamos `List Char` por `Array Char`, solo se toca este archivo.
> - **No hay actualización selectiva.** No existe forma de cambiar la tercera
>   letra de una `Palabra`. Ni siquiera hay sintaxis para intentarlo. Es la
>   regla del "todo o nada" de los almacenables.
> - **El error como valor.** `desdeTexto` devuelve `Result`, no lanza una
>   excepción. El fallo es un dato que el compilador te obliga a atender.

### El archivo: `tests/PalabraTest.elm`

```elm
-- Los módulos de prueba viven en tests/ y su nombre termina en Test.
-- Exponen una sola cosa: `suite`, que es el conjunto de pruebas.
module PalabraTest exposing (suite)

import Dominio.Palabra as Palabra
import Expect            -- las aserciones: Expect.equal, Expect.greaterThan...
import Test exposing (Test, describe, test)


-- `describe` agrupa pruebas y les pone un título.
-- `test "nombre" <| \_ -> ...` define una prueba:
--   el `<|` aplica la función de la derecha,
--   y `\_ ->` es una función que ignora su argumento.
suite : Test
suite =
    describe "Dominio.Palabra"
        [ describe "desdeTexto"
            [ test "acepta una palabra de cinco letras" <|
                \_ ->
                    Palabra.desdeTexto "gatos"
                        -- desdeTexto da un Result; `Result.map` aplica
                        -- `aTexto` solo si el resultado fue Ok.
                        |> Result.map Palabra.aTexto
                        |> Expect.equal (Ok "gatos")
            , test "normaliza mayúsculas y espacios" <|
                \_ ->
                    Palabra.desdeTexto "  GATOS "
                        |> Result.map Palabra.aTexto
                        |> Expect.equal (Ok "gatos")
            , test "acepta la ñ" <|
                \_ ->
                    Palabra.desdeTexto "caños"
                        |> Result.map Palabra.aTexto
                        |> Expect.equal (Ok "caños")
            , test "rechaza palabras de longitud distinta" <|
                \_ ->
                    Palabra.desdeTexto "sol"
                        |> Expect.equal (Err (Palabra.LongitudIncorrecta 3))
            , test "rechaza tildes" <|
                \_ ->
                    -- Esta prueba deja escrita en el código la decisión que
                    -- tomamos sobre las tildes. No es un comentario que
                    -- alguien pueda ignorar: si se rompe, falla la suite.
                    Palabra.desdeTexto "cafés"
                        |> Expect.equal (Err (Palabra.CaracterNoValido 'é'))
            ]
        ]
```

### Comprobar y cerrar la ronda

```powershell
elm-test
```

Deben pasar **5 pruebas**.

```powershell
git add .
git commit -m "feat: agrega tipo opaco Palabra con validacion y pruebas"
git push -u origin feat/dominio-palabra
```

PR en GitHub, que lo revisen los otros dos, merge. Y todos:

```powershell
git checkout main
git pull
```

---

## Ronda 2 — Evaluación, Diccionario y Estadísticas

Los tres módulos de esta ronda son independientes entre sí. Cada uno crea su
rama y trabaja en paralelo.

| Integrante | Archivo | Rama |
|---|---|---|
| A | `src/Dominio/Evaluacion.elm` | `feat/dominio-evaluacion` |
| B | `src/Datos/Diccionario.elm` | `feat/datos-diccionario` |
| C | `src/Dominio/Estadisticas.elm` | `feat/dominio-estadisticas` |

Recuerden empezar siempre con:

```powershell
git checkout main
git pull
git checkout -b feat/su-rama
```

---

### 2A — Evaluación (integrante A)

#### El problema, antes del código

Si la palabra objetivo es **canto** y escribes **salsa**, ¿de qué color va cada
letra?

La respuesta ingenua sería: "si la letra está en el objetivo, píntala
amarilla". **Eso miente.** `salsa` tiene dos eses y `canto` ninguna; tiene dos
aes y `canto` solo una. Pintar las dos aes de amarillo le diría al jugador que
hay dos aes en la palabra.

La regla real de Wordle usa **dos pasadas y un inventario que se gasta**:

1. Primero se marcan los verdes (letra correcta en posición correcta), y esas
   letras se descuentan del inventario disponible.
2. Después, para cada letra restante, se marca amarillo **solo si todavía
   queda** esa letra en el inventario, y se descuenta.

Ese inventario que se agota es toda la dificultad del módulo.

#### El archivo: `src/Dominio/Evaluacion.elm`

```elm
module Dominio.Evaluacion exposing
    ( Estado(..)          -- el tipo Y sus tres constructores
    , LetraEvaluada
    , evaluar
    )

{-| Compara un intento contra la palabra objetivo y decide el estado
de cada letra.
-}

-- Dict es un diccionario clave/valor. Lo usamos como inventario:
-- de la letra 'a' cuántas quedan disponibles.
import Dict exposing (Dict)
import Dominio.Palabra as Palabra exposing (Palabra)


{-| Los tres colores posibles de una casilla.

Al ser un tipo cerrado de tres variantes, es IMPOSIBLE que una letra quede
en un cuarto estado o sin estado.
-}
type Estado
    = Correcta            -- verde
    | PosicionIncorrecta  -- amarillo
    | Ausente             -- gris


{-| Una letra junto con su color.

`type alias` sobre un registro: no es un tipo nuevo, es un nombre corto
para esa forma. Elm genera automáticamente un constructor con el mismo
nombre, así que `LetraEvaluada 'a' Correcta` construye el registro.
-}
type alias LetraEvaluada =
    { letra : Char
    , estado : Estado
    }


{-| La función principal.

Recibe un REGISTRO con dos campos en lugar de dos parámetros sueltos. Así
es imposible confundir el orden y pasar el intento donde va el objetivo:
el compilador exige los nombres.

Fíjate en el parámetro `{ objetivo, intento }`: eso es desestructuración.
Saca los dos campos del registro y los deja disponibles como nombres.
-}
evaluar : { objetivo : Palabra, intento : Palabra } -> List LetraEvaluada
evaluar { objetivo, intento } =
    let
        letrasObjetivo =
            Palabra.aLetras objetivo

        letrasIntento =
            Palabra.aLetras intento

        -- `List.map2` recorre DOS listas a la vez y combina cada par.
        -- `Tuple.pair` los junta en una tupla.
        -- Resultado: [ ('s','c'), ('a','a'), ('l','n'), ... ]
        -- Cada tupla es (letra del intento, letra del objetivo) en esa posición.
        parejas =
            List.map2 Tuple.pair letrasIntento letrasObjetivo

        -- EL INVENTARIO. Aquí está la primera pasada, de forma implícita:
        -- nos quedamos solo con las parejas que NO coinciden (`i /= o`),
        -- tomamos la letra del objetivo de cada una (`Tuple.second`),
        -- y las contamos.
        -- Las que sí coincidían ya se llevaron su verde y no entran aquí.
        inventario =
            parejas
                |> List.filter (\( i, o ) -> i /= o)
                |> List.map Tuple.second
                |> contar
    in
    segundaPasada inventario parejas


{-| La segunda pasada, recorriendo las parejas de izquierda a derecha.

Esta función es RECURSIVA: se llama a sí misma con una lista más corta.
En C esto sería un `while` con un índice; en Elm no hay ciclos.
-}
segundaPasada : Dict Char Int -> List ( Char, Char ) -> List LetraEvaluada
segundaPasada inventario parejas =
    case parejas of
        -- Caso base: no quedan parejas, devolvemos la lista vacía.
        -- Sin este caso, la recursión no terminaría nunca.
        [] ->
            []

        -- Caso recursivo: `(intento, objetivo)` es la primera pareja
        -- y `resto` son las demás.
        ( intento, objetivo ) :: resto ->
            if intento == objetivo then
                -- Verde. No consume inventario, porque esa letra ya se
                -- descontó al construirlo.
                -- El `::` pega este resultado al frente de lo que devuelva
                -- la llamada recursiva.
                LetraEvaluada intento Correcta
                    :: segundaPasada inventario resto

            else if disponible intento inventario then
                -- Amarillo. Y aquí está la clave: pasamos a la siguiente
                -- llamada un inventario CON UNA MENOS de esa letra.
                LetraEvaluada intento PosicionIncorrecta
                    :: segundaPasada (consumir intento inventario) resto

            else
                -- Gris. El inventario pasa igual.
                LetraEvaluada intento Ausente
                    :: segundaPasada inventario resto



-- INVENTARIO (funciones privadas)


{-| Cuenta cuántas veces aparece cada letra.

`List.foldl` recorre la lista acumulando un resultado. Es la iteración
definida: sabe exactamente cuántas vueltas va a dar.

La función que le pasamos recibe (elemento, acumulado) y devuelve
el acumulado nuevo. Empezamos con `Dict.empty`.
-}
contar : List Char -> Dict Char Int
contar letras =
    List.foldl
        (\letra acumulado ->
            -- `Dict.update` recibe la clave y una función que transforma
            -- el valor actual (que es un Maybe, porque puede no existir).
            -- `Maybe.withDefault 0` -> si no existe, cuenta 0
            -- `>> (+) 1`            -> le suma 1
            -- `>> Just`             -> lo vuelve a envolver en Maybe
            Dict.update letra (Maybe.withDefault 0 >> (+) 1 >> Just) acumulado
        )
        Dict.empty
        letras


{-| ¿Queda al menos una de esta letra en el inventario?
-}
disponible : Char -> Dict Char Int -> Bool
disponible letra inventario =
    Dict.get letra inventario     -- devuelve Maybe Int
        |> Maybe.withDefault 0    -- si no está, es 0
        |> (\n -> n > 0)


{-| Gasta una unidad de esa letra.

OJO: no modifica el inventario. Devuelve un diccionario NUEVO con una
unidad menos. El original queda intacto.
-}
consumir : Char -> Dict Char Int -> Dict Char Int
consumir letra inventario =
    Dict.update letra (Maybe.map (\n -> n - 1)) inventario
```

> **En clase vimos:**
>
> - **La recursión reemplaza al ciclo.** `segundaPasada` es una *iteración
>   indefinida*: no sabe cuántas vueltas dará. En C sería un `while`.
> - **Cada llamada tiene su propio inventario.** Como en el ejemplo de la
>   recursión que vimos en clase, donde cada llamada al procedimiento creaba su
>   propia variable local. Aquí son tres o cuatro inventarios distintos
>   conviviendo, uno por nivel de la recursión.
> - **El acumulador no se muta.** `consumir` devuelve un diccionario nuevo. El
>   estado "avanza" pasando de una llamada a la siguiente, no modificando una
>   celda.
> - **`List.foldl` es la iteración definida:** recorre exactamente cinco
>   elementos.

#### El archivo: `tests/EvaluacionTest.elm`

```elm
module EvaluacionTest exposing (suite)

import Dominio.Evaluacion as Evaluacion exposing (Estado(..))
import Dominio.Palabra as Palabra
import Expect
import Test exposing (Test, describe, test)


{-| Función auxiliar para escribir los casos de forma legible.

Recibe dos textos, los convierte en Palabra y devuelve solo la lista de
estados. `List.map .estado` usa el "accesor de campo": `.estado` es una
función que saca ese campo de un registro.
-}
estados : String -> String -> List Estado
estados objetivo intento =
    -- Un `case` sobre una tupla de dos Result: solo seguimos si ambos
    -- salieron Ok.
    case ( Palabra.desdeTexto objetivo, Palabra.desdeTexto intento ) of
        ( Ok o, Ok i ) ->
            Evaluacion.evaluar { objetivo = o, intento = i }
                |> List.map .estado

        -- `_` como patrón significa "cualquier otro caso".
        _ ->
            []


suite : Test
suite =
    describe "Dominio.Evaluacion"
        [ test "acierto total: todas correctas" <|
            \_ ->
                estados "gatos" "gatos"
                    |> Expect.equal
                        [ Correcta, Correcta, Correcta, Correcta, Correcta ]
        , test "sin coincidencias: todas ausentes" <|
            \_ ->
                estados "pluma" "corte"
                    |> Expect.equal
                        [ Ausente, Ausente, Ausente, Ausente, Ausente ]
        , test "letra presente en otra posición" <|
            \_ ->
                estados "gatos" "tigre"
                    |> List.take 1
                    |> Expect.equal [ PosicionIncorrecta ]
        , test "no marca de más una letra repetida en el intento" <|
            \_ ->
                -- 'campo' tiene UNA 'a'. 'araña' tiene TRES.
                -- Solo la primera puede marcarse; las otras dos son grises.
                estados "campo" "araña"
                    |> Expect.equal
                        [ PosicionIncorrecta
                        , Ausente
                        , Ausente
                        , Ausente
                        , Ausente
                        ]
        , test "el verde consume la letra y el amarillo se queda sin ella" <|
            \_ ->
                -- 'canto' tiene UNA 'a', que se lleva el verde en la posición 2.
                -- La 'a' de la posición 4 ya no tiene inventario: gris.
                estados "canto" "banal"
                    |> Expect.equal
                        [ Ausente
                        , Correcta
                        , Correcta
                        , Ausente
                        , Ausente
                        ]
        ]
```

Los dos últimos son los importantes: son exactamente los casos que rompen las
implementaciones ingenuas.

```powershell
elm-test
git add .
git commit -m "feat: agrega evaluacion de intentos con manejo de letras repetidas"
git push -u origin feat/dominio-evaluacion
```

---

### 2B — Diccionario (integrante B)

#### La decisión de diseño

El Wordle original usa **dos listas distintas**:

- Una lista corta de **soluciones**: palabras comunes que pueden salir
  sorteadas. Ahí no queremos rarezas.
- Una lista larga de **palabras aceptadas**: todo lo que el juego admite como
  intento, aunque nunca sea la respuesta.

Si se usa una sola lista, el juego se vuelve incómodo: el jugador tiene que
adivinar *dentro* de las pocas palabras sorteables. Separar las dos
responsabilidades desde el principio nos ahorra un refactor después.

#### El archivo: `src/Datos/Diccionario.elm`

```elm
module Datos.Diccionario exposing
    ( crudas
    , soluciones
    , esSolucion
    , esAceptada
    , generador
    )

{-| La lista de palabras del juego.

Las palabras se guardan como texto plano en `crudas` y se validan al
convertirlas en `soluciones`. La prueba `DiccionarioTest` garantiza que
ninguna entrada se pierda en esa conversión: si alguien agrega una palabra
con tilde, la prueba falla y avisa.

-}

import Dominio.Palabra as Palabra exposing (Palabra)
import Random
import Set


{-| Texto plano, en minúsculas, sin tildes. La ñ sí está permitida.

La lista se escribe con la coma AL PRINCIPIO de cada línea. Es el estilo
estándar de Elm y tiene una ventaja práctica: agregar o quitar una línea
nunca deja una coma huérfana.
-}
crudas : List String
crudas =
    [ "abeja", "abril", "acero", "aguja", "aldea", "altar", "amigo"
    , "ancho", "andar", "arena", "arroz", "avion", "ayuda", "barco"
    , "barro", "bello", "bicho", "blusa", "bolsa", "borde", "botas"
    , "bravo", "breve", "brisa", "broma", "bruja", "bueno", "bulto"
    , "burla", "cabra", "cacao", "cajas", "calor", "campo", "canal"
    , "canto", "capaz", "carne", "carro", "casas", "casco", "cebra"
    , "celda", "cerca", "cerdo", "cesta", "chico", "choza", "cielo"
    , "cifra", "cinco", "circo", "cisne", "claro", "clase", "clave"
    , "clima", "cobre", "colas", "color", "comer", "coral", "corte"
    , "costa", "crear", "crema", "cruce", "crudo", "cruel", "culpa"
    , "curso", "curva", "damas", "danza", "dardo", "datos", "dedos"
    , "delta", "denso", "digno", "dique", "disco", "doble", "dogma"
    , "dolor", "donde", "dosis", "drama", "duelo", "dueño", "dulce"
    , "duque", "echar", "ejote", "enano", "enero", "enojo", "entre"
    , "error", "etapa", "extra", "falda", "falso", "fango", "farol"
    , "fatal", "fauna", "favor", "fecha", "feliz", "fibra", "ficha"
    , "fiera", "filas", "final", "finca", "firma", "flaco", "flete"
    , "flojo", "flora", "fluir", "fobia", "folio", "fondo", "forma"
    , "frase", "freno", "fresa", "fruta", "fuego", "fugaz", "fumar"
    , "funda", "furia", "fusil", "galgo", "ganar", "ganso", "garra"
    , "gasto", "gatos", "gemas", "genio", "gente", "gesto", "girar"
    , "globo", "golfo", "golpe", "gorra", "grado", "grano", "grasa"
    , "grave", "grifo", "grito", "grupo", "guapo", "guiar", "gusto"
    , "haber", "habla", "hacer", "hacha", "hasta", "hebra", "hecho"
    , "helar", "herir", "hielo", "hijos", "hilos", "himno", "hogar"
    , "hojas", "honda", "honor", "horas", "horno", "hotel", "hueco"
    , "hueso", "huevo", "huida", "humor", "hurto", "igual", "impar"
    , "indio", "islas", "istmo", "jaula", "jefes", "joven", "joyas"
    , "juego", "jugar", "junio", "junta", "junto", "jurar", "justo"
    , "labio", "labor", "lanza", "largo", "latir", "lavar", "leche"
    , "legal", "lejos", "lento", "letra", "leyes", "libra", "libre"
    , "libro", "licor", "ligar", "lirio", "lista", "litro", "llama"
    , "llano", "llave", "llena", "lobos", "local", "logro", "lucha"
    , "lucir", "luego", "lugar", "lunes", "macho", "madre", "magia"
    , "malla", "mango", "manos", "manta", "marca", "marco", "marea"
    , "marzo", "mayor", "mecha", "medio", "mejor", "menor", "menos"
    , "mente", "mesas", "metal", "meter", "metro", "miedo", "miles"
    , "milla", "minas", "mirar", "mismo", "mitad", "mixto", "modas"
    , "modos", "mojar", "molde", "moler", "monte", "moral", "morir"
    , "motor", "mover", "mucho", "mudar", "muela", "mujer", "multa"
    , "mundo", "museo", "musgo", "nabos", "nacer", "nadar", "nadie"
    , "naipe", "nariz", "natal", "naval", "negar", "negro", "nevar"
    , "nicho", "nidos", "nieve", "niños", "nivel", "noble", "noche"
    , "norte", "notas", "novia", "nubes", "nudos", "nuevo", "nunca"
    , "obeso", "obras", "ocaso", "oeste", "oigan", "ojear", "oliva"
    , "ollas", "ondas", "opaco", "opera", "orden", "oreja", "otoño"
    , "pacto", "padre", "pagar", "pagos", "palma", "palos", "panal"
    , "panes", "papel", "parar", "pared", "parte", "pasar", "pasos"
    , "pasta", "pasto", "patio", "patos", "pausa", "pecar", "pecho"
    , "pedal", "pedir", "pegar", "peine", "pelar", "pelos", "penal"
    , "perro", "pesar", "pesca", "pesos", "pieza", "pilar", "pinos"
    , "pinza", "pisar", "pisos", "pista", "plato", "playa", "plaza"
    , "pleno", "plomo", "pluma", "pobre", "poder", "poema", "polen"
    , "polvo", "pollo", "poner", "posar", "potro", "pozos", "prado"
    , "presa", "primo", "prisa", "pulga", "pulpo", "pulso", "punta"
    , "punto", "puros", "queda", "quema", "queso", "quien", "quiso"
    , "quita", "rabia", "radio", "ramas", "rampa", "ranas", "rango"
    , "rapaz", "rasgo", "ratas", "rayas", "rayos", "recto", "redes"
    , "regar", "regla", "reina", "reino", "rejas", "reloj", "remar"
    , "remos", "renta", "resta", "retar", "rezar", "ricos", "riego"
    , "rifle", "rigor", "rimar", "riñas", "risas", "ritmo", "rival"
    , "rizos", "robar", "roble", "robos", "rocas", "rojos", "rollo"
    , "ronda", "ropas", "rosal", "rosas", "rubia", "rubor", "rueda"
    , "rugir", "ruido", "rumbo", "rural", "rutas", "sabor", "sacar"
    , "sacos", "sagaz", "salas", "salir", "salsa", "salto", "salud"
    , "salvo", "sanar", "santo", "sapos", "sauce", "secar", "secos"
    , "sedas", "segar", "selva", "sello", "senda", "senos", "señal"
    , "serie", "sesos", "setas", "sexto", "sidra", "siglo", "signo"
    , "silla", "simio", "sitio", "sobre", "socio", "solar", "soles"
    , "sonar", "sopas", "soplo", "sorbo", "sordo", "subir", "sucio"
    , "sudor", "suelo", "sueño", "sumar", "surco", "sutil", "tabla"
    , "tacos", "talco", "talla", "tallo", "tapas", "tapiz", "tarde"
    , "tarea", "tarro", "tazas", "techo", "tejas", "tejer", "telas"
    , "temer", "temor", "tenaz", "tener", "tenis", "tenso", "terco"
    , "tesis", "texto", "tibio", "tigre", "tinta", "tinto", "tirar"
    , "tocar", "todos", "tomar", "tonos", "tonto", "topos", "torre"
    , "torso", "torta", "tosco", "total", "traer", "trago", "traje"
    , "trama", "trapo", "trazo", "trece", "treta", "tribu", "trigo"
    , "tripa", "trono", "tropa", "trozo", "tubos", "tumba", "turba"
    , "turno", "untar", "urbes", "usual", "vacas", "valle", "valor"
    , "vapor", "vasos", "vejez", "velas", "velos", "vello", "venas"
    , "venir", "verbo", "verde", "verja", "verso", "vetar", "viaje"
    , "vibra", "vicio", "vidas", "video", "viejo", "vigor", "villa"
    , "vinos", "virar", "virus", "visor", "vista", "vital", "vivir"
    , "vivos", "volar", "votar", "votos", "vuelo", "yates", "yegua"
    , "yerba", "yerno", "yesos", "yogur", "yunta", "zafra", "zanja"
    , "zarpa", "zonas", "zorro", "zumba", "zurdo"
    ]


{-| Solo las entradas que pasaron la validación.

`List.filterMap` hace dos cosas a la vez: transforma cada elemento y
descarta los que dan `Nothing`.
`Palabra.desdeTexto >> Result.toMaybe` es la composición de dos funciones:
primero valida (dando Result), luego convierte ese Result en Maybe.
-}
soluciones : List Palabra
soluciones =
    List.filterMap (Palabra.desdeTexto >> Result.toMaybe) crudas


{-| ¿Puede esta palabra salir sorteada?
-}
esSolucion : Palabra -> Bool
esSolucion palabra =
    Set.member (Palabra.aTexto palabra) conjunto


{-| ¿Se acepta como intento del jugador?

Hoy aceptamos cualquier palabra bien formada: cinco letras del alfabeto
español sin tildes. Es deliberadamente permisivo, porque exigir la lista
corta haría el juego injugable.

Cuando exista una lista amplia de palabras válidas, se cambia SOLO esta
función. Ni `Partida` ni `Main` se enteran.
-}
esAceptada : Palabra -> Bool
esAceptada _ =
    True


{-| Cómo elegir una palabra al azar.

ATENCIÓN: esto NO elige nada. Es un VALOR que describe un sorteo, como una
receta describe un plato sin cocinarlo. Quien lo ejecuta es el runtime de
Elm, cuando `Main` se lo entrega envuelto en un `Cmd`.

`Random.uniform` recibe un elemento Y una lista, no una lista sola. ¿Por
qué? Porque sortear entre cero opciones no tiene respuesta posible: el tipo
no te deja ni plantear la pregunta.
-}
generador : Random.Generator Palabra
generador =
    case soluciones of
        primera :: resto ->
            Random.uniform primera resto

        [] ->
            Random.constant Palabra.porDefecto



-- INTERNO


{-| Las palabras como conjunto, para que `esSolucion` responda rápido.
-}
conjunto : Set.Set String
conjunto =
    Set.fromList crudas
```

> **En clase vimos:** un generador no genera nada. Es un dato, no una
> instrucción. En C, `rand()` se ejecuta y devuelve un número distinto cada
> vez; en Elm eso es imposible, porque una función pura con la misma entrada
> **debe** dar la misma salida. El no determinismo existe en el juego, pero
> vive **fuera** de nuestro código.

#### El archivo: `tests/DiccionarioTest.elm`

```elm
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
                -- Esta prueba protege los DATOS, no el código. Si alguien
                -- agrega una palabra con tilde o de seis letras, la lista
                -- validada queda más corta que la cruda y la prueba avisa.
                List.length Diccionario.soluciones
                    |> Expect.equal (List.length Diccionario.crudas)
        , test "no hay palabras repetidas" <|
            \_ ->
                -- Un Set descarta duplicados. Si el tamaño del conjunto es
                -- menor que el de la lista, había repetidas.
                Set.size (Set.fromList Diccionario.crudas)
                    |> Expect.equal (List.length Diccionario.crudas)
        , test "la lista de soluciones no está vacía" <|
            \_ ->
                -- `Expect.greaterThan` da mensajes de error mucho más claros
                -- que comparar booleanos con `Expect.equal`.
                Expect.greaterThan 0 (List.length Diccionario.soluciones)
        , test "esSolucion reconoce una palabra de la lista" <|
            \_ ->
                Palabra.desdeTexto "gatos"
                    |> Result.map Diccionario.esSolucion
                    |> Expect.equal (Ok True)
        , test "esSolucion rechaza una palabra que no está" <|
            \_ ->
                Palabra.desdeTexto "xkqzw"
                    |> Result.map Diccionario.esSolucion
                    |> Expect.equal (Ok False)
        , test "esAceptada admite palabras fuera de la lista de soluciones" <|
            \_ ->
                Palabra.desdeTexto "perro"
                    |> Result.map Diccionario.esAceptada
                    |> Expect.equal (Ok True)
        ]
```

```powershell
elm-test
git add .
git commit -m "feat: agrega diccionario de palabras y generador aleatorio"
git push -u origin feat/datos-diccionario
```

---

### 2C — Estadísticas (integrante C)

#### El archivo: `src/Dominio/Estadisticas.elm`

```elm
module Dominio.Estadisticas exposing
    ( Estadisticas
    , Resultado(..)
    , vacias
    , desdePartes
    , registrar
    , jugadas
    , ganadas
    , rachaActual
    , mejorRacha
    , distribucion
    , porcentajeVictorias
    )

{-| Acumulado histórico del jugador.

Tipo opaco, igual que `Palabra`: los contadores solo pueden avanzar a
través de `registrar`, nunca asignarse a mano. Eso hace IMPOSIBLE tener,
por ejemplo, más partidas ganadas que jugadas.

-}

import Dict exposing (Dict)


{-| Tipo opaco que envuelve un registro privado.
-}
type Estadisticas
    = Estadisticas Interno


{-| La forma interna. Al no estar en el `exposing`, nadie fuera del módulo
puede siquiera nombrar este tipo.
-}
type alias Interno =
    { jugadas : Int
    , ganadas : Int
    , rachaActual : Int
    , mejorRacha : Int
    , distribucion : Dict Int Int   -- intento -> cuántas veces se ganó ahí
    }


{-| Cómo terminó una partida.

`Victoria` lleva un dato: en qué intento se ganó (1 a 6). `Derrota` no
lleva nada porque no hay más que decir.
-}
type Resultado
    = Victoria Int
    | Derrota


{-| El punto de partida: un jugador que nunca ha jugado.
-}
vacias : Estadisticas
vacias =
    Estadisticas
        { jugadas = 0
        , ganadas = 0
        , rachaActual = 0
        , mejorRacha = 0
        , distribucion = Dict.empty
        }


{-| Reconstruye unas estadísticas guardadas previamente.

Los negativos se anulan con `max 0`: un dato corrupto en el navegador
(alguien editando el localStorage a mano) no debe producir un estado
imposible.
-}
desdePartes :
    { jugadas : Int
    , ganadas : Int
    , rachaActual : Int
    , mejorRacha : Int
    , distribucion : List ( Int, Int )
    }
    -> Estadisticas
desdePartes partes =
    Estadisticas
        { jugadas = max 0 partes.jugadas
        , ganadas = max 0 partes.ganadas
        , rachaActual = max 0 partes.rachaActual
        , mejorRacha = max 0 partes.mejorRacha
        , distribucion = Dict.fromList partes.distribucion
        }


{-| La única forma de que los contadores avancen.

Recibe cómo terminó la partida y las estadísticas anteriores; devuelve
unas estadísticas NUEVAS. Las anteriores quedan intactas.
-}
registrar : Resultado -> Estadisticas -> Estadisticas
registrar resultado (Estadisticas interno) =
    case resultado of
        Victoria intento ->
            let
                racha =
                    interno.rachaActual + 1
            in
            Estadisticas
                -- Sintaxis de actualización de registro: "igual que
                -- `interno`, pero con estos campos cambiados".
                { interno
                    | jugadas = interno.jugadas + 1
                    , ganadas = interno.ganadas + 1
                    , rachaActual = racha
                    -- La mejor racha solo sube, nunca baja.
                    , mejorRacha = max racha interno.mejorRacha
                    , distribucion =
                        Dict.update intento
                            (Maybe.withDefault 0 >> (+) 1 >> Just)
                            interno.distribucion
                }

        Derrota ->
            Estadisticas
                { interno
                    | jugadas = interno.jugadas + 1
                    -- La derrota corta la racha actual, pero no la mejor.
                    , rachaActual = 0
                }



-- CONSULTAS
-- Cada una desempaqueta el tipo opaco y devuelve un campo. Son la
-- interfaz de solo lectura: desde fuera se puede mirar, no tocar.


jugadas : Estadisticas -> Int
jugadas (Estadisticas interno) =
    interno.jugadas


ganadas : Estadisticas -> Int
ganadas (Estadisticas interno) =
    interno.ganadas


rachaActual : Estadisticas -> Int
rachaActual (Estadisticas interno) =
    interno.rachaActual


mejorRacha : Estadisticas -> Int
mejorRacha (Estadisticas interno) =
    interno.mejorRacha


distribucion : Estadisticas -> Dict Int Int
distribucion (Estadisticas interno) =
    interno.distribucion


{-| El porcentaje de victorias, redondeado.

Fíjate en el caso de cero partidas: sin ese `if`, sería una división por
cero. Devolvemos 0 en vez de reventar.
-}
porcentajeVictorias : Estadisticas -> Int
porcentajeVictorias (Estadisticas interno) =
    if interno.jugadas == 0 then
        0

    else
        round (100 * toFloat interno.ganadas / toFloat interno.jugadas)
```

#### El archivo: `tests/EstadisticasTest.elm`

```elm
module EstadisticasTest exposing (suite)

import Dict
import Dominio.Estadisticas as Estadisticas exposing (Resultado(..))
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Dominio.Estadisticas"
        [ test "arrancan en cero" <|
            \_ ->
                Estadisticas.jugadas Estadisticas.vacias
                    |> Expect.equal 0
        , test "el porcentaje sin partidas es cero, no un error" <|
            \_ ->
                Estadisticas.porcentajeVictorias Estadisticas.vacias
                    |> Expect.equal 0
        , test "una victoria suma jugada, ganada y racha" <|
            \_ ->
                let
                    e =
                        Estadisticas.registrar (Victoria 3) Estadisticas.vacias
                in
                -- Comparamos una tupla de tres valores de una sola vez.
                ( Estadisticas.jugadas e
                , Estadisticas.ganadas e
                , Estadisticas.rachaActual e
                )
                    |> Expect.equal ( 1, 1, 1 )
        , test "una derrota suma jugada pero no ganada" <|
            \_ ->
                let
                    e =
                        Estadisticas.registrar Derrota Estadisticas.vacias
                in
                ( Estadisticas.jugadas e, Estadisticas.ganadas e )
                    |> Expect.equal ( 1, 0 )
        , test "la derrota corta la racha actual" <|
            \_ ->
                -- Encadenamos tres partidas con pipes: cada `registrar`
                -- recibe el resultado del anterior.
                Estadisticas.vacias
                    |> Estadisticas.registrar (Victoria 2)
                    |> Estadisticas.registrar (Victoria 4)
                    |> Estadisticas.registrar Derrota
                    |> Estadisticas.rachaActual
                    |> Expect.equal 0
        , test "la mejor racha se conserva tras una derrota" <|
            \_ ->
                Estadisticas.vacias
                    |> Estadisticas.registrar (Victoria 2)
                    |> Estadisticas.registrar (Victoria 4)
                    |> Estadisticas.registrar Derrota
                    |> Estadisticas.mejorRacha
                    |> Expect.equal 2
        , test "la distribución cuenta el intento de cada victoria" <|
            \_ ->
                Estadisticas.vacias
                    |> Estadisticas.registrar (Victoria 3)
                    |> Estadisticas.registrar (Victoria 3)
                    |> Estadisticas.registrar (Victoria 5)
                    |> Estadisticas.distribucion
                    |> Dict.toList
                    |> Expect.equal [ ( 3, 2 ), ( 5, 1 ) ]
        , test "el porcentaje redondea correctamente" <|
            \_ ->
                -- 1 de 3 es 33.33%, que redondeado da 33.
                Estadisticas.vacias
                    |> Estadisticas.registrar (Victoria 1)
                    |> Estadisticas.registrar Derrota
                    |> Estadisticas.registrar Derrota
                    |> Estadisticas.porcentajeVictorias
                    |> Expect.equal 33
        , test "desdePartes ignora valores negativos" <|
            \_ ->
                Estadisticas.desdePartes
                    { jugadas = -5
                    , ganadas = 2
                    , rachaActual = -1
                    , mejorRacha = 3
                    , distribucion = []
                    }
                    |> Estadisticas.jugadas
                    |> Expect.equal 0
        ]
```

```powershell
elm-test
git add .
git commit -m "feat: agrega acumulado de estadisticas del jugador"
git push -u origin feat/dominio-estadisticas
```

---

### Cierre de la ronda 2

Los tres abren su PR, se revisan entre ellos, y hacen merge **uno por uno**.
Después todos:

```powershell
git checkout main
git pull
elm-test
```

Deben pasar **20 pruebas** (5 + 5 + 6 + ... según lo que hayan escrito). Si a
alguien le falla algo aquí, es porque bajó el trabajo de otro y hay que
mirarlo entre todos: es exactamente lo que pasa en un equipo real.

---

## Ronda 3 — Partida, Teclado y Almacenamiento

| Integrante | Archivo | Rama |
|---|---|---|
| A | `src/Dominio/Partida.elm` | `feat/dominio-partida` |
| B | `src/Dominio/Teclado.elm` | `feat/dominio-teclado` |
| C | `src/Datos/Almacenamiento.elm` y `src/Vista/Estilos.elm` | `feat/almacenamiento-y-estilos` |

---

### 3A — Partida (integrante A)

Este es el módulo central del juego: guarda el estado y define las
transiciones válidas.

#### El archivo: `src/Dominio/Partida.elm`

```elm
module Dominio.Partida exposing
    ( Partida
    , Estado(..)
    , Rechazo(..)
    , maximoIntentos
    , nueva
    , escribirLetra
    , borrarLetra
    , enviar
    , estado
    , objetivo
    , intentos
    , actual
    , intentosRestantes
    , descripcionRechazo
    )

{-| El estado completo de una partida y sus transiciones.

Este módulo NO conoce el diccionario ni la interfaz gráfica. Para validar
que un intento sea una palabra aceptable recibe la función que hace esa
comprobación como parámetro, de modo que la lógica del juego no depende de
dónde salen los datos.

-}

import Dominio.Evaluacion as Evaluacion exposing (LetraEvaluada)
import Dominio.Palabra as Palabra exposing (Palabra)


{-| En qué punto está la partida. Tres estados, ni uno más.
-}
type Estado
    = EnCurso
    | Ganada
    | Perdida


{-| Razones por las que un intento no se puede registrar.

Fíjate en que son datos, no mensajes de texto. El texto se genera aparte
en `descripcionRechazo`, para que la lógica no cargue con el idioma.
-}
type Rechazo
    = PalabraIncompleta
    | PalabraDesconocida
    | PartidaFinalizada


{-| Tipo opaco, el tercero del proyecto. Nadie puede fabricar una partida
en un estado inconsistente.
-}
type Partida
    = Partida Interno


type alias Interno =
    { objetivo : Palabra                    -- la palabra a adivinar
    , intentos : List (List LetraEvaluada)  -- historial ya evaluado
    , actual : List Char                    -- lo que el jugador va escribiendo
    , estado : Estado
    }


maximoIntentos : Int
maximoIntentos =
    6


{-| Arranca una partida con la palabra dada.
-}
nueva : Palabra -> Partida
nueva palabraObjetivo =
    Partida
        { objetivo = palabraObjetivo
        , intentos = []
        , actual = []
        , estado = EnCurso
        }



-- TRANSICIONES
-- Cada una recibe una Partida y devuelve OTRA Partida. La anterior no se
-- modifica: sigue existiendo mientras alguien la referencie.


{-| Agrega una letra a lo que el jugador está escribiendo.

Los tres `if` son guardas: si alguna condición no se cumple, devolvemos la
partida tal cual, sin cambios. Es la forma funcional de "no hacer nada".
-}
escribirLetra : Char -> Partida -> Partida
escribirLetra caracter (Partida interno) =
    if interno.estado /= EnCurso then
        -- La partida ya terminó: se ignora la tecla.
        Partida interno

    else if List.length interno.actual >= Palabra.longitudRequerida then
        -- Ya hay cinco letras escritas: no caben más.
        Partida interno

    else if not (Palabra.esLetra caracter) then
        -- No es una letra del alfabeto (un número, un signo): se ignora.
        Partida interno

    else
        Partida
            -- `++ [ x ]` agrega al FINAL de la lista.
            { interno | actual = interno.actual ++ [ Char.toLower caracter ] }


{-| Quita la última letra escrita.
-}
borrarLetra : Partida -> Partida
borrarLetra (Partida interno) =
    if interno.estado /= EnCurso then
        Partida interno

    else
        Partida
            { interno
                | actual =
                    interno.actual
                        -- `List.take n` se queda con los n primeros.
                        -- Con la longitud menos uno, quita el último.
                        -- Si la lista está vacía, `take -1` da [] sin error.
                        |> List.take (List.length interno.actual - 1)
            }


{-| Intenta registrar la palabra que el jugador tiene escrita.

EL PARÁMETRO MÁS IMPORTANTE DEL PROYECTO es el primero:
`(Palabra -> Bool)`. Es una FUNCIÓN que decide si una palabra es aceptable.

`Partida` no importa el diccionario: lo recibe. En producción le pasaremos
`Datos.Diccionario.esAceptada`; en las pruebas, cualquier función de dos
líneas. Eso es inversión de dependencias sin necesidad de interfaces.

Devuelve `Result Rechazo Partida`: o la partida avanzó, o hay una razón
por la que no.
-}
enviar : (Palabra -> Bool) -> Partida -> Result Rechazo Partida
enviar estaEnDiccionario (Partida interno) =
    if interno.estado /= EnCurso then
        Err PartidaFinalizada

    else
        -- Reusamos la validación de `Palabra`: si lo escrito no forma una
        -- palabra bien construida, es que faltan letras.
        case Palabra.desdeTexto (String.fromList interno.actual) of
            Err _ ->
                Err PalabraIncompleta

            Ok intento ->
                if not (estaEnDiccionario intento) then
                    Err PalabraDesconocida

                else
                    Ok (registrar intento interno)



-- CONSULTAS
-- La interfaz de solo lectura hacia el exterior.


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


{-| Traduce un rechazo a un mensaje para el jugador.
-}
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


{-| Guarda el intento evaluado y decide cómo queda la partida.
-}
registrar : Palabra -> Interno -> Partida
registrar intento interno =
    let
        -- Aquí se usa el módulo del integrante A de la ronda anterior.
        evaluacion =
            Evaluacion.evaluar
                { objetivo = interno.objetivo, intento = intento }

        historial =
            interno.intentos ++ [ evaluacion ]

        -- Comparamos los textos porque `Palabra` no se puede comparar
        -- directamente con `==` de forma fiable en todos los casos.
        acerto =
            Palabra.aTexto intento == Palabra.aTexto interno.objetivo
    in
    Partida
        { interno
            | intentos = historial
            , actual = []    -- se limpia lo escrito
            , estado = siguienteEstado acerto (List.length historial)
        }


{-| La regla de fin de partida, aislada en una función propia para que se
pueda leer de un vistazo.
-}
siguienteEstado : Bool -> Int -> Estado
siguienteEstado acerto cantidadIntentos =
    if acerto then
        Ganada

    else if cantidadIntentos >= maximoIntentos then
        Perdida

    else
        EnCurso
```

> **En clase vimos:**
>
> - **La asignación que no asigna.** `{ interno | actual = ... }` se parece a
>   `unafecha.dia := 10` de Pascal, pero es lo contrario: construye un registro
>   completamente nuevo. Elm presta la sintaxis cómoda sin la semántica
>   peligrosa.
> - **El estado avanza sin mutar.** Cada transición devuelve otra `Partida`. La
>   anterior sigue viva mientras alguien la referencie, y muere cuando el
>   recolector de basura ve que ya nadie la alcanza. Es el mismo mecanismo que
>   las variables del montón que vimos en clase.
> - **Inversión de dependencias.** El primer parámetro de `enviar` es una
>   función. En Java sería una interfaz inyectada por constructor; aquí es un
>   parámetro más.

#### El archivo: `tests/PartidaTest.elm`

```elm
module PartidaTest exposing (suite)

import Dominio.Palabra as Palabra exposing (Palabra)
import Dominio.Partida as Partida exposing (Estado(..), Partida, Rechazo(..))
import Expect
import Test exposing (Test, describe, test)


{-| La palabra objetivo de todas las pruebas.

`Result.withDefault` saca el valor de un Result, y si fue Err usa el
respaldo. Aquí sabemos que "gatos" es válida, así que nunca se usa.
-}
objetivo : Palabra
objetivo =
    Palabra.desdeTexto "gatos"
        |> Result.withDefault Palabra.porDefecto


{-| Diccionario de prueba que acepta cualquier palabra.

Dos líneas. Esto es lo que ganamos al pasar la función como parámetro:
podemos probar `Partida` sin construir ningún diccionario real.
-}
todoVale : Palabra -> Bool
todoVale _ =
    True


{-| Diccionario de prueba que no acepta nada. Para probar el rechazo.
-}
nadaVale : Palabra -> Bool
nadaVale _ =
    False


{-| Escribe un texto letra por letra.

`String.foldl` recorre los caracteres de un texto acumulando un resultado.
Aquí el acumulado es la partida, y cada carácter la hace avanzar.
-}
escribir : String -> Partida -> Partida
escribir texto partida =
    String.foldl Partida.escribirLetra partida texto


{-| Escribe una palabra y la envía. Si el envío es rechazado, deja la
partida como estaba.
-}
jugar : String -> Partida -> Partida
jugar texto partida =
    escribir texto partida
        |> Partida.enviar todoVale
        |> Result.withDefault partida


suite : Test
suite =
    describe "Dominio.Partida"
        [ describe "estado inicial"
            [ test "arranca en curso, sin intentos" <|
                \_ ->
                    Partida.nueva objetivo
                        |> Partida.estado
                        |> Expect.equal EnCurso
            , test "arranca con todos los intentos disponibles" <|
                \_ ->
                    Partida.nueva objetivo
                        |> Partida.intentosRestantes
                        |> Expect.equal Partida.maximoIntentos
            ]
        , describe "escritura"
            [ test "acumula las letras escritas" <|
                \_ ->
                    Partida.nueva objetivo
                        |> escribir "sol"
                        |> Partida.actual
                        |> Expect.equal [ 's', 'o', 'l' ]
            , test "no permite pasar del límite de letras" <|
                \_ ->
                    Partida.nueva objetivo
                        |> escribir "abcdefgh"
                        |> Partida.actual
                        |> List.length
                        |> Expect.equal Palabra.longitudRequerida
            , test "ignora caracteres que no son letras" <|
                \_ ->
                    Partida.nueva objetivo
                        |> escribir "a1b!c"
                        |> Partida.actual
                        |> Expect.equal [ 'a', 'b', 'c' ]
            , test "borrar quita la última letra" <|
                \_ ->
                    Partida.nueva objetivo
                        |> escribir "sol"
                        |> Partida.borrarLetra
                        |> Partida.actual
                        |> Expect.equal [ 's', 'o' ]
            , test "borrar con el buffer vacío no rompe nada" <|
                \_ ->
                    Partida.nueva objetivo
                        |> Partida.borrarLetra
                        |> Partida.actual
                        |> Expect.equal []
            ]
        , describe "envío"
            [ test "rechaza una palabra incompleta" <|
                \_ ->
                    Partida.nueva objetivo
                        |> escribir "sol"
                        |> Partida.enviar todoVale
                        |> Expect.equal (Err PalabraIncompleta)
            , test "rechaza una palabra fuera del diccionario" <|
                \_ ->
                    Partida.nueva objetivo
                        |> escribir "perro"
                        |> Partida.enviar nadaVale
                        |> Expect.equal (Err PalabraDesconocida)
            , test "un envío válido registra el intento" <|
                \_ ->
                    Partida.nueva objetivo
                        |> jugar "perro"
                        |> Partida.intentos
                        |> List.length
                        |> Expect.equal 1
            , test "un envío válido limpia el buffer" <|
                \_ ->
                    Partida.nueva objetivo
                        |> jugar "perro"
                        |> Partida.actual
                        |> Expect.equal []
            ]
        , describe "fin de la partida"
            [ test "acertar la palabra gana" <|
                \_ ->
                    Partida.nueva objetivo
                        |> jugar "gatos"
                        |> Partida.estado
                        |> Expect.equal Ganada
            , test "agotar los intentos pierde" <|
                \_ ->
                    Partida.nueva objetivo
                        |> jugar "perro"
                        |> jugar "casas"
                        |> jugar "libro"
                        |> jugar "mesas"
                        |> jugar "nubes"
                        |> jugar "pluma"
                        |> Partida.estado
                        |> Expect.equal Perdida
            , test "ganar antes del último intento no pierde" <|
                \_ ->
                    Partida.nueva objetivo
                        |> jugar "perro"
                        |> jugar "gatos"
                        |> Partida.estado
                        |> Expect.equal Ganada
            , test "no se puede enviar en una partida terminada" <|
                \_ ->
                    Partida.nueva objetivo
                        |> jugar "gatos"
                        |> escribir "perro"
                        |> Partida.enviar todoVale
                        |> Expect.equal (Err PartidaFinalizada)
            , test "no se puede escribir en una partida terminada" <|
                \_ ->
                    Partida.nueva objetivo
                        |> jugar "gatos"
                        |> escribir "perro"
                        |> Partida.actual
                        |> Expect.equal []
            ]
        ]
```

```powershell
elm-test
git add .
git commit -m "feat: agrega estado de partida con transiciones y validaciones"
git push -u origin feat/dominio-partida
```

---

### 3B — Teclado (integrante B)

#### La decisión de diseño

En Wordle las teclas se van coloreando. La pregunta es dónde guardamos ese
color.

La tentación es agregar un campo a `Partida`. **No lo hacemos.** El color de
una tecla no es información nueva: se puede *calcular* mirando el historial de
intentos, que ya existe. Guardarlo aparte sería tener la misma verdad en dos
lugares, y tarde o temprano se desincronizan.

La regla que falta definir: si una letra salió gris en el intento 1 y verde en
el 3, la tecla queda **verde**. Se conserva el mejor resultado obtenido.

#### El archivo: `src/Dominio/Teclado.elm`

```elm
module Dominio.Teclado exposing
    ( disposicion
    , estados
    )

{-| El estado visual del teclado.

Este módulo NO guarda nada: deriva el color de cada tecla a partir del
historial de intentos. Así el teclado no puede desincronizarse del tablero,
porque ambos leen la misma fuente.

-}

import Dict exposing (Dict)
import Dominio.Evaluacion exposing (Estado(..), LetraEvaluada)


{-| Distribución QWERTY en español, con la ñ en su lugar habitual.

Una lista de listas: cada sublista es una fila del teclado.
-}
disposicion : List (List Char)
disposicion =
    [ String.toList "qwertyuiop"
    , String.toList "asdfghjklñ"
    , String.toList "zxcvbnm"
    ]


{-| Calcula el color de cada tecla usada.

Recibe el historial completo de intentos y devuelve un diccionario
letra -> color. Las letras que nunca se usaron simplemente no aparecen.
-}
estados : List (List LetraEvaluada) -> Dict Char Estado
estados historial =
    historial
        -- `List.concat` aplana la lista de listas en una sola lista
        -- con todas las letras evaluadas de todos los intentos.
        |> List.concat
        -- Y las recorremos acumulando el diccionario.
        |> List.foldl acumular Dict.empty



-- INTERNO


{-| Agrega una letra evaluada al mapa, conservando el mejor estado.
-}
acumular : LetraEvaluada -> Dict Char Estado -> Dict Char Estado
acumular evaluada mapa =
    Dict.update evaluada.letra (conservarMejor evaluada.estado) mapa


{-| Decide qué estado queda cuando ya había uno.

El segundo parámetro es `Maybe Estado` porque la letra puede no estar
todavía en el diccionario.
-}
conservarMejor : Estado -> Maybe Estado -> Maybe Estado
conservarMejor nuevo anterior =
    case anterior of
        Nothing ->
            -- Primera vez que aparece esta letra.
            Just nuevo

        Just previo ->
            if prioridad nuevo > prioridad previo then
                Just nuevo

            else
                Just previo


{-| Orden de preferencia entre estados.

Al ser un `case` sobre un tipo cerrado y sin caso comodín, agregar un
estado nuevo en el futuro obliga al compilador a exigir su prioridad aquí.
Es el principio abierto/cerrado en su forma funcional.
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
```

#### El archivo: `tests/TecladoTest.elm`

```elm
module TecladoTest exposing (suite)

import Dict
import Dominio.Evaluacion exposing (Estado(..), LetraEvaluada)
import Dominio.Teclado as Teclado
import Expect
import Test exposing (Test, describe, test)


{-| Atajo para construir una letra evaluada sin escribir el registro
completo cada vez.
-}
letra : Char -> Estado -> LetraEvaluada
letra caracter estado =
    { letra = caracter, estado = estado }


{-| Atajo para consultar el estado de una tecla.
-}
estadoDe : Char -> List (List LetraEvaluada) -> Maybe Estado
estadoDe caracter historial =
    Teclado.estados historial
        |> Dict.get caracter


suite : Test
suite =
    describe "Dominio.Teclado"
        [ describe "disposición"
            [ test "tiene tres filas" <|
                \_ ->
                    List.length Teclado.disposicion
                        |> Expect.equal 3
            , test "incluye la ñ" <|
                \_ ->
                    List.concat Teclado.disposicion
                        |> List.member 'ñ'
                        |> Expect.equal True
            , test "tiene 27 teclas" <|
                \_ ->
                    List.concat Teclado.disposicion
                        |> List.length
                        |> Expect.equal 27
            ]
        , describe "estados"
            [ test "sin intentos, ninguna tecla tiene estado" <|
                \_ ->
                    Teclado.estados []
                        |> Dict.isEmpty
                        |> Expect.equal True
            , test "registra el estado de una letra usada" <|
                \_ ->
                    estadoDe 'g' [ [ letra 'g' Correcta ] ]
                        |> Expect.equal (Just Correcta)
            , test "una letra no usada no aparece" <|
                \_ ->
                    estadoDe 'z' [ [ letra 'g' Correcta ] ]
                        |> Expect.equal Nothing
            -- Los cuatro casos que siguen cubren todas las combinaciones
            -- que importan, incluyendo el mismo par en orden inverso: así
            -- comprobamos que la regla depende de la prioridad y no del
            -- orden de llegada.
            , test "el verde reemplaza al gris de un intento anterior" <|
                \_ ->
                    estadoDe 'a'
                        [ [ letra 'a' Ausente ]
                        , [ letra 'a' Correcta ]
                        ]
                        |> Expect.equal (Just Correcta)
            , test "el gris no degrada un verde ya obtenido" <|
                \_ ->
                    estadoDe 'a'
                        [ [ letra 'a' Correcta ]
                        , [ letra 'a' Ausente ]
                        ]
                        |> Expect.equal (Just Correcta)
            , test "el amarillo gana al gris" <|
                \_ ->
                    estadoDe 'a'
                        [ [ letra 'a' Ausente ]
                        , [ letra 'a' PosicionIncorrecta ]
                        ]
                        |> Expect.equal (Just PosicionIncorrecta)
            , test "el verde gana al amarillo" <|
                \_ ->
                    estadoDe 'a'
                        [ [ letra 'a' PosicionIncorrecta ]
                        , [ letra 'a' Correcta ]
                        ]
                        |> Expect.equal (Just Correcta)
            ]
        ]
```

```powershell
elm-test
git add .
git commit -m "feat: agrega estado derivado del teclado a partir del historial"
git push -u origin feat/dominio-teclado
```

---

### 3C — Almacenamiento y Estilos (integrante C)

Dos archivos pequeños. El primero traduce las estadísticas a JSON para poder
guardarlas; el segundo centraliza los colores.

#### El archivo: `src/Datos/Almacenamiento.elm`

```elm
module Datos.Almacenamiento exposing (codificar, decodificar)

{-| Traducción entre el dominio y el formato JSON del navegador.

Este módulo solo TRADUCE. Quién envía los datos y por dónde es decisión de
`Main`, que es el único que declara los ports.

(Nota práctica: los ports DEBEN vivir en el módulo raíz de la aplicación.
Si se ponen en un módulo interno, `elm-test` no puede compilar el proyecto
y falla con un error que no explica nada.)

-}

import Dict
import Dominio.Estadisticas as Estadisticas exposing (Estadisticas)
import Json.Decode as Decode
import Json.Encode as Encode


{-| Convierte las estadísticas en un valor JSON listo para salir.

`Encode.object` recibe una lista de parejas (nombre del campo, valor
codificado).
-}
codificar : Estadisticas -> Encode.Value
codificar estadisticas =
    Encode.object
        [ ( "jugadas", Encode.int (Estadisticas.jugadas estadisticas) )
        , ( "ganadas", Encode.int (Estadisticas.ganadas estadisticas) )
        , ( "rachaActual", Encode.int (Estadisticas.rachaActual estadisticas) )
        , ( "mejorRacha", Encode.int (Estadisticas.mejorRacha estadisticas) )
        , ( "distribucion"
          , Estadisticas.distribucion estadisticas
                |> Dict.toList                     -- Dict a lista de parejas
                |> Encode.list parejaCodificada    -- cada pareja a JSON
          )
        ]


{-| Lee unas estadísticas guardadas.

Los datos que vienen del navegador NO son de fiar: pueden faltar, estar
corruptos o haber sido editados a mano. Si algo no cuadra, empezamos de
cero en lugar de romper el programa.

`Result.withDefault` hace exactamente eso: si la decodificación falla,
devuelve `Estadisticas.vacias`.
-}
decodificar : Decode.Value -> Estadisticas
decodificar valor =
    Decode.decodeValue decodificador valor
        |> Result.withDefault Estadisticas.vacias



-- INTERNO


parejaCodificada : ( Int, Int ) -> Encode.Value
parejaCodificada ( intento, cantidad ) =
    Encode.object
        [ ( "intento", Encode.int intento )
        , ( "cantidad", Encode.int cantidad )
        ]


{-| Un decodificador describe CÓMO leer un JSON, no lo lee todavía.

`Decode.map5` combina cinco decodificadores en uno: lee los cinco campos y
le pasa los cinco valores a la función.
-}
decodificador : Decode.Decoder Estadisticas
decodificador =
    Decode.map5
        (\j g r m d ->
            Estadisticas.desdePartes
                { jugadas = j
                , ganadas = g
                , rachaActual = r
                , mejorRacha = m
                , distribucion = d
                }
        )
        (Decode.field "jugadas" Decode.int)
        (Decode.field "ganadas" Decode.int)
        (Decode.field "rachaActual" Decode.int)
        (Decode.field "mejorRacha" Decode.int)
        (Decode.field "distribucion" (Decode.list parejaDecodificada))


parejaDecodificada : Decode.Decoder ( Int, Int )
parejaDecodificada =
    Decode.map2 Tuple.pair
        (Decode.field "intento" Decode.int)
        (Decode.field "cantidad" Decode.int)
```

> **En clase vimos:** el dato externo se valida **en la frontera**, igual que
> `Palabra.desdeTexto` valida el texto del usuario. A partir de ahí, el sistema
> de tipos garantiza que es correcto. En Elm no existe `null`, así que un JSON
> corrupto no puede colarse dentro del programa.

#### El archivo: `src/Vista/Estilos.elm`

```elm
module Vista.Estilos exposing
    ( colorDeEstado
    , colorTexto
    , fondo
    , superficie
    , borde
    , acento
    , tenue
    )

{-| Paleta y medidas del juego.

Centralizar los colores aquí evita que los valores se repartan por todas
las vistas. Si mañana quieren cambiar el tema, tocan un solo archivo.

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


{-| El color de cada estado de casilla.

El compilador exige un color para cada variante de `Estado`. Si mañana se
agrega una cuarta, este `case` deja de compilar hasta que se decida su
color: no se puede olvidar.
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
```

Estos dos módulos no llevan pruebas: `Estilos` son constantes y
`Almacenamiento` se prueba de verdad usando el juego.

```powershell
elm-test
git add .
git commit -m "feat: agrega codificacion de estadisticas y paleta de estilos"
git push -u origin feat/almacenamiento-y-estilos
```

---

### Cierre de la ronda 3

PRs, revisión cruzada, merge. Y todos:

```powershell
git checkout main
git pull
elm-test
```

---

## Ronda 4 — Las vistas

| Integrante | Archivo | Rama |
|---|---|---|
| A | `src/Vista/TecladoVirtual.elm` | `feat/vista-teclado` |
| B | `src/Vista/Tablero.elm` | `feat/vista-tablero` |
| C | `src/Vista/Estadisticas.elm` | `feat/vista-estadisticas` |

### Antes de empezar: el contrato

Aquí hay una novedad respecto a las rondas anteriores. `Tablero` **importa** a
los otros dos módulos, que se están escribiendo al mismo tiempo. Por eso, lo
primero que hacen los tres es **acordar las firmas** y anotarlas:

```elm
-- Vista.TecladoVirtual
ver :
    { estados : Dict Char Estado
    , alPresionarLetra : Char -> msg
    , alBorrar : msg
    , alEnviar : msg
    }
    -> Html msg

-- Vista.Estadisticas
ver : Estadisticas -> Html msg
```

Con eso, B puede escribir `Tablero` sin esperar a nadie: programa contra el
contrato, no contra la implementación. Su rama no compilará sola, y eso es
normal: compilará cuando se fusionen las tres.

> **Esto es exactamente lo que pasa en un equipo real.** Acordar la interfaz
> antes de programar es lo que permite el paralelismo. Vale la pena que lo
> cuenten en la exposición.

### Sintaxis nueva: HTML en Elm

El HTML se escribe como funciones normales. Cada etiqueta recibe **dos
listas**: la de atributos y la de hijos.

```elm
div [ style "color" "red" ] [ text "hola" ]
```

equivale a `<div style="color: red">hola</div>`.

Y fíjense en el tipo `Html msg`, con la `msg` en **minúscula**. Eso es una
*variable de tipo*: significa "funciona con cualquier tipo de mensaje". Estos
módulos no saben que existe `Main` ni cómo se llaman sus mensajes.

> **En clase vimos:** eso es **abstracción genérica**, uno de los conceptos del
> temario. Y también inversión de dependencias: el módulo de bajo nivel no
> conoce al de alto nivel.

---

### 4A — Teclado virtual (integrante A)

```elm
module Vista.TecladoVirtual exposing (ver)

{-| El teclado en pantalla.

Recibe los manejadores como parámetros en lugar de conocer el tipo `Msg`
de la aplicación. Así este módulo es reutilizable y no depende de `Main`.

-}

import Dict exposing (Dict)
import Dominio.Evaluacion exposing (Estado)
import Dominio.Teclado as Teclado
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Vista.Estilos as Estilos


{-| Todo lo que este módulo necesita para pintarse.

Los tres últimos campos son MENSAJES, no funciones que hagan algo: cuando
el usuario haga clic, Elm le entregará ese mensaje a `Main`.
-}
type alias Config msg =
    { estados : Dict Char Estado
    , alPresionarLetra : Char -> msg
    , alBorrar : msg
    , alEnviar : msg
    }


ver : Config msg -> Html msg
ver config =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "gap" "8px"
        , style "align-items" "center"
        , style "margin-top" "24px"
        ]
        -- `List.indexedMap` es como `List.map` pero además pasa el índice
        -- (0, 1, 2...). Lo necesitamos para saber cuál es la última fila.
        (List.indexedMap (verFila config) Teclado.disposicion)


{-| Pinta una fila. La tercera lleva además ENVIAR y borrar.
-}
verFila : Config msg -> Int -> List Char -> Html msg
verFila config indice letras =
    let
        teclasLetra =
            List.map (verTeclaLetra config) letras

        contenido =
            if indice == 2 then
                -- `::` pone ENVIAR al principio, `++ [...]` pone el
                -- borrar al final.
                -- "\u{232B}" es el carácter Unicode de la flecha de borrado.
                (verTeclaAncha "ENVIAR" config.alEnviar :: teclasLetra)
                    ++ [ verTeclaAncha "\u{232B}" config.alBorrar ]

            else
                teclasLetra
    in
    div
        [ style "display" "flex"
        , style "gap" "6px"
        ]
        contenido


{-| Una tecla de letra, con su color según el historial.
-}
verTeclaLetra : Config msg -> Char -> Html msg
verTeclaLetra config letra =
    let
        color =
            Dict.get letra config.estados      -- Maybe Estado
                |> Maybe.map Estilos.colorDeEstado
                -- Si la letra no se ha usado, color neutro.
                |> Maybe.withDefault Estilos.acento
    in
    button
        -- `onClick` produce el mensaje cuando el usuario hace clic.
        -- `::` lo agrega a la lista de estilos.
        (onClick (config.alPresionarLetra letra) :: estiloTecla color 42)
        [ text (String.fromChar letra |> String.toUpper) ]


verTeclaAncha : String -> msg -> Html msg
verTeclaAncha etiqueta mensaje =
    button
        (onClick mensaje :: estiloTecla Estilos.acento 68)
        [ text etiqueta ]


{-| Los estilos comunes de todas las teclas, en un solo sitio.
-}
estiloTecla : String -> Int -> List (Html.Attribute msg)
estiloTecla color ancho =
    [ style "background-color" color
    , style "color" Estilos.colorTexto
    , style "border" "none"
    , style "border-radius" "6px"
    , style "width" (String.fromInt ancho ++ "px")
    , style "height" "54px"
    , style "font-size" "14px"
    , style "font-weight" "bold"
    , style "cursor" "pointer"
    , style "font-family" "inherit"
    ]
```

---

### 4B — Tablero (integrante B)

Es el módulo más largo de la ronda: arma la pantalla completa.

```elm
module Vista.Tablero exposing (ver)

{-| La pantalla completa del juego: título, cuadrícula, avisos y teclado.
-}

import Dominio.Estadisticas exposing (Estadisticas)
import Dominio.Evaluacion exposing (Estado, LetraEvaluada)
import Dominio.Palabra as Palabra
import Dominio.Partida as Partida exposing (Estado(..), Partida)
import Dominio.Teclado as Teclado
import Html exposing (Html, button, div, h1, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Vista.Estadisticas
import Vista.Estilos as Estilos
import Vista.TecladoVirtual


type alias Config msg =
    { partida : Partida
    , aviso : Maybe String
    , alPresionarLetra : Char -> msg
    , alBorrar : msg
    , alEnviar : msg
    , alReiniciar : msg
    , estadisticas : Estadisticas
    }


ver : Config msg -> Html msg
ver config =
    div
        [ style "background-color" Estilos.fondo
        , style "color" Estilos.colorTexto
        , style "min-height" "100vh"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "padding" "16px"
        ]
        [ h1
            [ style "letter-spacing" "4px"
            , style "font-size" "28px"
            , style "margin" "8px 0 20px"
            ]
            [ text "WORDLE" ]
        , verCuadricula config.partida
        , verMensaje config
        , Vista.TecladoVirtual.ver
            -- Aquí se calcula el estado del teclado en el momento de
            -- pintarlo, a partir del historial. No se guarda en ningún lado.
            { estados = Teclado.estados (Partida.intentos config.partida)
            , alPresionarLetra = config.alPresionarLetra
            , alBorrar = config.alBorrar
            , alEnviar = config.alEnviar
            }
        ]



-- CUADRÍCULA


{-| Las seis filas: las jugadas, la que se está escribiendo, y las vacías.
-}
verCuadricula : Partida -> Html msg
verCuadricula partida =
    let
        completadas =
            List.map filaCompletada (Partida.intentos partida)

        -- La fila en edición solo aparece si la partida sigue viva.
        -- Se usa una lista para poder concatenarla: o tiene un elemento
        -- o está vacía.
        enCurso =
            if Partida.estado partida == EnCurso then
                [ filaActual (Partida.actual partida) ]

            else
                []

        -- `List.repeat n x` crea una lista con n copias de x.
        vacias =
            List.repeat (filasVacias partida) filaVacia
    in
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "gap" "6px"
        ]
        (completadas ++ enCurso ++ vacias)


{-| Cuántas filas vacías quedan por debajo.
-}
filasVacias : Partida -> Int
filasVacias partida =
    let
        usadas =
            List.length (Partida.intentos partida)

        enCurso =
            if Partida.estado partida == EnCurso then
                1

            else
                0
    in
    -- `max 0` evita un número negativo si algo se descuadra.
    max 0 (Partida.maximoIntentos - usadas - enCurso)


filaCompletada : List LetraEvaluada -> Html msg
filaCompletada evaluadas =
    fila (List.map celdaEvaluada evaluadas)


{-| La fila que el jugador está escribiendo: las letras puestas más las
casillas que faltan.
-}
filaActual : List Char -> Html msg
filaActual letras =
    let
        escritas =
            List.map celdaEscrita letras

        pendientes =
            List.repeat
                (Palabra.longitudRequerida - List.length letras)
                celdaVacia
    in
    fila (escritas ++ pendientes)


filaVacia : Html msg
filaVacia =
    fila (List.repeat Palabra.longitudRequerida celdaVacia)


fila : List (Html msg) -> Html msg
fila celdas =
    div [ style "display" "flex", style "gap" "6px" ] celdas



-- CELDAS
-- Tres variantes que comparten la misma función base.


celdaEvaluada : LetraEvaluada -> Html msg
celdaEvaluada evaluada =
    celda
        (Estilos.colorDeEstado evaluada.estado)
        (Estilos.colorDeEstado evaluada.estado)
        (String.fromChar evaluada.letra)


celdaEscrita : Char -> Html msg
celdaEscrita letra =
    celda "transparent" Estilos.acento (String.fromChar letra)


celdaVacia : Html msg
celdaVacia =
    celda "transparent" Estilos.borde ""


celda : String -> String -> String -> Html msg
celda fondo colorBorde contenido =
    div
        [ style "width" "58px"
        , style "height" "58px"
        , style "background-color" fondo
        , style "border" ("2px solid " ++ colorBorde)
        , style "display" "flex"
        , style "align-items" "center"
        , style "justify-content" "center"
        , style "font-size" "30px"
        , style "font-weight" "bold"
        , style "text-transform" "uppercase"
        , style "box-sizing" "border-box"
        ]
        [ text contenido ]



-- MENSAJES


{-| La zona de debajo del tablero cambia según el estado de la partida.

El `case` devuelve una LISTA de elementos, y el compilador exige que las
tres ramas estén cubiertas.
-}
verMensaje : Config msg -> Html msg
verMensaje config =
    div
        -- `min-height` fijo evita que el teclado salte cuando aparece
        -- o desaparece el mensaje.
        [ style "min-height" "80px"
        , style "margin-top" "16px"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        , style "gap" "10px"
        ]
        (case Partida.estado config.partida of
            EnCurso ->
                [ verAviso config.aviso ]

            Ganada ->
                [ texto "¡Correcto!"
                , Vista.Estadisticas.ver config.estadisticas
                , botonReiniciar config.alReiniciar
                ]

            Perdida ->
                [ texto
                    ("La palabra era: "
                        ++ String.toUpper
                            (Palabra.aTexto (Partida.objetivo config.partida))
                    )
                , Vista.Estadisticas.ver config.estadisticas
                , botonReiniciar config.alReiniciar
                ]
        )


{-| El aviso solo existe si hay algo que avisar.

`text ""` es un elemento vacío: la forma de "no pintar nada" cuando el
tipo exige un Html.
-}
verAviso : Maybe String -> Html msg
verAviso aviso =
    case aviso of
        Nothing ->
            text ""

        Just mensaje ->
            texto mensaje


texto : String -> Html msg
texto contenido =
    div [ style "font-size" "18px" ] [ text contenido ]


botonReiniciar : msg -> Html msg
botonReiniciar mensaje =
    button
        [ onClick mensaje
        , style "background-color" Estilos.colorTexto
        , style "color" Estilos.fondo
        , style "border" "none"
        , style "border-radius" "6px"
        , style "padding" "10px 22px"
        , style "font-size" "15px"
        , style "font-weight" "bold"
        , style "cursor" "pointer"
        ]
        [ text "Jugar de nuevo" ]
```

> **Detalle que vale mencionar en la exposición:** no hay un solo número 5 en
> este archivo. Se usa `Palabra.longitudRequerida`. Si mañana el juego pasa a
> seis letras, se cambia una constante y la interfaz se adapta sola.

---

### 4C — Vista de estadísticas (integrante C)

```elm
module Vista.Estadisticas exposing (ver)

{-| El panel de estadísticas que aparece al terminar una partida.
-}

import Dict
import Dominio.Estadisticas as Estadisticas exposing (Estadisticas)
import Dominio.Partida as Partida
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Vista.Estilos as Estilos


ver : Estadisticas -> Html msg
ver estadisticas =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        , style "gap" "16px"
        , style "margin-top" "8px"
        ]
        [ verResumen estadisticas
        , verDistribucion estadisticas
        ]


{-| Los cuatro números de arriba.
-}
verResumen : Estadisticas -> Html msg
verResumen estadisticas =
    div
        [ style "display" "flex", style "gap" "22px" ]
        [ dato (Estadisticas.jugadas estadisticas) "Jugadas"
        , dato (Estadisticas.porcentajeVictorias estadisticas) "% Victorias"
        , dato (Estadisticas.rachaActual estadisticas) "Racha"
        , dato (Estadisticas.mejorRacha estadisticas) "Mejor"
        ]


{-| Un número grande con su etiqueta pequeña debajo.
-}
dato : Int -> String -> Html msg
dato valor etiqueta =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        ]
        [ div [ style "font-size" "26px", style "font-weight" "bold" ]
            [ text (String.fromInt valor) ]
        , div [ style "font-size" "11px", style "color" Estilos.tenue ]
            [ text etiqueta ]
        ]


{-| Las seis barras: cuántas veces se ganó en cada intento.
-}
verDistribucion : Estadisticas -> Html msg
verDistribucion estadisticas =
    let
        conteos =
            Estadisticas.distribucion estadisticas

        -- El máximo se usa para escalar las barras: la más alta ocupa
        -- el 100% del ancho y las demás en proporción.
        -- `List.maximum` devuelve Maybe porque la lista puede estar vacía.
        maximo =
            Dict.values conteos
                |> List.maximum
                |> Maybe.withDefault 0
    in
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "gap" "4px"
        , style "width" "260px"
        ]
        -- `List.range 1 6` genera [1,2,3,4,5,6]: una barra por intento
        -- posible, aunque nunca se haya ganado en ese número.
        (List.range 1 Partida.maximoIntentos
            |> List.map
                (\intento ->
                    barra intento
                        (Dict.get intento conteos |> Maybe.withDefault 0)
                        maximo
                )
        )


barra : Int -> Int -> Int -> Html msg
barra intento cantidad maximo =
    let
        proporcion =
            -- Sin este caso, sería una división por cero la primera vez.
            if maximo == 0 then
                0

            else
                toFloat cantidad / toFloat maximo

        -- `max 8` garantiza que la barra siempre se vea, aunque sea cero.
        ancho =
            max 8 (round (proporcion * 100))
    in
    div
        [ style "display" "flex", style "align-items" "center", style "gap" "8px" ]
        [ div [ style "font-size" "13px", style "width" "12px" ]
            [ text (String.fromInt intento) ]
        , div
            [ style "background-color"
                (if cantidad > 0 then
                    "#538d4e"

                 else
                    Estilos.borde
                )
            , style "width" (String.fromInt ancho ++ "%")
            , style "padding" "2px 8px"
            , style "font-size" "13px"
            , style "font-weight" "bold"
            , style "text-align" "right"
            , style "border-radius" "3px"
            ]
            [ text (String.fromInt cantidad) ]
        ]
```

### Cierre de la ronda 4

Los tres suben sus ramas y abren sus PR. **Fusionen primero los de A y C**
(TecladoVirtual y Estadisticas), y de último el de B (Tablero), que es el que
depende de los otros dos. Después:

```powershell
git checkout main
git pull
elm-test
```

Las pruebas deben seguir pasando. El proyecto todavía no compila como
aplicación porque falta `Main.elm`: eso es lo siguiente.

---

## Ronda 5 — Main y el HTML (los tres juntos)

Esta última la hacen juntos, porque es donde se ve cómo encaja todo y porque
es el módulo que más van a tener que explicar en la exposición.

```powershell
git checkout main
git pull
git checkout -b feat/main-y-html
```

### La Arquitectura Elm en cuatro piezas

Toda aplicación Elm tiene la misma forma:

| Pieza | Qué es |
|---|---|
| **Model** | el estado completo de la aplicación, en un solo valor |
| **Msg** | todo lo que puede pasar, enumerado como un tipo cerrado |
| **update** | recibe un Msg y el Model viejo; devuelve el Model nuevo |
| **view** | recibe el Model y devuelve la descripción de la pantalla |

El ciclo es: el usuario hace algo → se produce un `Msg` → `update` calcula un
`Model` nuevo → `view` describe la pantalla → el runtime la pinta.

> **En clase vimos:** eso es la secuenciación, pero expresada como flujo de
> datos. No hay un solo punto y coma en el proyecto. La secuencia es la forma
> del programa, no un operador.

### El archivo: `src/Main.elm`

```elm
-- `port module` en vez de `module`: este archivo declara canales hacia
-- JavaScript. Es el ÚNICO que puede hacerlo.
port module Main exposing (main)

{-| Punto de entrada de la aplicación.

Este módulo conecta el dominio con la interfaz. No contiene lógica de
juego: toda decisión sobre qué es válido o quién ganó vive en `Dominio`.
Aquí solo se traducen eventos del usuario en mensajes, y mensajes en
nuevos estados.

-}

import Browser
import Browser.Events
import Datos.Almacenamiento as Almacenamiento
import Datos.Diccionario as Diccionario
import Dominio.Estadisticas as Estadisticas exposing (Estadisticas)
import Dominio.Palabra as Palabra exposing (Palabra)
import Dominio.Partida as Partida exposing (Estado(..), Partida)
import Html exposing (Html)
import Json.Decode as Decode
import Json.Encode as Encode
import Random
import Vista.Tablero



-- PORTS


{-| Canal de salida hacia el navegador.

Un `port` es la única forma que tiene Elm de hablar con JavaScript. No es
una llamada a función: es un canal por el que se envían datos. Lo que
ocurra del otro lado, Elm no lo sabe ni lo controla.

Fíjate en el tipo de retorno: `Cmd msg`. Este port NO guarda nada. Produce
una DESCRIPCIÓN de "hay que guardar esto", que alguien más ejecutará.
-}
port guardarEstadisticas : Encode.Value -> Cmd msg



-- MODELO


{-| Todo el estado de la aplicación, en un solo valor.

Si quieres saber qué está pasando en el juego en cualquier momento, miras
esto y ya. No hay estado escondido en ningún otro sitio.
-}
type alias Model =
    { partida : Partida
    , aviso : Maybe String       -- Nothing = no hay nada que avisar
    , estadisticas : Estadisticas
    }


{-| TODO lo que puede pasar en la aplicación, enumerado.

Esta lista es cerrada: no puede ocurrir nada que no esté aquí. Y el
compilador va a exigir que `update` maneje las seis variantes.
-}
type Msg
    = PalabraSorteada Palabra   -- el runtime nos devuelve la palabra del día
    | LetraPresionada Char
    | BorrarPresionado
    | EnviarPresionado
    | PartidaReiniciada
    | TeclaIgnorada             -- una tecla que no nos interesa


{-| El arranque.

Recibe los datos guardados del navegador (los "flags") y devuelve DOS
cosas: el modelo inicial y un comando.

Fíjate en que la partida arranca con `Palabra.porDefecto`. Todavía no
sabemos cuál es la palabra del día: eso llega después, cuando el runtime
responda al sorteo.
-}
init : Decode.Value -> ( Model, Cmd Msg )
init guardadas =
    ( { partida = Partida.nueva Palabra.porDefecto
      , aviso = Nothing
      , estadisticas = Almacenamiento.decodificar guardadas
      }
    , sortearPalabra
    )


{-| LA LÍNEA MÁS IMPORTANTE DEL PROYECTO PARA LA EXPOSICIÓN.

`Random.generate` no sortea nada. Construye un `Cmd Msg`: un valor que
describe "hay que hacer este sorteo y avisarme con este mensaje".

La cadena completa es:
  1. `init` devuelve el Cmd.            -> nada se ha sorteado todavía
  2. El runtime de Elm recibe el Cmd
     y hace el sorteo.                  -> AQUÍ está el no determinismo
  3. El runtime nos llama de vuelta
     con `PalabraSorteada "cielo"`.     -> ya es un dato normal
  4. Nuestro `update` construye un
     modelo nuevo.                      -> función pura, sin sorpresas
-}
sortearPalabra : Cmd Msg
sortearPalabra =
    Random.generate PalabraSorteada Diccionario.generador



-- ACTUALIZACIÓN


{-| El corazón del ciclo.

Recibe qué pasó y cómo estaban las cosas; devuelve cómo quedan y qué
efectos hay que pedirle al runtime.

Fíjate en que SIEMPRE devuelve una tupla `( Model, Cmd Msg )`. Cuando no
hay ningún efecto que pedir, se devuelve `Cmd.none`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PalabraSorteada palabra ->
            -- Llegó la palabra del día: empieza la partida de verdad.
            ( { model | partida = Partida.nueva palabra, aviso = Nothing }
            , Cmd.none
            )

        LetraPresionada caracter ->
            -- Toda la decisión de si la letra cabe, si es válida o si la
            -- partida terminó está en `Dominio.Partida`. Aquí solo se
            -- delega.
            ( { model
                | partida = Partida.escribirLetra caracter model.partida
                , aviso = Nothing     -- al escribir, se limpia el aviso
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
            -- Aquí, y SOLO aquí, se conectan `Partida` y `Diccionario`.
            -- `Partida` nunca supo que el diccionario existe.
            case Partida.enviar Diccionario.esAceptada model.partida of
                Ok siguiente ->
                    let
                        ( estadisticas, efecto ) =
                            cerrarPartida siguiente model.estadisticas
                    in
                    ( { model
                        | partida = siguiente
                        , aviso = Nothing
                        , estadisticas = estadisticas
                      }
                    , efecto
                    )

                Err rechazo ->
                    -- El intento no se registra: solo mostramos el motivo.
                    ( { model
                        | aviso = Just (Partida.descripcionRechazo rechazo)
                      }
                    , Cmd.none
                    )

        PartidaReiniciada ->
            -- No creamos la partida nueva aquí: devolvemos el modelo TAL
            -- CUAL y pedimos otro sorteo. La partida llegará después, con
            -- `PalabraSorteada`.
            -- Es imposible reiniciar sin sortear: no hay forma de construir
            -- el estado nuevo sin pasar por el runtime.
            ( model, sortearPalabra )

        TeclaIgnorada ->
            ( model, Cmd.none )


{-| Si la partida acaba de terminar, acumula el resultado y pide guardarlo.

Devuelve una tupla igual que `update`: las estadísticas nuevas y el efecto
que hay que ejecutar.
-}
cerrarPartida : Partida -> Estadisticas -> ( Estadisticas, Cmd Msg )
cerrarPartida partida previas =
    let
        acumular resultado =
            let
                nuevas =
                    Estadisticas.registrar resultado previas
            in
            ( nuevas, guardarEstadisticas (Almacenamiento.codificar nuevas) )
    in
    case Partida.estado partida of
        EnCurso ->
            -- La partida sigue: no hay nada que acumular ni que guardar.
            ( previas, Cmd.none )

        Ganada ->
            acumular
                (Estadisticas.Victoria
                    (List.length (Partida.intentos partida))
                )

        Perdida ->
            acumular Estadisticas.Derrota



-- SUSCRIPCIONES


{-| Qué eventos del exterior nos interesan.

Aquí pedimos que nos avisen de cada tecla presionada. Es lo que hace que
el teclado físico funcione además del de pantalla.
-}
subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyDown
        -- Un decodificador: del evento JSON que manda el navegador,
        -- sacamos el campo "key" como texto, y lo convertimos en un Msg.
        (Decode.map desdeTecla (Decode.field "key" Decode.string))


{-| Traduce el nombre de una tecla en un mensaje del juego.
-}
desdeTecla : String -> Msg
desdeTecla tecla =
    case tecla of
        "Enter" ->
            EnviarPresionado

        "Backspace" ->
            BorrarPresionado

        otra ->
            -- `String.uncons` parte un texto en (primer carácter, resto).
            -- Si el resto es "", la tecla era un solo carácter: una letra.
            -- Si no (F1, Shift, ArrowUp...), la ignoramos.
            case String.uncons otra of
                Just ( caracter, "" ) ->
                    LetraPresionada caracter

                _ ->
                    TeclaIgnorada



-- VISTA


{-| Le entrega al tablero todo lo que necesita, incluidos los mensajes que
debe producir cuando el usuario interactúe.
-}
view : Model -> Html Msg
view model =
    Vista.Tablero.ver
        { partida = model.partida
        , aviso = model.aviso
        , alPresionarLetra = LetraPresionada
        , alBorrar = BorrarPresionado
        , alEnviar = EnviarPresionado
        , alReiniciar = PartidaReiniciada
        , estadisticas = model.estadisticas
        }



-- PROGRAMA


{-| El punto de entrada.

`Browser.element` monta la aplicación dentro de un nodo del HTML.
`Program Decode.Value Model Msg` significa: recibe flags de tipo
Decode.Value, su estado es Model y sus mensajes son Msg.
-}
main : Program Decode.Value Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
```

> **En clase vimos, y esto es el remate de la exposición:**
>
> La diapositiva decía que *un comando es una construcción de programa que se
> ejecutará para actualizar las variables*. El `Cmd` de Elm **no se ejecuta** y
> **no actualiza ninguna variable**: es una descripción que se entrega al
> runtime. La palabra es la misma, el concepto es el opuesto.
>
> Y el único código de todo el proyecto que actualiza algo de verdad son las
> cinco líneas de JavaScript del archivo siguiente. Están **fuera de Elm**, a
> propósito y a la vista.

### El archivo: `index.html`

Este archivo va en la **raíz del proyecto**, junto a `elm.json`.

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Wordle en Elm</title>
  <style>
    html, body { margin: 0; padding: 0; background: #121213; }
  </style>
</head>
<body>
  <!-- Aquí se monta la aplicación de Elm -->
  <div id="app"></div>

  <!-- El JavaScript que genera el compilador -->
  <script src="elm.js"></script>

  <script>
    var CLAVE = "wordle-elm-estadisticas";

    // Se leen las estadísticas guardadas antes de arrancar Elm.
    // El try/catch es porque localStorage puede estar bloqueado o el
    // contenido puede estar corrupto.
    var guardadas = null;
    try {
      var crudo = localStorage.getItem(CLAVE);
      if (crudo) { guardadas = JSON.parse(crudo); }
    } catch (e) {
      guardadas = null;
    }

    // Arranca la aplicación, pasándole los datos como "flags".
    var app = Elm.Main.init({
      node: document.getElementById("app"),
      flags: guardadas
    });

    // Y aquí está el otro extremo del port.
    // Elm nunca escribe en localStorage: envía datos por el canal y este
    // JavaScript decide qué hacer con ellos.
    app.ports.guardarEstadisticas.subscribe(function (datos) {
      try {
        localStorage.setItem(CLAVE, JSON.stringify(datos));
      } catch (e) {}
    });
  </script>
</body>
</html>
```

### Compilar y jugar

Ahora la salida del compilador es `elm.js`, no un HTML:

```powershell
elm make src/Main.elm --output=elm.js
```

Abran `index.html` con doble clic. Deberían tener el juego funcionando.

**Prueben esto antes de dar por terminado:**

- Escribir con el teclado físico y con el de pantalla.
- Enviar una palabra incompleta con Enter.
- Terminar una partida y usar el botón de reiniciar.
- Que las teclas se vayan coloreando.
- **Recargar la página** y comprobar que las estadísticas siguen ahí.

> Si al recargar se pierden las estadísticas, es porque el navegador bloquea
> `localStorage` en archivos abiertos con doble clic. Se resuelve sirviendo la
> carpeta: `npx serve .` y entrando por `localhost`.

### Cerrar el proyecto

```powershell
elm-test
git add .
git commit -m "feat: agrega punto de entrada, ports y pagina del juego"
git push -u origin feat/main-y-html
```

PR, revisión de los tres, merge. Y listo.

---

# Anexos

## Anexo A — Comandos de referencia

### Git

```powershell
git status                      # qué cambió y en qué rama estoy
git checkout main               # cambiar de rama
git pull                        # bajar lo que subieron los demás
git checkout -b feat/mi-rama    # crear una rama nueva
git add .                       # preparar todos los cambios
git commit -m "feat: ..."       # guardar un punto en la historia
git push -u origin feat/mi-rama # subir la rama por primera vez
git push                        # subir commits siguientes
git log --oneline               # ver el historial resumido
git branch -a                   # listar todas las ramas
```

### Elm

```powershell
elm make src/Main.elm --output=elm.js   # compilar la aplicación
elm-test                                # correr todas las pruebas
elm-test --watch                        # correrlas en cada guardado
elm-test tests/PalabraTest.elm          # correr solo un archivo
elm-format src/                         # formatear todo el código
elm install elm/random                  # agregar una dependencia
elm repl                                # probar expresiones sueltas
```

## Anexo B — Problemas que nos encontramos, y su solución

Esta lista está sacada de la construcción real del proyecto. Casi todos les
van a pasar.

**`elm test` no existe.** El comando lleva guion: `elm-test`. Sin guion es el
compilador, que no tiene ese subcomando.

**"No Elm projects found" en IntelliJ, con decenas de errores rojos.** Hay un
botón *Attach elm.json* en la barra amarilla del editor. Púlsenlo.

**ELM VERSION MISMATCH.** El `elm.json` pide una versión distinta a la
instalada. Abran `elm.json` y pongan `"elm-version": "0.19.1"`.

**`elm-test` falla con `ENOENT ... elmTestOutput.js`.** Este es el peor,
porque el mensaje no dice nada útil. Significa que **la compilación de las
pruebas falló**, pero la herramienta lo reporta como archivo faltante.

Para ver el error de verdad:

```powershell
cd elm-stuff\generated-code\elm-community\elm-test\0.19.1-revision12
elm make src\Test\Generated\Main.elm --output=prueba.js
```

Ese comando sí muestra el mensaje del compilador. Si dice "Success", el
problema es de compatibilidad de la herramienta con Node: usen Node 20.

**Dos declaraciones de `module` en el mismo archivo.** Pasa al pegar código
sobre un archivo que IntelliJ creó con su propio encabezado. Debe haber una
sola, y en la línea 1.

**"I was expecting another value to expose".** Faltan las comas del bloque
`exposing`. Deben ir **al principio** de cada línea a partir de la segunda.

**Un `case` con `=` en vez de `->`.** Las ramas de un `case` usan flecha.

**Git abrió un editor raro del que no puedo salir.** Es Vim. Escriban `:wq` y
Enter. Para que no vuelva a pasar: `git config --global core.editor notepad`.

**La rama principal se llama `master` en vez de `main`.**

```powershell
git branch -M main
git push -u origin main
```

Y en GitHub, `Settings > General > Default branch`, cámbienla a `main`.

**Estoy editando una carpeta y ejecutando en otra.** Si copiaron el proyecto a
otro sitio, verifiquen la ruta en el título de IntelliJ y en el prompt de la
terminal antes de perder media hora.

## Anexo C — Checklist final

Antes de dar el proyecto por entregado:

- [ ] `elm make src/Main.elm --output=elm.js` compila sin errores
- [ ] `elm-test` pasa todas las pruebas
- [ ] El juego se juega de principio a fin, se gana y se pierde
- [ ] Las estadísticas sobreviven a recargar la página
- [ ] `git status` dice "working tree clean"
- [ ] Todas las ramas están fusionadas en `main`
- [ ] `git log --oneline` se lee y cuenta la historia del proyecto
- [ ] Los tres integrantes tienen commits en el historial
- [ ] Los tres entienden todos los módulos, no solo los suyos

## Anexo D — Guion de la exposición

Diez minutos, repartidos entre los tres. La idea es **no recitar el código**,
sino usarlo para responder preguntas de la materia.

**1. El planteamiento (1 min).** "El enunciado pedía usar comandos,
asignaciones, condicionales, iteración y expresiones. Elegimos Elm, y resulta
que Elm **no tiene** comandos, ni asignación, ni ciclos. Vamos a mostrar qué
puso en su lugar y por qué."

**2. Los tipos opacos — abrir `Palabra.elm` (2 min).** Señalar el `exposing`
sin los `(..)`. "Este es nuestro `private`. Si tienes una `Palabra`, está
validada, porque no hay otra forma de construirla." Conectar con la
encapsulación y con la validación en la frontera.

**3. La iteración — abrir `Evaluacion.elm` (2 min).** Señalar
`segundaPasada`. "Esto es un `while`, pero escrito como recursión. Y fíjense
en el inventario: cada llamada recibe su propia copia. Es el mismo fenómeno de
las variables locales en llamadas recursivas anidadas que vimos en clase."

**4. La asignación — abrir `Partida.elm` (2 min).** Señalar
`{ interno | actual = ... }`. "Esto **parece** la actualización selectiva de
Pascal, pero es lo contrario: construye un registro nuevo y el anterior queda
intacto. Es la regla del todo o nada."

**5. El comando — abrir `Main.elm` (2 min).** El remate. Señalar
`Random.generate` y el `port`. "La diapositiva definía un comando como algo
que se ejecuta para actualizar variables. Un `Cmd` en Elm no se ejecuta y no
actualiza nada: es una descripción que se entrega. El no determinismo existe,
pero vive fuera de nuestro código."

**6. La anécdota del diseño (1 min).** Abrir la firma de `enviar`. "Le pasamos
el diccionario como una función en vez de importarlo. Cuando quisimos cambiar
la regla de qué palabras se aceptan, tocamos un archivo de datos y una línea
de `Main`. El módulo con toda la lógica del juego ni se enteró, y sus pruebas
siguieron pasando sin modificarse."

**Y si preguntan por las pruebas:** ábranlas y muéstrenlas. Que un tipo haga
imposible representar un estado inválido es, en sí mismo, una forma de prueba
que el compilador verifica en cada compilación.

---

*Fin de la guía.*
