class CargoWagon < Wagon
  TYPE = 'грузовой'
  UNIT = 'м3'

  def initialize(total_place)
    @type = :cargo
    super
  end

  def take_place(place)
    raise ArgumentError, 'Не достаточно свободного места' if free_place < place

    self.used_place += place
  end
end
