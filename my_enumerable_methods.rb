#!/usr/bin/ruby

module Enumerable
	
  def my_each
    block_given? ? (for i in self; yield i; end) : self
  end

end

