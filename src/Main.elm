module Main exposing (..)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Spacing as Spacing
import Browser as Browser
import Browser.Navigation as Navigation
import Html as Html
import Html.Attributes as Attr
import Http as Http
import String as String
import Url as Url

main : Program () Model Msg
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


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( "Please click Reload", Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Bitcoin Rate"
    , body =
        [ Grid.container []
            [ CDN.stylesheet
            , Card.config [ Card.attrs [ Attr.style "width" "20rem" ] ]
                |> Card.header [ Attr.class "text-center" ]
                    [ Html.h3 [ Spacing.mt2 ] [ Html.text model ]
                    ]
                |> Card.block []
                    [ Block.custom <|
                        Button.button [ Button.primary, Button.onClick Reload ] [ Html.text "Reload" ]
                    ]
                |> Card.view
            ]
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
            ( errorToString error, Cmd.none )

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


onUrlChange : Url.Url -> Msg
onUrlChange _ =
    Reload


getRate : Cmd Msg
getRate =
    Http.get
        { url = "http://localhost:3000/bitcoin-rate"
        , expect = Http.expectString GotRate
        }


errorToString : Http.Error -> String
errorToString err =
    case err of
        Http.BadUrl s ->
            "BadUrl: " ++ s

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "NetworkError"

        Http.BadStatus i ->
            "BadStatus: " ++ String.fromInt i

        Http.BadBody s ->
            "BadBody:" ++ s
