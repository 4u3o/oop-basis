class CargoTrain < Train
  @counter = 0

  def initialize(number)
    @type = :cargo
    super
  end
end
