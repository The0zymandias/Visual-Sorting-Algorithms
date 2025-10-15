local yield = coroutine.yield

local function swap(l, a, b)
  l[a], l[b] = l[b], l[a]
end

local function insertion(a, l, h)
  for i=l+1, h do
    local j = i
    local v = a[i]
    coroutine.yield(2, {j})
    while j > l and v < a[j-1] do
      a[j] = a[j-1]
      j = j - 1
      coroutine.yield(2, {j, i})
    end
    a[j] = v
  end
end

local function partition(a, l, h)
  --print(l, h)
  local m = l + math.floor((h-l)/2)
  
  -- median of 3 pivot selection
  if a[m] < a[l] then swap(a, l, m) end
  if a[h] < a[l] then swap(a, l, h) end
  if a[m] < a[h] then swap(a, m, h) end
  
  local pivot = a[h]

  local i = l - 1
  local j = h + 1
  
  while true do
    i = i + 1
    while a[i] < pivot do 
      i = i + 1
      --[[if i < #a and a[i] > a[i+1] then
        swap(a, i, i+1)
        yield(2, {i, i+1})
      else]]
        yield(2, {i})
      --[[end]]
    end

    j = j - 1
    while a[j] > pivot do
      j = j - 1
      --[[if j > 1 and a[j] < a[j- 1] then
        swap(a, j, j- 1)
        yield(2, {j, j- 1})
      else]]
        yield(2, {j})
      --[[end]]
    end

    if i >= j then return j end

    yield(2, {i, j})
    swap(a, i, j)
  end
end

local helper

function helper(a, l, h, maxdepth)
  if h - l <= 0 then return
  elseif maxdepth == 0 then
    insertion(a, l, h)
  else
    local p = partition(a, l, h)
    helper(a, l, p, maxdepth-1)
    helper(a, p+1, h, maxdepth-1)
  end
end

local function intersort(a)
  local maxdepth = math.floor(math.log(#a, 2))*2
  --print(maxdepth)
  helper(a, 1, #a, maxdepth)
  coroutine.yield(0)
end

return intersort