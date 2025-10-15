return function(array)
  h = 1
  while h < #array do
    h = (3*h)+1
  end

  repeat
    h = math.floor(h/3)
    for i = 1, #array do
      temp = array[i]
      j = i - h
      while j >= 1 and array[j] > temp do
        array[j+h] = array[j]
        j = j - h
        coroutine.yield(2, {j+h})
      end 
      array[j+h] = temp
      coroutine.yield(2, {j+h})
      end
    coroutine.yield(2, {h})
  until h <= 1
  coroutine.yield(0)
end