require_relative 'solver'
require_relative 'intcode_program'

class Day05 < Solver
  def get_data
    super.first.split(',').map(&:to_i)
  end

  def part_one
    p = IntcodeProgram.new(data[0..-1], [1])
    p.run!
    p.output_buffer
  end

  def part_two
  end
end