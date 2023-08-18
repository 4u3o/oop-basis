module InstanceCounter
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    attr_accessor :counter

    def instances
      counter
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.counter += 1
    end
  end
end
