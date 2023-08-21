class CargoTrain < Train
  TYPE = 'грузовой'

  @counter = 0

  def initialize(number)
    @type = :cargo
    super
  end
end
