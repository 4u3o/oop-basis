# frozen_string_literal: true

require_relative '../lib/instance_counter'
require_relative '../lib/validation'
require_relative '../lib/accessors'
require_relative '../lib/station'
require 'test/unit'

class TestStation < Test::Unit::TestCase
  def test_all
    station = Station.new('name')

    assert_true(Station.all.any?)
    assert_equal(Station.all, [station])
  end

  def test_instance_counter
    assert_equal(1, Station.instances)
  end

  def test_name_validate
    assert_raise(ArgumentError) do
      Station.new('')
    end
  end
end
