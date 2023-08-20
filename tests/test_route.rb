require_relative '../lib/instance_counter'
require_relative '../lib/station'
require_relative '../lib/route'
require 'test/unit'

class TestRoute < Test::Unit::TestCase
  def test_instance_counter
    2.times.with_index { |i| Station.new("Станция #{i}") }

    Route.new(*Station.all)

    assert_equal(1, Route.instances)
  end

  def test_stations_validate
    assert_raise(ArgumentError) do
      Route.new(Station.all.first, Station.all.first)
    end
  end
end
