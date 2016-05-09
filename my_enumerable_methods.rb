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

  def my_all?
    my_each { |element| return (yield element) }
  end

  def my_any?
    self.my_each do |element| 
      block_given? ? (yield element) : (return true if element)
    end
    false
  end

end
