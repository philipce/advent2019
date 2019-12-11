class IntcodeProgram
  def initialize(memory, input_buffer=[], output_buffer=[])
    @memory = memory.dup
    @instruction_pointer = 0
    @input_buffer = input_buffer
    @output_buffer = output_buffer
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
      return if i.halting?
      i.perform!(memory, input_buffer, output_buffer)
    end
  end

  def return_value
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
    i = IntcodeInstruction.parse(memory[instruction_pointer..-1])
    increment_instruction_pointer(i.length)
    i
  end
end

class IntcodeProgramError < StandardError
end

class IntcodeInstruction
  def self.parse(memory_segment)
    op_code = parse_op_code(memory_segment[0])
    klass = lookup_op_code(op_code)
    klass.new(memory_segment[0...klass.length])
  end

  def initialize(raw_instruction)
    @raw_instruction = raw_instruction
  end

  def perform!(memory, input_buffer, output_buffer)
    raise "Override perform! method in subclass"
  end

  def op_code
    self.class.length
  end

  def length
    self.class.length
  end

  def halting?
    false
  end

  private_class_method def self.parse_op_code(value)
    ("%02s" % value).chars[-2..-1].join('').to_i
  end

  private_class_method def self.lookup_op_code(op_code)
    klasses = [Add, Mult, In, Out, Halt].find_all { |i| i.op_code == op_code }
    raise "Ambiguous/Invalid op code: #{op_code}" unless klasses.length == 1
    klasses.first
  end

  private

  def read_input_buffer(buffer)
    buffer.shift
  end

  def write_output_buffer(buffer, value)
    buffer << value
  end

  def resolve_input(input, memory)
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

class Add < IntcodeInstruction
  def self.op_code
    1
  end

  def self.length
    4
  end

  def perform!(memory, _, _)
    memory[raw_output] = resolved_inputs(memory)[0] + resolved_inputs(memory)[1]
  rescue
    raise IntcodeProgramError, "Unable to perform instruction: #{self}"
  end

  def to_s
    "ADD: #{raw_inputs} -> #{raw_output}"
  end

  private

  def raw_inputs
    @raw_inputs ||= begin
      values = @raw_instruction[1..2]
      modes = ("%04s" % @raw_instruction[0]).chars[-4..-3].map(&:to_i).reverse
      values.zip(modes).map { |v, m| { value: v, mode: m} }
    end
  end

  def resolved_inputs(memory)
    @resolved_inputs ||= raw_inputs.map { |input| resolve_input(input, memory) }
  end

  def raw_output
    @raw_instruction[3]
  end
end

class Mult < IntcodeInstruction
  def self.op_code
    2
  end

  def self.length
    4
  end

  def perform!(memory, _, _)
    memory[raw_output] = resolved_inputs(memory)[0] * resolved_inputs(memory)[1]
  rescue
    raise IntcodeProgramError, "Unable to perform instruction: #{self}"
  end

  def to_s
    "MULT: #{raw_inputs} -> #{raw_output}"
  end

  private

  def raw_inputs
    @raw_inputs ||= begin
      values = @raw_instruction[1..2]
      modes = ("%04s" % @raw_instruction[0]).chars[-4..-3].map(&:to_i).reverse
      values.zip(modes).map { |v, m| { value: v, mode: m} }
    end
  end

  def resolved_inputs(memory)
    @resolved_inputs ||= raw_inputs.map { |input| resolve_input(input, memory) }
  end

  def raw_output
    @raw_instruction[3]
  end
end

class In < IntcodeInstruction
  def self.op_code
    3
  end

  def self.length
    2
  end

  def perform!(memory, input_buffer, _)
    memory[raw_output] = resolved_input(input_buffer)[:value]
  end

  def to_s
    "IN: INPUT_BUFFER -> #{raw_output}"
  end

  private

  def resolved_input(input_buffer)
    i = read_input_buffer(input_buffer)
    raise IntcodeProgramError, "Error in #{self}: input buffer must give numeric value (got #{i})" unless i.to_i.to_s == i.to_s.strip
    { value: i, mode: 1 } # mode on this is always 1, since this param is written to
  end

  def raw_output
    @raw_instruction[1]
  end
end

class Out < IntcodeInstruction
  def self.op_code
    4
  end

  def self.length
    2
  end

  def perform!(memory, _, output_buffer)
    write_output_buffer(output_buffer, resolved_input(memory))
  end

  def to_s
    "OUT: #{input} -> OUTPUT_BUFFER"
  end

  private

  def raw_input
    @raw_input ||= begin
      value = @raw_instruction[1]
      mode = ("%03s" % @raw_instruction[0]).chars[-3].to_i
      { value: value, mode: mode }
    end
  end

  def resolved_input(memory)
    @resolved_input ||= resolve_input(raw_input, memory)
  end
end

class Halt < IntcodeInstruction
  def self.op_code
    99
  end

  def self.length
    1
  end

  def perform!(_, _, _)
    raise "EXECUTION HALTED!"
  end

  def halting?
    true
  end

  def to_s
    "HALT"
  end
end