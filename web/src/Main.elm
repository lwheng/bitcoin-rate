module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    String


init : () -> ( Model, Cmd Msg )
init _ =
    ( "Please click Reload", Cmd.none )



-- UPDATE


type Msg
    = GotRate (Result Http.Error String)
    | Reload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reload ->
            ( model, getRate )

        GotRate (Err error) ->
            ( Debug.toString error, Cmd.none )

        GotRate (Ok val) ->
            ( val, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model ]
        , button [ onClick Reload ] [ text "Reload" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


getRate : Cmd Msg
getRate =
    Http.get
        { url = "http://localhost:3000/bitcoin-rate"
        , expect = Http.expectString GotRate
        }
