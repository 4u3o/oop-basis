class PassengerWagon < Wagon
  TYPE = 'Пассажирский'
  UNIT = 'место'

  def initialize(total_place)
    @type = :passenger
    super
  end

  def take_place
    return if free_place.zero?

    self.used_place += 1
  end
end
