class Train
  include Nameable
  include InstanceCounter
  include Validateable

  attr_accessor :speed
  attr_reader :station, :wagons, :type, :number

  @@trains = []
  @counter = 0

  class << self
    def find(number)
      @@trains.select { |train| train.number == number }.first
    end
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []

    validate!

    @@trains << self
    register_instance
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    wagons << wagon if speed.zero? && wagon.type == type
  end

  def subtract_wagon
    wagons.pop if speed.zero? && wagons.any?
  end

  def route=(route)
    @route = route
    self.station = route.stations.first
    station.accept_train(self)
  end

  def go_forward
    return if route.nil? || next_station.nil?

    station.dispatch_train(self)
    self.station = next_station
    station.accept_train(self)
    stop
  end

  def go_backward
    return if route.nil? || prev_station.nil?

    station.dispatch_train(self)
    self.station = prev_station
    station.accept_train(self)
    stop
  end

  def each_wagon
    wagons.each { |wagon| yield wagon }
  end

  protected

  NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i

  attr_reader :route
  attr_writer :station

  def validate!
    raise ArgumentError, 'Неверный формат' if number !~ NUMBER_FORMAT
  end

  def next_station
    route.stations.at(route.index(station).next)
  end

  def prev_station
    return unless route.any_station_before?(station)

    route.stations.at(route.index(station).pred)
  end
end
