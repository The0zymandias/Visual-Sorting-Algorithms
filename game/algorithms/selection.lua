return function(a)
  for i=1, #a do
    local min = i
    coroutine.yield(2, {i})
    for k=i+1, #a do
      if a[k] < a[min] then
        min = k
      end
      coroutine.yield(2, {k})
    end
    a[i], a[min] = a[min], a[i]
  end
  coroutine.yield(0)
end