class PassengerTrain < Train
  @counter = 0

  def initialize(number)
    @type = :passenger
    super
  end
end
