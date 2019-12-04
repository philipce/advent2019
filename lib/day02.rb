require_relative 'solver'
require_relative 'intcode_program'

class Day02 < Solver
  def get_data
    super.first.split(',').map(&:to_i)
  end

  def part_one
    # default noun and verb for part 1
    @noun ||= 12
    @verb ||= 2

    p = IntcodeProgram.new(data[0..-1])
    p.noun = @noun unless skip_noun?
    p.verb = @verb unless skip_verb?

    p.run!
    p.memory
  end

  def part_two
    nouns = (0..99).to_a
    verbs = (0..99).to_a

    desired_output = 19690720

    nouns.product(verbs).each do |noun, verb|
      init_memory = data[0..-1]
      init_memory[1] = noun
      init_memory[2] = verb

      p = IntcodeProgram.new(init_memory)

      begin
        p.run!
      rescue => e # TODO: rescue computer errors only
        next
      end

      return noun, verb if p.output == desired_output
    end

    raise "Unable to find satisfying inputs"
  end

  def skip_noun?
    @skip_noun ||= false
  end

  def skip_noun!
    @skip_noun = true
  end

  def skip_verb?
    @skip_verb ||= false
  end

  def skip_verb!
    @skip_verb = true
  end
end
