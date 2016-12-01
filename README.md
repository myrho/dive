# Dive

Dive is a framework written in [Elm](elmlang.org) for programming visual presentations like [Prezi](prezi.com). 

## Installation

You need to install Elm before.

    npm install -g elm

Then clone this repo, build the package and run the built in dummy presentation:

    git clone https://github.com/myrho/dive
    cd dive
    elm package install
    elm reactor

Browse to `localhost:8000`, browse to `Main.elm` and have fun with it!

Alternatively you can use `index.html`. For this the repo needs to be cloned into a directory of a local webserver. Then browse to:

    localhost/dive/index.html

`index.html` contains a piece of JavaScript that reads out current window size and passes it to the Elm App on startup.
