local function merge(arr, start, mid, last)
  local start2 = mid + 1
  if not (arr[mid] <= arr[start2]) then
    while start <= mid and start2 <= last do
      if arr[start] <= arr[start2] then
        start = start + 1
        --coroutine.yield(2, {start, start2})
      else
        local value = arr[start2]
        local index = start2
        while index ~= start do
          coroutine.yield(2, {index})
          arr[index] = arr[index - 1]
          index = index - 1
        end
        
        arr[start] = value
        coroutine.yield(2, {start})
  
        start = start + 1
        mid = mid + 1
        start2 = start2 + 1
      end
    end
  end
end

local sort

function sort(arr, l, r, isClone)
  l = l or 1
  r = r or #arr
  if l < r then
    local m = l + math.floor( (r - l) / 2 )
    sort(arr, l, m, true)
    sort(arr, m+1, r, true)
    merge(arr, l, m, r)
  end
  if not isClone then coroutine.yield(0) end
end

return sort