class ConsoleInterface
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def start
    loop do
      puts create(main_menu)

      command = input
      break unless main_menu.key?(command)

      send_action(command, main_menu)
    end
  end

  def create(menu)
    menu.map { |k, v| "#{k} - #{v[:text]}" }.join("\n")
  end

  def input
    gets.chomp
  end

  private

  NEED_STATIONS_FOR_ROUTE = 2

  attr_reader :stations, :trains, :routes

  def main_menu
    {
      '1' => {text: 'Станции', action: :process_stations},
      '2' => {text: 'Поезда', action: :process_trains},
      '3' => {text: 'Маршруты', action: :process_routes}
    }
  end

  def station_menu
    {
      '+' => {text: 'Добавить станцию', action: :create_station},
      '>' => {text: 'Посмотреть список поездов на станции', action: :show_trains}
    }
  end

  def route_menu
    {
      '+' => {text: 'Добавить маршрут', action: :create_route},
      '>' => {text: 'Изменить маршрут', action: :change_route}
    }
  end

  def train_menu
    {
      '+' => {text: 'Добавить поезд', action: :create_train},
      '>' => {text: 'Манипулировать поездом', action: :change_train}
    }
  end

  def type_menu
    {
      '1' => {text: 'Пассажирский', action: :create_passenger_train},
      '2' => {text: 'Грузовой', action: :create_cargo_train}
    }
  end

  def change_route_menu
    {
      '+' => {text: 'Добавить станцию', action: :add_station},
      '-' => {text: 'Удалить станцию', action: :delete_station}
    }
  end

  def change_train_menu
    {
      '+' => {text: 'Добавить вагон', action: :add_wagon},
      '-' => {text: 'Удалить вагон', action: :delete_wagon},
      '$' => {text: 'Назначить маршрут', action: :add_route},
      'f' => {text: 'Переместить вперед', action: :go_forward},
      'b' => {text: 'Переместить назад', action: :go_backward}
    }
  end

  def send_action(command, menu, *args)
    send(menu.dig(command, :action), *args)
  end

  def show(objs)
    objs.each_with_index { |obj, i| puts "#{i} - #{obj.inspect}" }
  end

  def pick_obj(objs)
    show(objs)
    index = input.to_i
    return unless (0...objs.size).include?(index)

    objs.at(index)
  end

  def process_objs(objs, objs_menu)
    show(objs) if objs.any?
    puts create(objs_menu)
    command = input
    return unless objs_menu.key?(command)

    send_action(command, objs_menu)

    process_objs(objs, objs_menu)
  end

  def process_stations
    process_objs(stations, station_menu)
  end

  def process_trains
    process_objs(trains, train_menu)
  end

  def process_routes
    process_objs(routes, route_menu)
  end

  def create_station
    puts 'Введите название станции'
    stations << Station.new(input.capitalize)
  end

  def show_trains
    return puts 'Станций нет' if stations.empty?

    station = pick_obj(stations)
    return puts 'Поездов нет' if station.trains.empty?

    show(station.trains)
  end

  def create_train
    puts 'Введите номер поезда'
    number = input
    puts "Введите тип поезда:\n#{create(type_menu)}"
    command = input
    return unless type_menu.key?(command)

    send_action(command, type_menu, number)
  end

  def create_cargo_train(number)
    trains << CargoTrain.new(number)
  end

  def create_passenger_train(number)
    trains << PassengerTrain.new(number)
  end

  def create_route
    return puts 'В базе не достаточно станций для создания маршрута' if stations.size < NEED_STATIONS_FOR_ROUTE

    puts 'Для создания маршрута введите через пробел номера двух станций:'
    show(stations)

    start_index, finish_index = input.split.map(&:to_i)
    routes << Route.new(stations[start_index], stations[finish_index])
  end

  def add_station(route)
    other_stations = stations - route.stations
    return puts 'Нет станций, который можно добавить' if other_stations.empty?

    station = pick_obj(other_stations)
    route.add_station(station)
  end

  def delete_station(route)
    station = pick_obj(route.stations)
    route.delete_station(station)
  end

  def change_objs(objs, objs_menu)
    return if objs.empty?

    obj = pick_obj(objs)
    p obj
    puts create(objs_menu)
    command = input
    return unless objs_menu.key?(command)

    send_action(command, objs_menu, obj)
  end

  def change_route
    change_objs(routes, change_route_menu)
  end

  def change_train
    change_objs(trains, change_train_menu)
  end

  def add_wagon(train)
    wagon = case train.type
            when :cargo then CargoWagon.new
            when :passenger then PassengerWagon.new
            end
    train.add_wagon(wagon)
  end

  def delete_wagon(train)
    train.subtract_wagon
  end

  def add_route(train)
    train.route = pick_obj(routes)
  end

  def go_forward(train)
    train.go_forward
  end

  def go_backward(train)
    train.go_backward
  end
end
