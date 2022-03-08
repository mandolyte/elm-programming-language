#!/bin/bash

elm-format src/Main.elm --yes
elm-format src/Model.elm --yes
elm-format src/Data.elm --yes
elm-format src/Util.elm --yes
elm make src/Main.elm --output=elm.js
