require_relative 'lib/station'
require 'test/unit'

class TestStation < Test::Unit::TestCase
  def test_all
    Station.new('name')
    assert_equal(Station.all.any?, true)
  end
end
