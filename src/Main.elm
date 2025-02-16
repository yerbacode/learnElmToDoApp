module Main exposing (main)

import Browser
import Html exposing (Html, div, textarea, button, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput)
import Components.List as TodoList

type alias Model =
    { currentInput : String
    , todoList : List TodoList.Todo
    }



type Msg
    = UpdateInput String
    | AddTodo

init : Model
init =
    { todoList = []
    , currentInput = ""
    }

update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateInput newInput ->
            { model | currentInput = newInput }

        AddTodo ->
            { model
            | todoList = { value = model.currentInput } :: model.todoList
            , currentInput = ""
            }

view : Model -> Html Msg
view model =
    div [ class "flex flex-col items-center gap-4 p-4" ]
        [ TodoList.view model.todoList
        , div [ class "flex gap-2" ]
            [ textarea
                [ placeholder "Your TODO note"
                , value model.currentInput
                , onInput UpdateInput
                , class "rounded p-2 bg-gray-800 text-white border border-gray-700"
                ] []
            , button
                [ onClick AddTodo
                , class "px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                ]
                [ text "Add!" ]
            ]
        ]

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }