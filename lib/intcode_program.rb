class IntcodeProgram
  def initialize(memory, input_buffer=[])
    @memory = memory.dup
    @input_buffer = input_buffer
    @output_buffer = []
    @instruction_pointer = 0
  end

  def memory
    @memory
  end

  def input_buffer
    @input_buffer
  end

  def output_buffer
    @output_buffer
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
    i = IntcodeInstruction.new(memory[instruction_pointer..-1], input_buffer, output_buffer)
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
  IN = 3
  OUT = 4
  HALT = 99

  def initialize(memory_segment, input_buffer, output_buffer)
    @op_code = parse_op_code(memory_segment[0])
    @raw_instruction = memory_segment[0...length]
    @input_buffer = input_buffer
    @output_buffer = output_buffer
  end

  def op_code
    @op_code
  end

  def parse_op_code(value)
    ("%02s" % value).chars[-2..-1].join('').to_i
  end

  def read_input_buffer
    @input_buffer.shift
  end

  def write_output_buffer(val)
    @output_buffer << val
  end

  def length
    @length ||= case op_code
      when *[ADD, MULT]
        4
      when *[IN, OUT]
        2
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
      when IN
        i = read_input_buffer
        raise IntcodeProgramError, "Invalid input for #{op_code}: #{i}; must be numeric" unless i.to_i.to_s == i.to_s.strip
        [{ value: i, mode: 1 }] # Tmode on this is always 1, since this param is written to
      when OUT
        mode = ("%03s" % @raw_instruction[0]).chars[-3].to_i
        value = @raw_instruction[1]
        [{ value: value, mode: mode }]
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
      when IN
        @raw_instruction[1]
      when *[OUT, HALT]
        nil
      else
        raise IntcodeProgramError, "Unknown output for op code: #{op_code}"
    end
  end

  def perform!(memory)
    case op_code
    when *[ADD, MULT]
      operand_l = resolved_inputs(memory)[0]
      operand_r = resolved_inputs(memory)[1]
      memory[output] = operand_l.send(operator, operand_r)
    when IN
      memory[output] = resolved_inputs(memory)[0]
    when OUT
      write_output_buffer(resolved_inputs(memory)[0])
    when HALT
    else
      raise IntcodeProgramError, "Unknown output for op code: #{op_code}"
    end
  rescue
    raise IntcodeProgramError, "Unable to perform instruction: #{self}"
  end

  def operator
    @operator ||= case op_code
      when ADD
        :+
      when MULT
        :*
      when *[IN, HALT]
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
      when IN
        "IN"
      when OUT
        "OUT"
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