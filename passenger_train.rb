class PassengerTrain < Train
  def initialize(name)
    super(name, :passenger)
  end

  def standart_speed
    40
  end
end
