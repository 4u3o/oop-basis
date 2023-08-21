class CargoWagon < Wagon
  TYPE = 'Грузовой'
  UNIT = 'м3'

  def initialize(total_place)
    @type = :cargo
    super
  end

  def take_place(place)
    return if free_place < place

    self.used_place += place
  end
end
