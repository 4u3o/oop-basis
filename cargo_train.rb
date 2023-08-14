class CargoTrain < Train
  def initialize(name)
    super(name, :cargo)
  end

  def standart_speed
    50
  end
end
