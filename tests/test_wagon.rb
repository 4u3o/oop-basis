require_relative '../lib/nameable'
require_relative '../lib/wagon'
require 'test/unit'

class TestWagon < Test::Unit::TestCase
  def setup
    @wagon = Wagon.new(10)
  end

  def test_initialize
    assert_equal(10, @wagon.send(:total_place))
    assert_equal(10, @wagon.free_place)
    assert_equal(0, @wagon.used_place)
  end

  
end
