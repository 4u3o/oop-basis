# frozen_string_literal: true

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

  def train_type_menu
    {
      '1' => {text: 'Пассажирский', class: PassengerTrain},
      '2' => {text: 'Грузовой', class: CargoTrain}
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
      '@' => {text: 'Занять вагон', action: :use_wagon},
      '$' => {text: 'Назначить маршрут', action: :add_route},
      'f' => {text: 'Переместить вперед', action: :go_forward},
      'b' => {text: 'Переместить назад', action: :go_backward}
    }
  end

  def create_wagon_types
    {
      cargo: [CargoWagon, 'Введите объем вагона'],
      passenger: [PassengerWagon, 'Введите количество мест']
    }
  end

  def use_wagon_actions_by
    {cargo: :take_volume, passenger: :take_seat}
  end

  def create(menu)
    menu.map { |k, v| "#{k} - #{v[:text]}" }.join("\n")
  end

  def input(prompt = nil)
    puts prompt unless prompt.nil?
    gets.chomp
  end

  def send_action(command, menu, *args)
    send(menu.dig(command, :action), *args)
  end

  def show(objs)
    objs.each_with_index { |obj, i| puts "#{i} - #{obj.inspect}" }
  end

  def pick_obj(objs, prompt = 'Введите номер')
    show(objs)
    puts prompt
    index = input.to_i
    unless (0...objs.size).include?(index)
      puts 'Такого номера нет'
      return pick_obj(objs, prompt)
    end

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
    name = input('Введите название станции').capitalize
    station = Station.new(name)
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
    number = input('Введите номер поезда в формате "а12-z1" или "а12я1"')
    command = input("Введите тип поезда:\n#{create(train_type_menu)}")
    return unless train_type_menu.key?(command)

    train = train_type_menu.dig(command, :class).new(number)
    trains << train

    puts "Поезд #{train_info(train)} успешно создан" if train.valid?
  rescue ArgumentError => e
    puts e.message
    retry
  end

  def create_route
    return puts 'В базе не достаточно станций для создания маршрута' if stations.size < NEED_STATIONS_FOR_ROUTE

    first_station = pick_obj(stations, 'Введите номер станции начала маршрута')
    last_station = pick_obj(stations, 'Введите номер конца маршрута')
    route = Route.new(first_station, last_station)
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
    puts obj.inspect

    command = input(create(objs_menu))
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
    train.add_wagon(create_wagon(train.type))
  end

  def create_wagon(type)
    typeclass, space_prompt = create_wagon_types[type]
    space = input(space_prompt).to_i
    wagon = typeclass.new(space)
    puts "Создан новый вагон: #{wagon_info(wagon)}"
    wagon
  rescue ArgumentError => e
    puts e.error
    retry
  end

  def delete_wagon(train)
    train.subtract_wagon
  end

  def add_route(train)
    train.route = pick_obj(routes) if routes.any?
  end

  def go_forward(train)
    train.go_forward
  end

  def go_backward(train)
    train.go_backward
  end

  def train_info(train)
    "#{train.number}, #{train.class::TYPE}, #{train.wagons.size} вагонов"
  end

  def wagon_info(wagon)
    "#{wagon.class::TYPE}, свободно #{wagon.free_place}, " \
      "занято #{wagon.used_place} #{wagon.class::UNIT}"
  end

  def show_wagons(train)
    index = 0
    train.each_wagon do |wagon|
      puts "#{index} - #{wagon_info(wagon)}"
      index += 1
    end
  end

  def use_wagon(train)
    wagon = pick_obj(train.wagons)
    action = use_wagon_actions_by[wagon.type]
    send(action, wagon)
  end

  def take_seat(wagon)
    wagon.take_place
    puts 'Место успешно занято'
  rescue ArgumentError => e
    puts e.message
  end

  def take_volume(wagon)
    volume =
      input(
        "Свободно #{wagon.free_place}#{wagon.class::UNIT}. Введите нужный объем"
      ).to_i

    wagon.take_place(volume)

    puts 'Объем успешно занят'
  rescue ArgumentError => e
    puts e.message
    retry
  end
end
