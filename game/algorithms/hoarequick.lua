local yield = coroutine.yield

local function swap(l, a, b) l[a], l[b] = l[b], l[a] end

local partition

partition = function(a, l, r) 
  local m = l + math.floor((r-l)/2)

  ---[[ median of 3 pivot selection
  if a[m] < a[l] then swap(a, l, m) end
  if a[r] < a[l] then swap(a, l, r) end
  if a[m] < a[r] then swap(a, m, r) end
  swap(a, r, m)
  --]]
  
  local pivotVal = a[m]
  local i = l-1 
  local j = r+1
  while true do
    while true do
      i = i + 1
      yield(2, {i, j})
      if a[i] >= pivotVal then break end
    end
    while true do
      j = j - 1
      yield(2, {i, j})
      if a[j] <= pivotVal then break end
    end
    --repeat i = i + 1; yield(2, {i}) until (a[i] < pivotVal)
    --repeat j = j - 1; yield(2, {j}) until (a[i] > pivotVal)

    if i >= j then return i end

    a[i], a[j] = a[j], a[i]
    yield(2, {i, j})
  end
end

local quick

function quick(a, left, right, isSlave)
  left = left or 1
  right = right or #a
  if right > left then
    pivotIndex = partition(a, left, right)
    quick(a, left, pivotIndex, true)
    quick(a, pivotIndex+1, right, true)
  end
  if not isSlave then coroutine.yield(0) end
end

return quick