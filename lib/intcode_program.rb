class IntcodeProgram
  def initialize(memory)
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
      i = next_instruction
      return if i.halt?
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

  def next_instruction
    i = IntcodeInstruction.new(memory[instruction_pointer..-1])
    increment_instruction_pointer(i.length)
    i
  end
end

class IntcodeProgramError < StandardError
end

class IntcodeInstruction
  # op codes
  ADD = 1
  MULT = 2
  HALT = 99

  def initialize(memory_segment)
    @op_code = parse_op_code(memory_segment[0])
    @raw_instruction = memory_segment[0...length]
  end

  def op_code
    @op_code
  end

  def parse_op_code(value)
    ("%02s" % value).chars[-2..-1].join('').to_i
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
        values = @raw_instruction[1..2]
        modes = ("%04s" % @raw_instruction[0]).chars[-4..-3].map(&:to_i).reverse
        values.zip(modes).map { |v, m| { value: v, mode: m} }
      when HALT
        []
      else
        raise IntcodeProgramError, "Unknown inputs for op code: #{op_code}"
    end
  end

  def resolved_inputs(memory)
    @resolved_inputs ||= inputs.map do |input|
      case input[:mode]
      when 0
        memory[input[:value]]
      when 1
        input[:value]
      else
        raise IntcodeProgramError, "Unknown input mode for input: #{input}"
      end
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
      operand_l = resolved_inputs(memory)[0]
      operand_r = resolved_inputs(memory)[1]
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