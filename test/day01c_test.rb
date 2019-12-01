require 'test_helper'
require_relative "../lib/day01"

class TestDay01c < MiniTest::Test
  def setup
    @test_data = [1969]
    @result_one = 654
    @result_two = 966
    @solver = Day01.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end

  def test_result_two
    assert_equal @solver.run_two, @result_two
  end
end
