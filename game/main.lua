local sortingList = {}
local config = {}
local state
local currentAlgorithmIndex = 0
local minDT, nextDT
local algorithmData = require "algorithms"
local algorithmCallback
local currentIndex = {}
local love = love
local verifiedIndex = 0
local shuffleCallback
local unpack = unpack or table.unpack
local startTime = 0
local lastTime = "00:00.0"

function love.load()
  --print(math.log(2, 10))
  require "functions"
  loadfile("config.lua", "t", config)()
  state = config.initState
  minDT = 1/config.fps
  math.randomseed(config.seed or os.time())
  sortingList = fillList(config.listLength)
  shuffleList(sortingList)

  for _, v in pairs(config.color) do
    for i, c in ipairs(v) do
      v[i] = c/255
    end
  end
  love.graphics.setBackgroundColor(unpack(config.color.background))

  for i, v in ipairs(algorithmData) do
    v.func = require ("algorithms." .. v.filename)
  end

  config.listLength = math.max(config.listLength, 5)

  nextDT = love.timer.getTime()
end

function love.keyreleased(key)
  if key == config.skipKey then
    state = 0
  elseif key == config.changeOrderKey then
    if config.getNextAlgorithm == "random" then
      config.getNextAlgorithm = "next"
    else
      config.getNextAlgorithm = "random"
    end
    print("Swapped method of choosing next algorithm to "..config.getNextAlgorithm)
  elseif key == config.increaseLenKey then
    config.listLength = math.max(config.listLength+1, 5)
  elseif key == config.decreaseLenKey then
    config.listLength = math.max(config.listLength-1, 5)
  elseif key == config.fpsKey then
    config.showFPS = not config.showFPS
  elseif key == config.increaseFPSKey then
    config.fps = config.fps + 5
    minDT = 1/config.fps
  elseif key == config.decreaseFPSKey then
    config.fps = math.max(5, config.fps-5)
    minDT = 1/config.fps
  elseif key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  nextDT = nextDT + minDT

  --while not love.keyboard.isDown("a") do function noop() end end

  --choose next sort algorithm
  if state == 0 then
    if config.getNextAlgorithm == "next" then
      currentAlgorithmIndex = (currentAlgorithmIndex + 1) % (#algorithmData + 1)
      currentAlgorithmIndex = math.max(1, currentAlgorithmIndex)
    elseif config.getNextAlgorithm == "random" then
      local next = math.random(1, #algorithmData)
      while #algorithmData > 1 and next == currentAlgorithmIndex do
        next = math.random(1, #algorithmData)
      end
      currentAlgorithmIndex = next
    end
    state = 3

  --sorting
  elseif state == 1 then
    
    local code, arg = algorithmCallback(sortingList)
    if code == 0 or code == nil then
      state = 2
      currentIndex = {}
    elseif code == 1 then
      local nop = function() end
    elseif code == 2 then
      currentIndex = arg
    end

  --validating
  elseif state == 2 then
    if not config.verifySort then state = 0 end
    
    verifiedIndex = verifiedIndex + 1
    if math.ceil(verifiedIndex) > 1 then
      local i = math.min(math.ceil(verifiedIndex), #sortingList)
      if sortingList[i] < sortingList[i - 1] then
        print("Not SORTED")
        algorithmCallback = coroutine.wrap(algorithmData[currentAlgorithmIndex].func)
        state = 1
        verifiedIndex = 0
        love.window.setTitle(algorithmData[currentAlgorithmIndex].name)
      end
    end
    if verifiedIndex > #sortingList+(#sortingList*0.1) then
      currentIndex = {}
      state = 0
      verifiedIndex = 0
    end

  --prep next sort
  elseif state == 3 then
    local length = math.ceil(config.listLength*(algorithmData[currentAlgorithmIndex].listMult))
    sortingList = fillList(length, sortingList)
    shuffleCallback = coroutine.wrap(shuffleCo)
    currentIndex = {}
    state = 4
    if not config.skipShuffle then
      love.window.setTitle("Shuffling...")
    else
      shuffleList(sortingList)
      algorithmCallback = coroutine.wrap(algorithmData[currentAlgorithmIndex].func)
      love.window.setTitle(algorithmData[currentAlgorithmIndex].name)
      state = 1
      lastTime = formatTime(math.floor((love.timer.getTime()-startTime)*10)/10)
      startTime = love.timer.getTime()
    end

  elseif state == 4 then
    if config.skipShuffle then
      shuffleList(sortingList)
      algorithmCallback = coroutine.wrap(algorithmData[currentAlgorithmIndex].func)
      love.window.setTitle(algorithmData[currentAlgorithmIndex].name)
      state = 1
    end
    local code, arg
    repeat
      code, arg = shuffleCallback(sortingList)
    until code == 0
    if code == 0 then
      algorithmCallback = coroutine.wrap(algorithmData[currentAlgorithmIndex].func)
      love.window.setTitle(algorithmData[currentAlgorithmIndex].name)
      state = 1
    end
  end
end

function formatTime(seconds)
    -- Calculate minutes, seconds, and milliseconds
    local totalMilliseconds = seconds * 1000
    local minutes = math.floor(totalMilliseconds / (1000 * 60))
    local seconds = math.floor((totalMilliseconds % (1000 * 60)) / 1000)
    local milliseconds = math.floor(totalMilliseconds % 1000)

    -- Format the time components as strings with leading zeros if necessary
    local formatted_minutes = string.format("%02d", minutes)
    local formatted_seconds = string.format("%02d", seconds)
    local formatted_milliseconds = milliseconds/100

    -- Construct the formatted time string
    local formatted_time = formatted_minutes .. ":" .. formatted_seconds .. "." .. formatted_milliseconds

    return formatted_time
end

function love.draw()
  local w, h = love.graphics.getDimensions()
  local rectWidth = w / #sortingList
  local rectHeight = h / #sortingList
  if config.listColor == "solid" then
    love.graphics.setColor(0, 0, 0)
    for k, v in ipairs(sortingList) do
      love.graphics.rectangle("fill", (k - 1) * rectWidth, h - v * rectHeight, rectWidth, v * rectHeight)
    end
  elseif config.listColor == "greyscale" then
    for k, v in ipairs(sortingList) do
      local shade = v / #sortingList
      love.graphics.setColor(shade, shade, shade)
      love.graphics.rectangle(
        "fill",
        (k - 1) * rectWidth,
        h - v * rectHeight,
        rectWidth,
        v * rectHeight
      )
    end
  elseif config.listColor == "rainbow" then
    local color = {1, 0, 2/#sortingList}
    local const = 3/#sortingList
    local cur = 1
    local last = 3
    color[1] = color[1] - const
    for k, v in ipairs(sortingList) do
      color[cur] = color[cur] + const
      color[last] = color[last] - const
      if color[cur] >= 1 then
        cur = cur + 1
        last = last + 1
        if last > 3 then last = 1 end
        if cur > 3 then cur = 1 end
      end
      love.graphics.setColor(unpack(color))
      love.graphics.rectangle(
        "fill",
        (k - 1) * rectWidth,
        h - v * rectHeight,
        rectWidth,
        v * rectHeight  
      )
    end
  end


  if state == 2 and config.verifySort then
    love.graphics.setColor(unpack(config.color.valid))
    for i=1, math.min(math.ceil(verifiedIndex), #sortingList) do
      local v = sortingList[i]
      love.graphics.rectangle(
        "fill",
        (i - 1) * rectWidth,
        h - v * rectHeight,
        rectWidth,
        v * rectHeight
      )
    end
  elseif config.showSignificantIndex then
    love.graphics.setColor(unpack(config.color.currentIndex))
    for _, currentIndex in ipairs(currentIndex) do
      if sortingList[currentIndex] then
        love.graphics.rectangle(
          "fill", 
          (currentIndex-1) * rectWidth,
          h - sortingList[currentIndex] * rectHeight,
          rectWidth,
          sortingList[currentIndex] * rectHeight
        )
      end
    end
  end

  if config.showInfo then
    love.graphics.setColor(1, 1, 1)
    local sinceStart = math.floor((love.timer.getTime()-startTime)*10)/10
    sinceStart = formatTime(sinceStart)
    local str = "Len: "..#sortingList.." Base Len: "..config.listLength
    if config.showFPS then str = str.." FPS: "..love.timer.getFPS() end
    str = str.." Time: "..sinceStart.." Last Time: "..lastTime
    love.graphics.print(str, 5, 5)
  end

  if love.keyboard.isDown("i") then
    local i = 15+5
    love.graphics.setColor(1, 1, 1)
    for k, v in pairs(config) do
      if string.find(string.lower(k), "key") then
        love.graphics.print(k..": "..v, 5, i)
        i = i + 15
      end
    end
  end

  local curTime = love.timer.getTime()
  if nextDT <= curTime then
    nextDT = curTime
    return
  end
  love.timer.sleep(nextDT - curTime)
end
