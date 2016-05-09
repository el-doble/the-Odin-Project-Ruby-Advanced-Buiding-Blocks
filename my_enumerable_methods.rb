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

end

