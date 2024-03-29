module Playground exposing (main)

import Html


{-
escapeEarth myVelocity mySpeed =
    if myVelocity > 11.186 then
        "Godspeed"

    else if mySpeed == 7.67 then
        "Stay in orbit"

    else
        "Come back"
-}

escapeEarth myVelocity mySpeed fuelStatus =
    let
        escapeVelocityInKmPerSec =
            11.186

        orbitalSpeedInKmPerSec =
            7.67
        
        whereToLand  = 
          if fuelStatus == "low" then 
            "Land on droneship"
          else
            "Land on launchpad"
    in
    if myVelocity > escapeVelocityInKmPerSec then
        "Godspeed"

    else if mySpeed == orbitalSpeedInKmPerSec then
        "Stay in orbit"

    else
        whereToLand 

computeSpeed distance time =
    distance / time


computeTime startTime endTime =
    endTime - startTime
{-
main =
    Html.text (escapeEarth 11 (computeSpeed 7.67 (computeTime 2 3)))
main = computeTime 2 3 
  |> computeSpeed 7.67
  |> escapeEarth 11
  |> Html.text
-}
add a b =
    a + b


multiply c d =
    c * d


divide e f =
    e / f

{-
main = 
  Html.text (String.fromFloat (add 5 (multiply 10 (divide 30 10))))
-}

{-
main = 
  Html.text <| String.fromFloat <| add 5 <| multiply 10 <| divide 30 10
-}

revelation =
    """
    It became very clear to me sitting out there today
    that every decision I've made in my entire life has
    been wrong. My life is the complete "opposite" of
    everything I want it to be. Every instinct I have,
    in every aspect of life, be it something to wear,
    something to eat - it's all been wrong.
    """

-- main = 
--   escapeEarth 10 6.7 "low"
--     |> Html.text

main = 
    Html.text revelation