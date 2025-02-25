module Components.List exposing (State(..), Todo, view)

import Html exposing (Html, div, input, li, text, ul)
import Html.Attributes exposing (checked, class, type_, value)
import Html.Events exposing (onClick, onInput)


type State
    = Done
    | Pending


type alias Todo =
    { value : String
    , id : Int
    , isEditing : Bool
    , editValue : String
    , state : State
    }


type alias MessageConfig msg =
    { onDelete : Int -> msg
    , onEdit : Int -> msg
    , onUpdateEdit : Int -> String -> msg
    , onToggleState : Int -> msg
    }


view : List Todo -> MessageConfig msg -> Html msg
view todos config =
    ul [ class "space-y-2 w-full" ]
        (List.map (viewTodoItem config) todos)


viewTodoItem : MessageConfig msg -> Todo -> Html msg
viewTodoItem config todo =
    li
        [ class "block p-4 rounded-lg bg-gray-800 text-white border border-gray-700 hover:bg-gray-700 transition-colors duration-200" ]
        [ div [ class "flex items-center gap-2" ]
            [ input
                [ type_ "checkbox"
                , checked (todo.state == Done)
                , onClick (config.onToggleState todo.id)
                , class "w-4 h-4"
                ]
                []
            , if todo.isEditing then
                Html.input [ value todo.editValue, onInput (config.onUpdateEdit todo.id), class "rounded p-2 bg-gray-700 text-white border border-gray-600" ] []
              else
                div [ class (if todo.state == Done then "line-through text-gray-400" else "") ] [ text todo.value ]
            ]
        , div [ class "flex gap-2 mt-2" ]
            [ Html.button
                [ onClick (config.onDelete todo.id)
                , class "px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
                ]
                [ text "Remove" ]
            , Html.button
                [ onClick (config.onEdit todo.id)
                , class "px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                ]
                [ if todo.isEditing then
                    text "Save"
                  else
                    text "Edit"
                ]
            ]
        ]