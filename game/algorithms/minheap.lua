local y = coroutine.yield

local heapify
function heapify(arr, n, i)
  local smallest = i
  local left = 2 * i
  local right = 2 * i + 1

  if left <= n then
    y(2, {left, smallest})
    if arr[left] < arr[smallest] then
      smallest = left
    end
  end

  if right <= n then
    y(2, {right, smallest})
    if arr[right] < arr[smallest] then
      smallest = right
    end
  end

  y(2, {largest, i})
  if smallest ~= i then
      arr[i], arr[smallest] = arr[smallest], arr[i]
      heapify(arr, n, smallest)
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
