require 'test_helper'
require_relative "../lib/intcode_program"

class IntcodeProgramTest < MiniTest::Test
  def test_simple_add_program
    memory = [1,0,0,0,99]
    p = IntcodeProgram.new(memory)
    p.run!
    assert_equal p.return_value, 2
  end
end
