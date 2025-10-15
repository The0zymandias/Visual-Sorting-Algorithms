local function swap(a, b, c) a[b], a[c] = a[c], a[b] end

local partition

partition = function(a, l, r)
  local m = l + math.floor((r-l)/2)

  ---[[ median of 3 pivot selection
  if a[m] < a[l] then swap(a, l, m) end
  if a[r] < a[l] then swap(a, l, r) end
  if a[m] < a[r] then swap(a, m, r) end
  --]]
  
  pivotVal = a[r]
  pivotIndex = l
  for i=l, r-1 do
    if a[i] < pivotVal then
      a[pivotIndex], a[i] = a[i], a[pivotIndex]
      pivotIndex = pivotIndex + 1
    end
    coroutine.yield(2, {pivotIndex, i})
  end
  a[pivotIndex], a[r] = a[r], a[pivotIndex]
  coroutine.yield(2, {pivotIndex, r})
  return pivotIndex
end

local quick
  
function quick(a, left, right, isSlave)
  left = left or 1
  right = right or #a
  if right > left then
    pivotIndex = partition(a, left, right)
    quick(a, left, pivotIndex-1, true)
    quick(a, pivotIndex+1, right, true)
  end
  if not isSlave then coroutine.yield(0) end
end

return quick