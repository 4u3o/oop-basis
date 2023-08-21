class Station
  include InstanceCounter

  attr_reader :trains

  @stations = []
  @counter = 0

  class << self
    def all
      @stations
    end
  end

  def initialize(name)
    register_instance

    @name = name
    @trains = []

    validate!

    self.class.all << self
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

  def each_train
    trains.each { |train| yield train }
  end

  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end

  private

  attr_reader :name

  def validate!
    raise ArgumentError, 'Имя не может быть пустым' if name.empty?
  end
end
