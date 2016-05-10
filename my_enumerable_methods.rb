#!/usr/bin/ruby

module Enumerable

# each
	
  def my_each
    block_given? ? (for element in self; yield element end) : self.to_enum
  end

# each_with_index

  # each_with_index(*args) { |obj, i| block } → enum
  # each_with_index(*args) → an_enumerator
  # Calls block with two arguments, the item and its index,
  # for each item in enum. Given arguments are passed through to each().
  # If no block is given, an enumerator is returned instead.

  # hash = Hash.new
  # %w(cat dog wombat).each_with_index { |item, index|
  #   hash[item] = index
  # }
  # hash   #=> {"cat"=>0, "dog"=>1, "wombat"=>2}


  def my_each_with_index
    return self.to_enum unless block_given?
    for element in self
      yield element, self.index(element) 
    end
  end

# select (alias find_all)

  # find_all { |obj| block } → array click to toggle source
  # find_all → an_enumerator
  # Returns an array containing all elements of enum for which
  # the given block returns a true value.
  # If no block is given, an Enumerator is returned instead.

  # (1..10).find_all { |i|  i % 3 == 0 }   #=> [3, 6, 9]
  # [1,2,3,4,5].select { |num|  num.even?  }   #=> [2, 4]


  def my_select
    return self.to_enum unless block_given?
    results = []
    self.my_each { |element| results << element if yield element }
    results
  end

# all? [{ |obj| block } ] → true or false

  # Passes each element of the collection to the given block.
  # The method returns true if the block never returns false or nil.
  # If the block is not given, Ruby adds an implicit block of { |obj| obj } 
  # which will cause all? to return true when none of the collection members
  # are false or nil.

  # %w[ant bear cat].all? { |word| word.length >= 3 } #=> true
  # %w[ant bear cat].all? { |word| word.length >= 4 } #=> false
  # [nil, true, 99].all?                              #=> false


  def my_all?(block=lambda { |obj| obj })
    self.my_each do |element| 
      return (yield element) if block_given?
      block.call(element) ? (return true) : (return false)
    end
  end

# any? [{ |obj| block }] → true or false click to toggle source

  # Passes each element of the collection to the given block.
  # The method returns true if the block ever returns a value other than false
  # or nil. If the block is not given, Ruby adds an implicit block of 
  # { |obj| obj } that will cause any? to return true if at least one of 
  # the collection members is not false or nil.

  # %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
  # %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
  # [nil, true, 99].any?                              #=> true


  def my_any?
    self.my_each do |element| 
      block_given? ? (yield element) : (return true if element)
    end
    false
  end

# count

  # count → int click to toggle source
  # count(item) → int
  # count { |obj| block } → int

  # Returns the number of items in enum through enumeration.
  # If an argument is given, the number of items in enum that are equal to 
  # item are counted. 
  # If a block is given, it counts the number of elements yielding a true value.

end


