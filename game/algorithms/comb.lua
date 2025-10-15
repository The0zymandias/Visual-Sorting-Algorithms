return function(a)
  local gap, shrink, sorted = #a, 1.3, false
  while not sorted do
    gap = math.floor(gap/shrink)
    if gap <= 1 then
      sorted = true
    elseif gap == 9 or gap == 10 then
      gap = 11
    end

    local i = 1
    while i + gap <= #a do
      if a[i] > a[i+gap] then
        a[i], a[i+gap] = a[i+gap], a[i]
        coroutine.yield(2, {i})
        sorted = false
      end
      coroutine.yield(2, {i+gap})
      i = i + 1
    end --i + gap <= #a
    coroutine.yield(2, {i+gap})
  end --not sorted
  coroutine.yield(0)
end