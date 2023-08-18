class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
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
