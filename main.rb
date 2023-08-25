# frozen_string_literal: true

require_relative 'lib/validation'
require_relative 'lib/accessors'
require_relative 'lib/instance_counter'
require_relative 'lib/nameable'
require_relative 'lib/train'
require_relative 'lib/cargo_train'
require_relative 'lib/passenger_train'
require_relative 'lib/wagon'
require_relative 'lib/cargo_wagon'
require_relative 'lib/passenger_wagon'
require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'lib/console_interface'

cli = ConsoleInterface.new
cli.start
