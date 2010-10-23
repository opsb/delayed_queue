require 'test_helper'
puts "loaded"
class QueueTest < Test::Unit::TestCase
  should have_many(:jobs)
end