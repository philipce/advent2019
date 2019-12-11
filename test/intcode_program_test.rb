require 'test_helper'
require_relative "../lib/intcode_program"

class IntcodeProgramTest < MiniTest::Test
  def test_simple_add_program
    memory = [1,0,0,0,99]
    p = IntcodeProgram.new(memory)
    p.run!
    assert_equal p.return_value, 2
  end

  def test_equal_to_position
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

  def test_equal_to_immediate
    # Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    memory = [3,3,1108,-1,8,3,4,3,99]

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

  def test_less_than_position
    # Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    memory = [3,9,7,9,10,9,4,9,99,-1,8]

    input_buffer = [9]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [0]

    input_buffer = [7]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [1]

    input_buffer = [8]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [0]
  end

  def test_less_than_immediate
    # Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    memory = [3,3,1107,-1,8,3,4,3,99]

    input_buffer = [9]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [0]

    input_buffer = [7]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [1]

    input_buffer = [8]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [0]
  end

  def test_jump
    # Here are some jump tests that take an input, then output 0 if the input was zero or 1 if the input was non-zero:

    # (using position mode)
    memory = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]

    input_buffer = [0]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [0]

    input_buffer = [345]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [1]

    # (using immediate mode)
    memory = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]

    input_buffer = [0]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [0]

    input_buffer = [678]
    p = IntcodeProgram.new(memory, input_buffer)
    p.run!
    assert_equal p.output_buffer, [1]
  end
end
