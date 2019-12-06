require 'test_helper'
require_relative "../lib/day03"

class TestDay03 < MiniTest::Test
  def test_part_one_example_1
    solver = Day03.new(["R8,U5,L5,D3", "U7,R6,D4,L4"])
    assert_equal solver.part_one, 6
  end

  def test_part_one_example_2
    solver = Day03.new(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"])
    assert_equal solver.part_one, 159
  end

  def test_part_one_example_3
    solver = Day03.new(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"])
    assert_equal solver.part_one, 135
  end
end
