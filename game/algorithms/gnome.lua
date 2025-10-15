return function(a)
  local i = 2
  while i <= #a do
    if a[i] < a[i-1] then
      a[i], a[i-1] = a[i-1], a[i]
      i = i - 1
      if i == 1 then i = 2 end
    else
      i = i + 1
    end
    coroutine.yield(2, {i})
  end
  coroutine.yield(0)
end