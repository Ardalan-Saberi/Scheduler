require 'minitest/autorun'
require 'pry-byebug'

Dir["./lib/*.rb"].each {|file| p file; require file }
