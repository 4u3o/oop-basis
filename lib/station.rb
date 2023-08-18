class Station
  include InstanceCounter

  attr_reader :trains

  @stations = []
  @counter = 0

  class << self
    attr_reader :stations

    def all
      stations
    end
  end

  def initialize(name)
    register_instance

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
