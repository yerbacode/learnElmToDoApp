module Components.List exposing (Model, Msg(..), todoList, todoListModel, addTodo)

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class)

type alias Model =
    { todos : List String
    }
type Msg
    = AddTodo String

todoListModel : Model
todoListModel =
    { todos = ["dupa"] }


addTodo : Msg -> Model -> Model
addTodo msg model =
    case msg of
        AddTodo todo ->
            { model | todos = todo :: model.todos }

todoList : Model -> Html Msg
todoList model =
    ul [ class "space-y-2 w-full" ]
        (List.map (\todo ->
            li [ class "block p-4 rounded-lg bg-gray-800 text-white border border-gray-700 hover:bg-gray-700 transition-colors duration-200" ]
                [text todo]
        ) model.todos)