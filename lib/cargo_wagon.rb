class CargoWagon < Wagon
  attr_reader :volume_taken

  def initialize(volume_total)
    @type = :cargo
    @volume_total = volume_total
    @volume_taken = 0
  end

  def volume_free
    volume_total - volume_taken
  end

  def take_volume(volume)
    self.volume_taken += volume
  end

  private

  attr_reader :volume_total
  attr_writer :volume_taken
end
