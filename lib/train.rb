class Train
  include Nameable
  include InstanceCounter

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
    register_instance

    @number = number
    @speed = 0
    @wagons = []
    @@trains << self
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

  def next_station
    route.stations.at(route.station_index(station).next)
  end

  def prev_station
    return unless route.any_station_before?(station)

    route.stations.at(route.station_index(station).pred)
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

  protected

  attr_reader :route
  attr_writer :station
end
