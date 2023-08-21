class Route
  include InstanceCounter

  ADDING_INDEX = -2

  attr_reader :stations

  @counter = 0

  def initialize(start, finish)
    @stations = [start, finish]

    validate!

    register_instance
  end

  def add_station(station)
    stations.insert(ADDING_INDEX, station)
  end

  def delete_station(station)
    stations.delete(station) if station.trains.empty?
  end

  def index(station)
    stations.index(station)
  end

  def any_station_before?(station)
    !index(station).pred.negative?
  end

  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end

  private

  def validate!
    raise ArgumentError, 'Станции должны быть разными' if stations.first == stations.last
  end
end
