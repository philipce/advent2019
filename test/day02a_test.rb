require 'test_helper'
require_relative "../lib/day02"

class TestDay02a < MiniTest::Test
  def setup
    @test_data = [1,0,0,0,99]
    @result_one = [2,0,0,0,99]
    @solver = Day02.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end

  def test_result_two
    desired_output = 19690720
    addend_a = 34
    addend_b = desired_output - addend_a

    @test_data << addend_a
    @test_data << addend_b

    assert_equal @solver.run_two, [5, 6]
  end
end
