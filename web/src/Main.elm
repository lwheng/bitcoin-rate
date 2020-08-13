module Main exposing (main)

import Browser as Browser
import Browser.Navigation as Navigation
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Url exposing (..)


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }



-- MODEL


type alias Model =
    String


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( "Please click Reload", Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Sample"
    , body =
        [ div [] [ text model ]
        , button [ onClick Reload ] [ text "Reload" ]
        ]
    }



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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- onUrlRequest


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest _ =
    Reload



-- onUrlChange


onUrlChange : Url -> Msg
onUrlChange _ =
    Reload


getRate : Cmd Msg
getRate =
    Http.get
        { url = "http://localhost:3000/bitcoin-rate"
        , expect = Http.expectString GotRate
        }
