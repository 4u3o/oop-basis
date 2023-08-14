class Railway
  attr_reader :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def add_train(number, type)
    trains <<
      case type
      when :cargo then CargoTrain.new(number)
      when :passenger then PassengerTrain.new(number)
      end
  end

  def add_station(name)
    stations << Station.new(name)
  end

  def add_route(start_index, finish_index)
    routes << Route.new(stations.at(start_index), stations.at(finish_index))
  end

  def can_add_route?
    stations.size > 1
  end

  # def seed
  #   3.times do |index|
  #     stations << Station.new("Станция №#{index + 1}")
  #   end

  #   routes << Route.new(stations.first, stations.last)
  #   trains << Train.new('123', :cargo)
  # end
end
