class PassengerWagon < Wagon
  TYPE = 'пассажирский'
  UNIT = 'место'

  def initialize(total_place)
    @type = :passenger
    super
  end

  def take_place
    raise ArgumentError, 'Нет свободных мест' if free_place.zero?

    self.used_place += 1
  end
end
