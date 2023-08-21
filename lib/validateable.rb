module Validateable
  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end
end
