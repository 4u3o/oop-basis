# frozen_string_literal: true

require_relative '../lib/nameable'
require_relative '../lib/wagon'
require_relative '../lib/passenger_wagon'
require 'test/unit'

class TestPassengerWagon < Test::Unit::TestCase
  def setup
    @wagon = PassengerWagon.new(10)
  end

  def test_take_place
    @wagon.take_place

    assert_equal(1, @wagon.used_place)
    assert_equal(9, @wagon.free_place)
  end
end
