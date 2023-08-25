module Accessors
  def attr_accessor_with_history(*syms)
    syms.each do |sym|
      define_method(sym) { instance_variable_get("@#{sym}") }

      define_method("#{sym}_history") do
        instance_variable_get("@#{sym}_history") || instance_variable_set("@#{sym}_history", [])
      end

      define_method("#{sym}=") do |value|
        instance_variable_set("@#{sym}", value)
        send("#{sym}_history".to_sym) << value
      end
    end
  end
end
