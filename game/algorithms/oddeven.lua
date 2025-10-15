return function(a)
  local evenMax, oddMax
  if #a % 2 == 0 then
    evenMax = #a-1
    oddMax = #a
  else
    evenMax = #a
    oddMax = #a-1
  end
  repeat
    local haveSwapped = false
    for i=1, oddMax, 2 do
      if a[i] > a[i+1] then
        a[i], a[i+1] = a[i+1], a[i]
        haveSwapped = true
      end
      coroutine.yield(2, {i+1})
    end
    for i=2, evenMax, 2 do
      if a[i] > a[i+1] then
        a[i], a[i+1] = a[i+1], a[i]
        haveSwapped = true
      end
      coroutine.yield(2, {i+1})
    end
  until not haveSwapped
  coroutine.yield(0)
end