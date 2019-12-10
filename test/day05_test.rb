require 'test_helper'
require_relative "../lib/day05"

class TestDay05 < MiniTest::Test
  def setup
    @solver = Day05.new()
  end

  def test_part_one_actual_solution
    assert_equal @solver.part_one, [0, 0, 0, 0, 0, 0, 0, 0, 0, 7259358]
  end
end
