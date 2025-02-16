module Components.List exposing (view, Todo)

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class)

type alias Todo =
    { value : String
    }

view : List Todo -> Html msg
view todos =
    ul [ class "space-y-2 w-full" ]
        (List.map viewTodoItem todos)

viewTodoItem : Todo -> Html msg
viewTodoItem todo =
    li
        [ class "block p-4 rounded-lg bg-gray-800 text-white border border-gray-700 hover:bg-gray-700 transition-colors duration-200" ]
        [ text todo.value ]