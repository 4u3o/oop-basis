# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    # смущает, что .counter наружу торчит, а если зделать protected, то
    # у "наследника" NoMethodError
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
