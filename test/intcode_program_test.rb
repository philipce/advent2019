require 'test_helper'
require_relative "../lib/intcode_program"

class IntcodeProgramTest < MiniTest::Test
  def test_simple_add_program
    memory = [1,0,0,0,99]
    p = IntcodeProgram.new(memory)
    p.run!
    assert_equal p.return_value, 2
  end

  def test_equal_to
    # Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    memory = [3,9,8,9,10,9,4,9,99,-1,8]
    
    input_buffer = [9]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [0]

    input_buffer = [7]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [0]

    input_buffer = [8]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [1]
  end
end
