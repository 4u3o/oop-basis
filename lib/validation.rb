# frozen_string_literal: true

module Validation
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    VALIDATIONS = {
      presence: [proc { |attr| !attr.nil? && attr != '' }, 'Не инициализирован %s'],
      format: [proc { |attr, format| attr.match(format) }, 'Не верный формат %s'],
      type: [proc { |attr, klass| attr.is_a klass }, 'Не подходящий тип %s']
    }.freeze

    def validate(attr, validation, *args)
      define_method("validate_#{attr}_#{validation}") do
        attribute = instance_variable_get("@#{attr}")
        return if attribute.nil? && validation != :presence

        action, error_message = VALIDATIONS[validation]

        raise(ArgumentError, format(error_message, attr)) unless action.call(attribute, *args)
      end
    end
  end

  module InstanceMethods
    def validate!
      methods.grep(/validate_/).each { |validation| send(validation) }
    end

    def valid?
      validate!
      true
    rescue ArgumentError
      false
    end
  end
end
