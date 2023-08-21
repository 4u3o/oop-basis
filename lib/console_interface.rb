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
      '?' => {text: 'Список вагонов', action: :show_wagons},
      '@' => {text: 'Занять вагон', action: :take_wagon},
      '$' => {text: 'Назначить маршрут', action: :add_route},
      'f' => {text: 'Переместить вперед', action: :go_forward},
      'b' => {text: 'Переместить назад', action: :go_backward}
    }
  end

  def wagon_info
    {cargo: :cargo_wagon_info, passenger: :passenger_wagon_info}
  end

  def create(menu)
    menu.map { |k, v| "#{k} - #{v[:text]}" }.join("\n")
  end

  def input
    gets.chomp
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
    station = Station.new(input.capitalize)
    stations << station
    puts "Станция #{station.inspect} успешно создана" if station.valid?
  rescue ArgumentError => e
    puts e.message
    retry
  end

  def show_trains
    return puts 'Станций нет' if stations.empty?

    station = pick_obj(stations)
    return puts 'Поездов нет' if station.trains.empty?

    station.each_train { |train| puts train_info(train) }
  end

  def create_train
    puts 'Введите номер поезда в формате "а12-z1" или "а12я1"'
    number = input
    puts "Введите тип поезда:\n#{create(type_menu)}"
    command = input
    return unless type_menu.key?(command)

    train = send_action(command, type_menu, number)

    puts "Поезд #{train.inspect} успешно создан" if train.valid?
  rescue ArgumentError => e
    puts e.message
    retry
  end

  def create_cargo_train(number)
    train = CargoTrain.new(number)
    trains << train
    train
  end

  def create_passenger_train(number)
    train = PassengerTrain.new(number)
    trains << train
    train
  end

  def create_route
    return puts 'В базе не достаточно станций для создания маршрута' if stations.size < NEED_STATIONS_FOR_ROUTE

    puts 'Для создания маршрута введите через пробел номера двух станций:'
    show(stations)

    start_index, finish_index = input.split.map(&:to_i)
    return create_route if finish_index.nil?

    route = Route.new(stations[start_index], stations[finish_index])
    routes << route
    puts "Маршрут #{route.inspect} успешно создан" if route.valid?
  rescue ArgumentError => e
    puts e.message
    retry
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
            when :cargo then create_cargo_wagon
            when :passenger then create_passenger_wagon
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

  def create_cargo_wagon
    puts 'Введите объем вагона'
    seats_total = input.to_i
    wagon = CargoWagon.new(seats_total)
    puts "Вагон #{wagon.inspect} успешно создан"
    wagon
  rescue ArgumentError => e
    puts e.error
    retry
  end

  def create_passenger_wagon
    puts 'Введите количество мест'
    volume_total = input.to_i
    wagon = PassengerWagon.new(volume_total)
    puts "Вагон #{wagon.inspect} успешно создан"
    wagon
  rescue ArgumentError => e
    puts e.error
    retry
  end

  def train_info(train)
    type = {cargo: 'Грузовой', passenger: 'Пассажирский'}[train.type]
    "#{train.number}, #{type}, #{train.wagons.size} вагонов"
  end

  def passenger_wagon_info(wagon)
    "Пассажирский, свободно #{wagon.seats_free}, занято #{wagon.seats_taken} мест"
  end

  def cargo_wagon_info(wagon)
    "Грузовой, свободно #{wagon.volume_free}, занято #{wagon.volume_taken} объема"
  end

  def show_wagons(train)
    index = 0
    train.each_wagon do |wagon|
      puts "#{index} - #{send(wagon_info[wagon.type], wagon)}"
      index += 1
    end
  end

  def take_wagon(train)
    return puts 'Выгонов нет' if train.wagons.empty?

    show_wagons(train)

    puts 'Введите номер вагона'
    number = input.to_i
    return take_wagon(train) if number > train.wagons.size || number.negative?

    wagon = train.wagons.at(number)
    send({cargo: :take_volume, passenger: :take_seat}[train.type], wagon)
  end

  def take_seat(wagon)
    return puts 'Мест нет' if wagon.seats_free.zero?

    wagon.take_seat
    puts 'Место успешно занято'
  end

  def take_volume(wagon)
    puts 'Введите занимаемый объем'
    volume = input.to_i

    if volume > wagon.volume_free
      puts 'В вагоне нет столько места'
      return take_volume(wagon)
    end

    wagon.take_volume(volume)
    puts 'Объем успешно занят'
  end
end
