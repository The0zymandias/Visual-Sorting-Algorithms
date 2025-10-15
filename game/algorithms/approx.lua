return function(a)
  for i = 1, #a-1 do
    if a[i] > a[i + 1] then
      local pos = math.ceil((a[i+1] / a[i])*i)
      for j = i+1, pos+1, -1 do
        a[j], a[j - 1] = a[j - 1], a[j]
      end
      coroutine.yield(2, {pos})
      --[[
      while pos > 1 and a[pos] < a[pos - 1] do
        coroutine.yield(2, {pos})
        a[pos], a[pos - 1] = a[pos - 1], a[pos]
        pos = pos - 1
      end
      while pos < #a and a[pos] > a[pos + 1] do
        coroutine.yield(2, {pos})
        a[pos], a[pos + 1] = a[pos + 1], a[pos]
        pos = pos + 1
      end
      --]]
    end
  end
  for i=2, #a do
    local j = i
    local v = a[i]
    coroutine.yield(2, {j})
    while j > 1 and a[j-1] > v do
      a[j] = a[j-1]
      j = j - 1
      coroutine.yield(2, {j, i})
    end
    a[j] = v
  end
  coroutine.yield(0)
end