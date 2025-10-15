-- rate of logic
fps = 60

skipShuffle = true

randomSeed = nil

initState = 0

showInfo = true
showFPS = false

-- might be broken
verifySort = false

listLength = 50

showSignificantIndex = true

skipKey = "n"
changeOrderKey = "m"
increaseLenKey = "."
decreaseLenKey = ","
fpsKey = "v"
increaseFPSKey = "c"
decreaseFPSKey = "x"

-- solid, greyscale, or rainbow
-- greyscale is the only one that I'm confident works
listColor = "greyscale"

color = {
  currentIndex = {255, 0, 0},
  background = {127, 127, 127},
  valid = {0, 255, 0}
}

--random or next
getNextAlgorithm = "random"
