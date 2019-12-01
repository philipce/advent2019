require 'test_helper'
require_relative "../lib/day01"

class TestDay01 < MiniTest::Test
  def setup
    @result_one = 3425624
    @result_two = 5135558
    @solver = Day01.new()
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end

  def test_result_two
    assert_equal @solver.run_two, @result_two
  end
end
