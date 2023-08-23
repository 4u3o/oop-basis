# frozen_string_literal: true

require_relative '../lib/nameable'
require_relative '../lib/wagon'
require_relative '../lib/cargo_wagon'
require 'test/unit'

class TestCargoWagon < Test::Unit::TestCase
  def setup
    @wagon = CargoWagon.new(10)
  end

  def test_take_place
    @wagon.take_place(6)

    assert_equal(6, @wagon.used_place)
    assert_equal(4, @wagon.free_place)
  end
end
