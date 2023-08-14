class ConsoleInterface
  def initialize(railway)
    @railway = railway
  end

  def commands_list
    %(#{separator}
Введите номер нужной команды:
1 - Станции
2 - Поезда
3 - Маршруты
0 - Выйти отсюда.)
  end

  def get_input
    input = ''
    input = gets.chomp.downcase while input.empty?
    @current_input = input
  end

  def process_main
    case current_input
    when '1' then process_stations
    when '2' then process_trains
    when '3' then process_routes
    end
  end

  private

  UNDERLINE_SIZE = 10

  attr_reader :railway, :current_input
  attr_accessor :current_object

  def separator
    '-' * UNDERLINE_SIZE
  end

  def array_to_numerated_list(arr)
    arr.map.with_index(1) do |station, index|
      "#{index} - #{station}"
    end.join("\n")
  end

  def stations
    %(#{separator}
#{array_to_numerated_list(railway.stations)}

0 - перейти в главное меню
+ - добавить новую станцию)
  end

  def trains
    %(#{separator}
#{array_to_numerated_list(railway.trains)}

0 - перейти в главное меню
+ - добавить новый поезд)
  end

  def routes
    %(#{separator}
#{array_to_numerated_list(railway.routes)}

0 - перейти в главное меню
+ - добавить новый маршрут)
  end

  def process_stations
    puts stations
    case get_input
    when '0' then return
    when '+' then create_station
    when '1'..railway.stations.size.to_s 
      station = railway.stations.at(current_index)
      puts %(#{separator}
#{array_to_numerated_list(station.trains)})
    end

    process_stations
  end

  def process_trains
    puts trains
    case get_input
    when '0' then return
    when '+' then create_train
    when ('1'..railway.trains.size.to_s) then change_train
    end
    process_trains
  end

  def process_routes
    puts routes
    case get_input
    when '0' then return
    when '+' then create_route
    when ('1'..railway.routes.size.to_s) then change_route
    end
    process_routes
  end

  def create_station
    puts 'Введите название станции'
    name = get_input.capitalize
    railway.add_station(name)
  end

  def create_train
    puts 'Введите номер поезда'
    number = get_input
    puts %(Введите тип поезда:
1 - грузовой
2 - пассажирский)
    type =
      case get_input
      when '1' then :cargo
      when '2' then :passenger
      end
    railway.add_train(number, type)
  end

  def create_route
    return puts 'В базе не достаточно станций для создания маршрута' unless railway.can_add_route?

    puts %(Для создания маршрута введите через пробел номера двух станций:
#{array_to_numerated_list(railway.stations)})
    start, finish = get_input.split.map(&:to_i)
    railway.add_route(start - 1, finish - 1)
  end

  def current_index
    current_input.to_i.pred
  end

  def add_station
    selected_route = railway.routes.at(current_index)
    other_stations = railway.stations - selected_route.stations
    puts "#{separator}\n#{array_to_numerated_list(other_stations)}"
    selected_station = other_stations.at(get_input.to_i.pred)
    selected_route.add_station(selected_station)
  end

  def delete_station
    selected_route = railway.routes.at(current_index)
    puts "#{separator}\n#{array_to_numerated_list(selected_route.stations)}"
    selected_station = selected_route.stations.at(get_input.to_i.pred)
    selected_route.delete_station(selected_station)
  end

  def change_route
    puts %(#{separator}
#{railway.routes.at(current_input.to_i.pred)}

0 - перейти назад
+ - добавить станцию
- - удалить станцию)
    case get_input
    when '+' then add_station
    when '-' then delete_station
    end
  end

  def change_train
    train = railway.trains.at(current_input.to_i.pred)

    puts %(#{separator}
#{train}

0 - перейти назад
+ - добавить вагон
- - удалить вагон
$ - назначить маршрут
f - переместить вперед
b - переместить назад
)
    case get_input
    when '+'
      wagon =
        case train.type
        when :cargo then CargoWagon.new
        when :passenger then PassengerWagon.new
        end
      train.add_wagon(wagon)
    when '-' then train.subtract_wagon
    when '$'
      puts routes
      get_input
      train.route = railway.routes.at(current_input.to_i.pred)
    when 'f' then train.go_forward
    when 'b' then train.go_backward
    end
  end
end
