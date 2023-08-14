require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'station'
require_relative 'route'
require_relative 'console_interface'
require_relative 'railway'

rail = Railway.new
cli = ConsoleInterface.new(rail)

# rail.seed

loop do
  puts cli.commands_list

  command = cli.get_input

  break if command == '0'

  cli.process_main
end
