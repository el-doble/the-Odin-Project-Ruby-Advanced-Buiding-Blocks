def bubble_sort_by(array)
  array.each_index do |index|
    for i in 0...(array.length-1) - index
     array[i], array[i+1] = array[i+1], array[i] if (yield(array[i], array[i+1]) > 0)
    end
  end
  p array
end

bubble_sort_by(["hi","hello","hey",]) do |left,right|
  left.length - right.length
end