module Components.List exposing (view, Todo)

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

type alias Todo =
    { value : String, id: Int
    }

view : List Todo -> (Int -> msg) -> Html msg
view todos onDelete=
    ul [ class "space-y-2 w-full" ]
        (List.map (viewTodoItem onDelete) todos)

viewTodoItem : (Int -> msg) -> Todo -> Html msg
viewTodoItem onDelete todo  =
    li
        [ class "block p-4 rounded-lg bg-gray-800 text-white border border-gray-700 hover:bg-gray-700 transition-colors duration-200" ]
        [ text todo.value , Html.button
                [ onClick (onDelete todo.id)
                , class "px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                ]
                [ text "Remove" ]  ]