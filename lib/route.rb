class Route
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    stations.delete(station) if station.trains.empty?
  end

  def station_index(station)
    stations.index(station)
  end

  def any_station_before?(station)
    !station_index(station).pred.negative?
  end
end
