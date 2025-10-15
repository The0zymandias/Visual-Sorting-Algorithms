return function(a)
  if #a == 2 then
    if a[1] > a[2] then
      a[1], a[2] = a[2], a[1]
    end
    coroutine.yield(0)
  end
  local startIndex = 1
  local endIndex = #a - 1
  while startIndex <= endIndex do
    local tempEndI = endIndex
    for i = startIndex, endIndex do
      if a[i] > a[i+1] then
        a[i], a[i+1] = a[i+1], a[i]
        tempEndI = i
      end
      coroutine.yield(2, {i+1})
    end
    endIndex = tempEndI - 1
    local tempStartI = startIndex
    for i = endIndex, startIndex, -1 do
      if a[i] > a[i+1] then
        a[i], a[i+1] = a[i+1], a[i]
        tempStartI = i
      end
      coroutine.yield(2, {i})
    end
    startIndex = tempStartI + 1
  end
  coroutine.yield(0)
  return a
end