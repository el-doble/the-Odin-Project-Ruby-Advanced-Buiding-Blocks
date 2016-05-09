#!/usr/bin/ruby

module Enumerable
	
  def my_each
    block_given? ? (for element in self; yield element end) : self
  end

  def my_each_with_index
    self unless block_given?
    for element in self
      yield element, self.index(element) 
    end
  end

  def my_select
    results = []
    my_each do |element|
      results << element if yield element
    end
    results
  end

end


