return function(a)
  for i = 2, #a do
    local j = i
    coroutine.yield(2, {j})
    while j > 1 and a[j] < a[j - 1] do
      a[j], a[j - 1] = a[j - 1], a[j]
      j = j - 1
      coroutine.yield(2, {i, j})
    end
  end
  coroutine.yield(0)
end