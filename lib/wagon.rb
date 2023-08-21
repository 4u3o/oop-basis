class Wagon
  include Nameable

  attr_reader :type, :used_place

  def initialize(total_place)
    @total_place = total_place
    @used_place = 0
  end

  def free_place
    total_place - used_place
  end

  def take_place
    raise NotImplementedError
  end

  protected

  attr_reader :total_place
  attr_writer :used_place
end
