module Main exposing (main)

import Browser
import Components.List as TodoList
import Html exposing (Html, button, div, text, textarea)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { currentInput : String
    , todoList : List TodoList.Todo
    }


type Msg
    = UpdateInput String
    | AddTodo
    | DeleteTodo Int
    | EditTodo Int
    | UpdateEditingTodo Int String


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
                | todoList = { value = model.currentInput, id = List.length model.todoList + 1, isEditing = False, editValue = model.currentInput } :: model.todoList
                , currentInput = ""
            }

        DeleteTodo numberOfItem ->
            { model
                | todoList = List.filter (\todo -> todo.id /= numberOfItem) model.todoList
            }

        EditTodo numberOfItem ->
            { model
                | todoList =
                    List.map
                        (\todo ->
                            if todo.id == numberOfItem then
                                if todo.isEditing then
                                    { todo | isEditing = False, value = todo.editValue }

                                else
                                    { todo | isEditing = True }

                            else
                                todo
                        )
                        model.todoList
            }

        UpdateEditingTodo numberOfItem newValue ->
            { model
                | todoList =
                    List.map
                        (\todo ->
                            if todo.id == numberOfItem then
                                { todo | editValue = newValue }

                            else
                                todo
                        )
                        model.todoList
            }


view : Model -> Html Msg
view model =
    div [ class "flex flex-col items-center gap-4 p-4" ]
        [ TodoList.view model.todoList DeleteTodo EditTodo UpdateEditingTodo
        , div [ class "flex gap-2" ]
            [ textarea
                [ placeholder "Your TODO note"
                , value model.currentInput
                , onInput UpdateInput
                , class "rounded p-2 bg-gray-800 text-white border border-gray-700"
                ]
                []
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
