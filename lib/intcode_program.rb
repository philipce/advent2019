class IntcodeProgramError < StandardError
end

class IntcodeProgram
  def initialize(memory)
    @initial_memory = memory.dup
    @memory = memory.dup
    @instruction_pointer = 0
  end

  def memory
    @memory
  end

  def noun=(noun)
    @noun = noun
    @memory[1] = noun
  end

  def verb=(verb)
    @verb = verb
    @memory[2] = verb
  end

  def run!
    loop do
      i = next_instruction(memory)
      return memory if i.halt?
      i.perform!(memory)
    end
  end

  def output
    memory[0]
  end

  private

  def instruction_pointer
    @instruction_pointer
  end

  def increment_instruction_pointer(steps)
    raise IntcodeProgramError, "Invalid IP increment: #{steps}" unless steps > 0
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
          raise IntcodeProgramError, "Unknown length for op code: #{op_code}"
      end
    end

    def inputs
      @inputs ||= case op_code
        when *[ADD, MULT]
          @raw_instruction[1..2]
        when HALT
          []
        else
          raise IntcodeProgramError, "Unknown inputs for op code: #{op_code}"
      end
    end

    def output
      @output ||= case op_code
        when *[ADD, MULT]
          @raw_instruction[3]
        when HALT
          nil
        else
          raise IntcodeProgramError, "Unknown output for op code: #{op_code}"
      end
    end

    def perform!(memory)
      begin
        operand_l = memory[inputs[0]]
        operand_r = memory[inputs[1]]
        memory[output] = operand_l.send(operator, operand_r)
      rescue
        raise IntcodeProgramError, "Invalid operator/operands for instruction: #{self}"
      end
    end

    def operator
      @operator ||= case op_code
        when ADD
          :+
        when MULT
          :*
        when HALT
          nil
        else
          raise IntcodeProgramError, "Unknown operator for op code: #{op_code}"
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
          raise IntcodeProgramError, "Unknown mnemonic for op code: #{op_code}"
      end

      s += " #{inputs}" if !inputs.empty?
      s += " -> #{output}" if output
      s
    end
  end
end