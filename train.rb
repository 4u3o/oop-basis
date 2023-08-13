class Train
  attr_accessor :speed, :type
  attr_reader :wagon_count, :station

  def initialize(number, type, wagon_count)
    @number = number
    @type = type
    @wagon_count = wagon_count
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def add_wagon
    self.wagon_count += 1 if speed.zero?
  end

  def subtract_wagon
    self.wagon_count -= 1 if speed.zero? && wagon_count.positive?
  end

  def route=(route)
    @route = route
    self.station = route.stations.first
    self.station_num = 0
    station.accept_train(self)
  end

  def next_station
    route.stations.at(station_num + 1)
  end

  def prev_station
    return nil if (station_num - 1).negative?

    route.stations.at(station_num - 1)
  end

  def go_forward
    return nil if route.nil? || next_station.nil?

    self.speed = 10
    station.dispatch_train(self)
    self.station = next_station
    self.station_num += 1
    station.accept_train(self)
    stop
  end

  def go_backward
    return nil if route.nil? || prev_station.nil?

    self.speed = 10
    station.dispatch_train(self)
    self.station = prev_station
    self.station_num -= 1
    station.accept_train(self)
    stop
  end

  private

  attr_reader :route
  attr_writer :wagon_count, :station
  attr_accessor :station_num
end
