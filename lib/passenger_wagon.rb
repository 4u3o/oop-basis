class PassengerWagon < Wagon
  attr_reader :seats_taken

  def initialize(seats_total)
    @type = :passenger
    @seats_total = seats_total
    @seats_taken = 0
  end

  def seats_free
    seats_total - seats_taken
  end

  def take_seat
    self.seats_taken += 1
  end

  private

  attr_reader :seats_total
  attr_writer :seats_taken
end
