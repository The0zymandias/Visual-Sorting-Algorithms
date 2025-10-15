local function swap(arr, a, b)
  arr[a], arr[b] = arr[b], arr[a]
end

local siftDown
function siftDown(arr, root, dist, a)
  while root <= math.floor(dist/2) do
    local leaf = 2 * root

    if leaf < dist and arr[a+leaf] < arr[a+leaf+1] then
      leaf = leaf + 1
    end

    if arr[a+root] < arr[a+leaf] then
      swap(arr, a+root, a+leaf)
      root = leaf
    else
      break
    end
  end
end

local heapify
function heapify(arr, a, b)
  local length = math.floor((b-a)/2)
  for i=length, 1, -1 do
    siftDown(arr, i, length, a)
  end
end

local sort
function sort(arr, a, b)
  heapify(arr, a, b)
  for i=b-a, 2, -1 do
    swap(arr, a, a+i-1)
    siftDown(arr, 1, i-1, a)
  end
end

return function() coroutine.yield(0) end