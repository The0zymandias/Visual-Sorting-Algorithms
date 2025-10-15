local y = coroutine.yield

local heapify
function heapify(arr, n, i)
  local largest = i
  local left = 2 * i
  local right = 2 * i + 1

  if left <= n then
    y(2, {left, largest})
    if arr[left] > arr[largest] then
      largest = left
    end
  end

  if right <= n then
    y(2, {right, largest})
    if arr[right] > arr[largest] then
      largest = right
    end
  end

  y(2, {largest, i})
  if largest ~= i then
      arr[i], arr[largest] = arr[largest], arr[i]
      heapify(arr, n, largest)
  end
end

local buildMaxHeap
function buildMaxHeap(arr)
  local n = #arr
  for i = math.floor(n / 2), 1, -1 do
      heapify(arr, n, i)
  end
end

local heapSort
function heapSort(arr)
  buildMaxHeap(arr)
  local n = #arr
  for i = n, 2, -1 do
      arr[1], arr[i] = arr[i], arr[1]
      y(2, {1, i})
      n = n - 1
      heapify(arr, n, 1)
  end
  y(0)
end

return heapSort
