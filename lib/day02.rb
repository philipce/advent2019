require_relative 'solver'

class Day02 < Solver
  def get_data
    d = super.first.split(',').map(&:to_i)

    # TODO: handle this in a better way, on init of computer/program class
    # default noun and verb for part 1
    d[1] = 12
    d[2] = 2
    d
  end

  def run_one
    memory = data[0..-1]
    run_program!(memory)
  end

  def run_two
    nouns = (0..99).to_a
    verbs = (0..99).to_a

    desired_output = 19690720

    nouns.product(verbs).each do |noun, verb|
      memory = data[0..-1]
      memory[1] = noun
      memory[2] = verb

      begin
        run_program!(memory)
      rescue => e # TODO: rescue computer errors only
        next
      end

      return noun, verb if memory[0] == desired_output
    end

    raise "Unable to find satisfying inputs"
  end

  private

  # TODO: extract computer/program class

  def run_program!(memory)
    reset_instruction_pointer # TODO: this shouldn't be shared from computer to computer

    loop do
      i = next_instruction(memory)
      i.perform!(memory)
      return memory if i.halt?
    end
  end

  def reset_instruction_pointer
    @instruction_pointer = 0
  end

  def instruction_pointer
    @instruction_pointer ||= 0
  end

  def increment_instruction_pointer(steps)
    raise "Invalid IP increment: #{steps}" unless steps > 0
    @instruction_pointer += steps
  end

  def next_instruction(memory)
    i = Instruction.new(memory[instruction_pointer..-1])
    increment_instruction_pointer(i.length)
    i
  end

  class Instruction
    # op codes
    ADD = 1
    MULT = 2
    HALT = 99

    def initialize(memory_segment)
      @op_code = memory_segment[0]
      @raw_instruction = memory_segment[0...length]
    end

    def op_code
      @op_code
    end

    def length
      @length ||= case op_code
        when *[ADD, MULT]
          4
        when HALT
          1
        else
          raise "Unknown length for op code: #{op_code}"
      end
    end

    def inputs
      @inputs ||= case op_code
        when *[ADD, MULT]
          @raw_instruction[1..2]
        when HALT
          []
        else
          raise "Unknown inputs for op code: #{op_code}"
      end
    end

    def output
      @output ||= case op_code
        when *[ADD, MULT]
          @raw_instruction[3]
        when HALT
          nil
        else
          raise "Unknown output for op code: #{op_code}"
      end
    end

    def perform!(memory)
      if add?
        memory[output] = memory[inputs[0]] + memory[inputs[1]]
      elsif mult?
        memory[output] = memory[inputs[0]] * memory[inputs[1]]
      end
    end

    def add?
      op_code == ADD
    end

    def mult?
      op_code == MULT
    end

    def halt?
      op_code == HALT
    end

    def to_s
      s = case op_code
        when ADD
          "ADD"
        when MULT
          "MULT"
        when HALT
          "HALT"
        else
          raise "Unknown mnemonic for op code: #{op_code}"
      end

      s += " #{inputs}" if !inputs.empty?
      s += " -> #{output}" if output
      s
    end
  end
end
