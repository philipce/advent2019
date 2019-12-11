require 'test_helper'
require_relative "../lib/day02"

class TestDay02a < MiniTest::Test
  def test_part_one_example_1
    solver = Day02.new([1,0,0,0,99])
    solver.skip_noun!
    solver.skip_verb!

    assert_equal solver.part_one, [2,0,0,0,99]
  end

  def test_part_one_example_2
    solver = Day02.new([2,3,0,3,99])
    solver.skip_noun!
    solver.skip_verb!

    assert_equal solver.part_one, [2,3,0,6,99]
  end

  def test_part_one_example_3
    solver = Day02.new([2,4,4,5,99,0])
    solver.skip_noun!
    solver.skip_verb!

    assert_equal solver.part_one, [2,4,4,5,99,9801]
  end

  def test_part_one_example_4
    solver = Day02.new([1,1,1,4,99,5,6,0,99])
    solver.skip_noun!
    solver.skip_verb!

    assert_equal solver.part_one, [30,1,1,4,2,5,6,0,99]
  end

  def test_part_one_actual_solution
    solver = Day02.new()
    assert_equal solver.part_one.first, 5290681
  end

  def test_part_two
    desired_output = 19690720
    addend_a = 34
    addend_b = desired_output - addend_a
    solver = Day02.new([1,0,0,0,99, addend_a, addend_b])

    assert_equal solver.part_two, [5, 6]
  end

  def test_part_two_actual_solution
    solver = Day02.new()
    noun, verb = solver.part_two
    assert_equal 100 * noun + verb, 5741
  end
end
