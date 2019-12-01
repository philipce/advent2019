require 'test_helper'
require_relative "../lib/day01"

class TestDay01d < MiniTest::Test
  def setup
    @test_data = [100756]
    @result_one = 33583
    @result_two = 50346
    @solver = Day01.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end

  def test_result_two
    assert_equal @solver.run_two, @result_two
  end
end
