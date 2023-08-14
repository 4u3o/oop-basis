class Train
  attr_accessor :speed, :type
  attr_reader :station, :wagons

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @wagons = []
  end

  def standart_speed
  end

  def stop
    self.speed = 0
  end

  def speed_up
    self.speed = standart_speed
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

    speed_up
    station.dispatch_train(self)
    self.station = next_station
    station.accept_train(self)
    stop
  end

  def go_backward
    return if route.nil? || prev_station.nil?

    speed_up
    station.dispatch_train(self)
    self.station = prev_station
    station.accept_train(self)
    stop
  end

  def to_s
    type_name = case type
                  when :cargo then "Грузовой"
                  when :passenger then "Пассажирский"
                end
    info = "#{type_name} поезд №#{number}. #{wagons.size} вагон."
    info += "\nМаршрут: #{route}." if route
    info += " На станции: #{station}" if station
    info
  end

  protected

  attr_reader :route, :number
  attr_writer :station
end
