require_relative '../lib/nameable'
require_relative '../lib/validateable'
require_relative '../lib/instance_counter'
require_relative '../lib/train'
require_relative '../lib/passenger_train'
require_relative '../lib/cargo_train'
require_relative '../lib/wagon'
require_relative '../lib/cargo_wagon'
require 'test/unit'

class TestTrain < Test::Unit::TestCase
  def setup
    @cargo_train = CargoTrain.new('123-fm')
  end

  def test_find
    train = CargoTrain.new('test1')
    assert_equal(Train.find('test1'), train)
  end

  def test_instance_counter
    3.times { PassengerTrain.new('123-fm') }

    assert_equal(3, PassengerTrain.instances)
    assert_equal(0, Train.instances)
  end

  def test_nameable
    @cargo_train.name = 'Name'

    assert_equal('Name', @cargo_train.name)
  end

  def test_number_validate
    valid_numbers = ['123-fm', '12345', 'sdf12', 's23-1d']
    invalid_numbers = ['12-d32', 'ds22', 's2_12', '', 'asd-13a', 'ads1-qw']

    assert_nothing_raised do
      valid_numbers.each do |number|
        Train.new(number)
      end
    end

    assert_raise(ArgumentError) do
      invalid_numbers.each do |number|
        Train.new(number)
      end
    end
  end

  def test_each_wagon
    train = CargoTrain.new('new-10')
    wagons = []
    3.times { wagons << CargoWagon.new(10) }

    wagons.each { |wagon| train.add_wagon(wagon) }

    train.each_wagon { |wagon| assert_equal(10, wagon.free_place) }
  end
end
