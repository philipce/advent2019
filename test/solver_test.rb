require 'test_helper'
require_relative '../lib/solver'

class SolutionTest < Minitest::Test
  def setup
    @solver = ::Solver.new('data')
  end

  def test_responds_to_parse_data
    assert_respond_to @solver, :parse_data
  end

  def test_parse_data_unimplemented
    assert_raises(NotImplementedError) { @solver.parse_data }
  end

  def test_responds_to_solution
    assert_respond_to @solver, :solution
  end

  def test_solution_unimplemented
    assert_raises(NotImplementedError) { @solver.solution }
  end

  def test_responds_to_run
    assert_respond_to @solver, :run
  end

  def test_run
    def @solver.solution; 'solution'; end
    assert_equal @solver.run, 'solution'
  end
end
