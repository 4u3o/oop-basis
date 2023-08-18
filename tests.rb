require_relative 'lib/station'
require_relative 'lib/nameable'
require_relative 'lib/train'
require_relative 'lib/cargo_train'
require 'test/unit'

class TestStation < Test::Unit::TestCase
  def test_all
    station = Station.new('name')

    assert_true(Station.all.any?)
    assert_equal(Station.all.last, station)
  end
end

class TestTrain < Test::Unit::TestCase
  def test_find
    train = CargoTrain.new('123')

    assert_equal(Train.find('123'), train)
  end
end
