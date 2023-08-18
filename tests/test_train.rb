require_relative '../lib/nameable'
require_relative '../lib/instance_counter'
require_relative '../lib/train'
require_relative '../lib/passenger_train'
require_relative '../lib/cargo_train'
require 'test/unit'

class TestTrain < Test::Unit::TestCase
  def test_find
    train = CargoTrain.new('123')

    assert_equal(Train.find('123'), train)
  end

  def test_instance_counter
    3.times { PassengerTrain.new('123') }

    assert_equal(3, PassengerTrain.instances)
    assert_equal(0, Train.instances)
    assert_equal(1, CargoTrain.instances)
  end

  def test_nameable
    train = Train.new('234')

    train.name = 'Name'

    assert_equal('Name', train.name)
  end
end
