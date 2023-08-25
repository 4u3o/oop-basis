# frozen_string_literal: true

require_relative '../lib/instance_counter'
require_relative '../lib/validation'
require_relative '../lib/accessors'
require_relative '../lib/station'
require_relative '../lib/route'
require 'test/unit'

class TestRoute < Test::Unit::TestCase
  def test_instance_counter
    2.times { |i| Station.new("Станция #{i}") }

    Route.new(*Station.all)

    assert_equal(1, Route.instances)
  end
end
