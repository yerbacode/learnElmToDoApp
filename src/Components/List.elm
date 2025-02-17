module Components.List exposing (Todo, view)

import Html exposing (Html, li, text, ul)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)


type alias Todo =
    { value : String
    , id : Int
    , isEditing : Bool
    , editValue : String
    }


view : List Todo -> (Int -> msg) -> (Int -> msg) -> (Int -> String -> msg) -> Html msg
view todos onDelete onEdit onUpdateEdit =
    ul [ class "space-y-2 w-full" ]
        (List.map (viewTodoItem onDelete onEdit onUpdateEdit) todos)


viewTodoItem : (Int -> msg) -> (Int -> msg) -> (Int -> String -> msg) -> Todo -> Html msg
viewTodoItem onDelete onEdit onUpdateEdit todo =
    li
        [ class "block p-4 rounded-lg bg-gray-800 text-white border border-gray-700 hover:bg-gray-700 transition-colors duration-200" ]
        [ if todo.isEditing then
            Html.input [ value todo.editValue, onInput (\newValue -> onUpdateEdit todo.id newValue) ] []

          else
            text todo.value
        , Html.button
            [ onClick (onDelete todo.id)
            , class "px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            ]
            [ text "Remove" ]
        , Html.button [ onClick (onEdit todo.id) ]
            [ if todo.isEditing then
                text "Save"

              else
                text "Edit"
            ]
        ]
