require 'test_helper'
require_relative "../lib/day01"

class TestDay01a < MiniTest::Test
  def test_part_one_example_1
    assert_equal Day01.new([12]).part_one, 2
  end

  def test_part_one_example_2
    assert_equal Day01.new([14]).part_one, 2
  end

  def test_part_one_example_3
    assert_equal Day01.new([1969]).part_one, 654
  end

  def test_part_one_example_4
    assert_equal Day01.new([100756]).part_one, 33583
  end

  def test_part_two_example_1
    assert_equal Day01.new([12]).part_two, 2
  end

  def test_part_two_example_2
    assert_equal Day01.new([14]).part_two, 2
  end

  def test_part_two_example_3
    assert_equal Day01.new([1969]).part_two, 966
  end

  def test_part_two_example_4
    assert_equal Day01.new([100756]).part_two, 50346
  end
end
