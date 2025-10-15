return function(a)
  for i = 1, #a do
    for j = 1, #a - i do
      if a[j] > a[j + 1] then
        a[j], a[j + 1] = a[j + 1], a[j]
        coroutine.yield(2, {j+1})
      else
        coroutine.yield(2, {j})
      end
    end
  end
  coroutine.yield(0)
end