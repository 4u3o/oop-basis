class Station
  attr_reader :trains

  @stations = []

  class << self
    attr_reader :stations

    def all
      stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    self.class.stations << self
  end

  def accept_train(train)
    trains << train
  end

  def dispatch_train(train)
    trains.delete(train)
  end

  def trains_by_type(type)
    trains.filter { |train| train.type == type }
  end

  private

  attr_reader :name
end
