if jit then
  require "table.new"
  require "table.clear"
end

function fillList(length, t)
  if t and jit then
    table.clear(t)
  elseif jit then
    t = table.new(length, 0)
  else
    t = {}
  end
  
  for i = 1, length do
    t[i] = i
  end
  
  while #t > length do
    table.remove(t)
  end
  
  return t
end

function shuffleList(t)
  for i = 1, #t do
    local j = math.random(1, i)
    if i ~= j then
      t[i], t[j] = t[j], t[i]
    end
  end
end

function shuffleCo(t)
  for i=1, #t do
    local j = math.random(1, i)
    t[i], t[j] = t[j], t[i]
    coroutine.yield(2, {i, j})
  end
  coroutine.yield(0)
end