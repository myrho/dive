# Dive

Dive is a framework written in [Elm](elmlang.org) for programming visual presentations like [Prezi](prezi.com). 

## Installation

You need to [install Elm](https://guide.elm-lang.org/install.html) before.

Then clone this repo into a directory served by a local webserver and build the package: 

    git clone https://github.com/myrho/dive
    cd dive
    elm package install
    elm make src/Main.elm --output elm.js

Browse to 

    localhost/dive/index.html

`index.html` contains a piece of JavaScript that reads out current window size and passes it to the Elm App on startup.

## License

Apache 2.0
