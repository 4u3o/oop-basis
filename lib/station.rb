# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :trains

  strong_attr_accessor :name, String
  validate :name, :presence

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

  def each_train(&block)
    trains.each { |train| block.call(train) }
  end
end
