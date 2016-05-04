def bubble_sort(array)
  #loop through array keeping track of each numbers index
  array.each_index do |index|
    # loop from 0 to penultimate number (minus index each time because 
    # largest number will be at the end after each iteration)
    for i in 0...(array.length-1) - index
      # compare each number to the one next to it and
      # switch elements position if first element is larger than the second
      array[i], array[i+1] = array[i+1], array[i] if array[i] > array[i+1]
    end
  end
  return array
end

p bubble_sort([4,3,78,2,0,2])