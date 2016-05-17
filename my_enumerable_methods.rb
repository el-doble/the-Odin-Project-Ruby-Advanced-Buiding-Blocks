#!/usr/bin/ruby

module Enumerable

# each
	
  def my_each
    block_given? ? (for element in self; yield element; end) : self.to_enum
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

# all?

  # all? [{ |obj| block } ] → true or false
  # Passes each element of the collection to the given block.
  # The method returns true if the block never returns false or nil.
  # If the block is not given, Ruby adds an implicit block of { |obj| obj } 
  # which will cause all? to return true when none of the collection members
  # are false or nil.

  # %w[ant bear cat].all? { |word| word.length >= 3 } #=> true
  # %w[ant bear cat].all? { |word| word.length >= 4 } #=> false
  # [nil, true, 99].all?                              #=> false

  def my_all?
    self.my_each do |element| 
      return false unless (yield element) if block_given? 
      return false unless element
    end
    return true
  end

# any?

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

# none?

  #  none? [{ |obj| block }] → true or false
  # Passes each element of the collection to the given block.
  # The method returns true if the block never returns true for all elements.
  # If the block is not given, none? will return true only if 
  # none of the collection members is true.

  # %w{ant bear cat}.none? { |word| word.length == 5 } #=> true
  # %w{ant bear cat}.none? { |word| word.length >= 4 } #=> false
  # [].none?                                           #=> true
  # [nil].none?                                        #=> true
  # [nil, false].none?                                 #=> true


  def my_none?
    self.my_each do |element|
      block_given? ? (return false if yield element) : (return false if element)
    end
    true
  end

# count

  # count → int
  # count(item) → int
  # count { |obj| block } → int
  # Returns the number of items in enum through enumeration.
  # If an argument is given, the number of items in enum that are equal to 
  # item are counted. If a block is given, it counts 
  # the number of elements yielding a true value.

  # ary = [1, 2, 4, 2]
  # ary.count               #=> 4
  # ary.count(2)            #=> 2
  # ary.count{ |x| x%2==0 } #=> 3

  def my_count(num=nil)
    count = 0
    if block_given?
      self.my_each { |element| count += 1 if (yield element) }
      return count
    elsif num
      self.my_each { |element| count += 1 if element == num }  
      return count
    else
      self.length
    end
  end

# map

  # map { |obj| block } → array
  # map → an_enumerator
  # Returns a new array with the results of running block once for every 
  # element in enum. If no block is given, an enumerator is returned instead.

  # (1..4).map { |i| i*i }      #=> [1, 4, 9, 16]
  # (1..4).collect { "cat"  }   #=> ["cat", "cat", "cat", "cat"]

  def my_map
    results = []
    self.my_each do |element|
      block_given? ? results << (yield element) : (return self.to_enum)
    end
    results
  end

  # my_map modified to take a proc instead

  # proc = Proc.new { |i| i*i }
  # p (1..4).my_map(&proc) #=> [1, 4, 9, 16]

  def my_map(&proc)
    results = []
    self.my_each do |element|
      block_given? ? results << (proc.call(element)) : (return self.to_enum)
    end
    results
  end

  # my_map modified to take either a block, a proc or both,
  # but executing the block only if both are supplied 
  # (in which case it executes both the block AND the proc).

  # proc = Proc.new { |i| i * i }
  # (1..4).my_map(proc) #=> [1, 4, 9, 16]
  # (1..4).my_map(proc) { |i| i + i } #=> [2, 8, 18, 32]

  def my_map(proc=nil, &block)
    results = []
    if proc && block.nil?
      my_each { |element| results << (proc.call(element)) }
    elsif proc && block_given?
      proc_results = []
      my_each { |element| proc_results << (proc.call(element)) }
      proc_results.my_each { |element| results << (yield element) }
    else
      return self.to_enum
    end
    results
  end

# inject (alias reduce)

  # inject(initial, sym) → obj
  # inject(sym) → obj
  # inject(initial) { |memo, obj| block } → obj
  # inject { |memo, obj| block } → obj
  # Combines all elements of enum by applying a binary operation,
  # specified by a block or a symbol that names a method or operator.
  # If you specify a block, then for each element in enum 
  # the block is passed an accumulator value (memo) and the element.
  # If you specify a symbol instead, then each element in the collection 
  # will be passed to the named method of memo.
  # In either case, the result becomes the new value for memo. 
  # At the end of the iteration,
  # the final value of memo is the return value for the method.
  # If you do not explicitly specify an initial value for memo,
  # then the first element of collection is used as the initial value of memo.

  # # Sum some numbers
  # (5..10).reduce(:+)                             #=> 45
  # # Same using a block and inject
  # (5..10).inject { |sum, n| sum + n }            #=> 45
  # # Multiply some numbers
  # (5..10).reduce(1, :*)                          #=> 151200
  # # Same using a block
  # (5..10).inject(1) { |product, n| product * n } #=> 151200
  # # find the longest word
  # longest = %w{ cat sheep bear }.inject do |memo, word|
  #    memo.length > word.length ? memo : word
  # end
  # longest                                        #=> "sheep"

  def my_inject(memo=nil, symbol=nil)
    (skip_first = true; memo = first) unless memo
    my_each do |element|
      unless skip_first && element == first
        if block_given?
          memo = yield memo, element
        else
          (symbol = memo; memo = first) unless symbol
          unless element == first && memo == first
            memo = memo.send(symbol, element)
          end
        end
      end
    end
    memo
  end

end

def multiply_els(array)
  array.my_inject(:*)
end

p multiply_els([2,4,5])