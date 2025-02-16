module Main exposing (main)

import Browser
import Html exposing (Html, textarea, button, text, div)
import Html.Attributes exposing (placeholder, value, class)
import Html.Events exposing (onClick, onInput)
import Components.List as TodoList

type alias Model =
    { todoList : TodoList.Model
    , currentInput : String
    }

type Msg
    = UpdateInput String
    | AddTodoItem

init : Model
init =
    { todoList = TodoList.todoListModel
    , currentInput = ""
    }

textInput : String -> Html Msg
textInput currentInput =
    textarea
        [ placeholder "Your TODO note"
        , value currentInput
        , onInput UpdateInput
        ]
        []

addTodoElement : Html Msg
addTodoElement =
    button [ onClick AddTodoItem ]
        [ text "Add!" ]

todoListSectionContainer : List (Html Msg) -> Html Msg
todoListSectionContainer children =
    div [ class "flex justify-center w-full" ] children

update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateInput newInput ->
            { model | currentInput = newInput }

        AddTodoItem ->
            { model
            | todoList = TodoList.addTodo (TodoList.AddTodo model.currentInput) model.todoList
            , currentInput = ""
            }

view : Model -> Html Msg
view model =
    div [ class "flex flex-col items-center gap-4 p-4" ]
        [ todoListSectionContainer [ Html.map (\_ -> AddTodoItem) (TodoList.todoList model.todoList) ]
        , todoListSectionContainer
            [ div [ class "flex gap-2" ]
                [ textInput model.currentInput
                , addTodoElement
                ]
            ]
        ]

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }