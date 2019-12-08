require 'test_helper'
require_relative "../lib/day04"

class TestDay04 < MiniTest::Test
  def setup
    @solver = Day04.new()
  end

  def test_part_one_actual_solution
    assert_equal @solver.part_one, 2081
  end

  def test_part_two_sanity_check
    assert_operator @solver.part_two, :<, @solver.part_one
  end

  def test_part_two_actual_solution
    assert_equal @solver.part_two, 1411
  end
end
