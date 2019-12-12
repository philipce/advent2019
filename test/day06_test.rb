require 'test_helper'
require_relative "../lib/day06"

class TestDay06 < MiniTest::Test
  def test_part_one_example
    solver = Day06.new(["COM)B", "B)C","C)D","D)E","E)F","B)G","G)H","D)I","E)J","J)K","K)L"])
    assert_equal solver.part_one, 42
  end

  def test_part_one_actual_solution
    solver = Day06.new()
    assert_equal solver.part_one, 314247
  end

  def test_part_two_example
  end
end
