# frozen_string_literal: true

require_relative '../lib/accessors'
require 'test/unit'

class TestAccessor < Test::Unit::TestCase
  class Foo
    extend Accessors

    attr_accessor_with_history :name
    strong_attr_accessor :age, Integer
  end

  def setup
    @bar = Foo.new
    @bar.name = 'test'
  end

  def test_accessor_with_history_set_and_get_attr
    assert_equal('test', @bar.name)
  end

  def test_accessor_history
    assert_equal(['test'], @bar.name_history)

    @bar.name = 1
    assert_equal(['test', 1], @bar.name_history)
  end

  def test_strong_attr_accessor
    assert_raise(ArgumentError) do
      @bar.age = '1'
    end

    assert_nothing_raised do
      @bar.age = 1
    end

    assert_equal(1, @bar.age)
  end
end
