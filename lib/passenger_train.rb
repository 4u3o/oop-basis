class PassengerTrain < Train
  TYPE = 'пассажирский'

  @counter = 0

  def initialize(number)
    @type = :passenger
    super
  end
end
