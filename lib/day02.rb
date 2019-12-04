require_relative 'solver'
require_relative 'intcode_program'

class Day02 < Solver
  def get_data
    super.first.split(',').map(&:to_i)
  end

  def part_one
    default_noun = 12
    default_verb = 2

    p = IntcodeProgram.new(data[0..-1])
    p.noun = default_noun unless skip_noun?
    p.verb = default_verb unless skip_verb?

    p.run!
    p.memory
  end

  def part_two
    desired_output = 19690720

    nouns = (0..99).to_a
    verbs = (0..99).to_a
    nouns.product(verbs).each do |noun, verb|
      p = IntcodeProgram.new(data[0..-1])
      p.noun = noun
      p.verb = verb

      begin
        p.run!
      rescue IntcodeProgramError
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