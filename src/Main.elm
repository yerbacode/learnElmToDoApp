module Main exposing (main)

import Browser
import Components.List as TodoList
import Html exposing (Html, button, div, input, option, select, span, text, textarea)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { currentInput : String
    , todoList : List TodoList.Todo
    , sortBy : SortBy
    , filter : Filter
    }


type Msg
    = UpdateInput String
    | AddTodo
    | DeleteTodo Int
    | EditTodo Int
    | UpdateEditingTodo Int String
    | OnChangeSortBy String
    | OnChangeTodoFilterState TodoList.State
    | OnSearchChange String


init : Model
init =
    { todoList = []
    , currentInput = ""
    , sortBy = Id Desc
    , filter = Filter Nothing ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateInput newInput ->
            { model | currentInput = newInput }

        AddTodo ->
            { model
                | todoList =
                    { value = model.currentInput
                    , state = TodoList.Pending
                    , id = List.length model.todoList + 1
                    , isEditing = False
                    , editValue = model.currentInput
                    }
                        :: model.todoList
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

        OnChangeSortBy val ->
            { model | sortBy = valueToSortBy val |> Maybe.withDefault (Id Asc) }

        OnChangeTodoFilterState newFilter ->
            let
                (Filter _ search) =
                    model.filter
            in
            { model | filter = Filter (Just newFilter) search }

        OnSearchChange value ->
            let
                (Filter filter _) =
                    model.filter
            in
            { model | filter = Filter filter value }


view : Model -> Html Msg
view model =
    let
        (Filter filterState search) =
            model.filter

        filteredList =
            filterState
                |> Maybe.map (\fState -> List.filter (\todo -> todo.state == fState) model.todoList)
                |> Maybe.withDefault model.todoList
                |> List.filter
                    (\todo ->
                        String.isEmpty search
                            || String.contains (String.toLower search) (String.toLower todo.value)
                    )

        sortFn fn =
            List.sortBy fn filteredList

        sortedList =
            case model.sortBy of
                Id Desc ->
                    sortFn .id |> List.reverse

                Id Asc ->
                    sortFn .id

                Value Desc ->
                    sortFn .value |> List.reverse

                Value Asc ->
                    sortFn .value
    in
    div [ class "pt-50 pb-50 h-screen justify-between flex flex-col" ]
        [ div [ class "flex justify-between" ]
            [ textarea [ placeholder "Search", onInput OnSearchChange ] []
            , span [] [ text "Sort:" ]
            , viewSort
            ]
        , div [ class "flex flex-col items-center gap-4 p-4" ]
            [ TodoList.view sortedList DeleteTodo EditTodo UpdateEditingTodo
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
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


orderToString : Order -> String
orderToString o =
    case o of
        Asc ->
            "Asc"

        Desc ->
            "Desc"


sortByToString : SortBy -> String
sortByToString sortBy =
    case sortBy of
        Id o ->
            "Id " ++ orderToString o

        Value o ->
            "Value " ++ orderToString o


valueToSortBy : String -> Maybe SortBy
valueToSortBy s =
    case s of
        "Value Asc" ->
            Just (Value Asc)

        "Value Desc" ->
            Just (Value Desc)

        "Id Asc" ->
            Just (Id Asc)

        "Id Desc" ->
            Just (Id Desc)

        _ ->
            Nothing


viewSort : Html Msg
viewSort =
    div []
        [ select [ onInput OnChangeSortBy ]
            (List.map durationOption
                [ Id Desc
                , Id Asc
                , Value Desc
                , Value Asc
                ]
            )
        ]


durationOption : SortBy -> Html Msg
durationOption selectOption =
    option [] [ text (sortByToString selectOption) ]


type SortBy
    = Id Order
    | Value Order


type Order
    = Asc
    | Desc


type Filter
    = Filter (Maybe TodoList.State) String
