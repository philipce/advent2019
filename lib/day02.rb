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
    p = IntcodeProgram.new(data[0..-1])
    p.run!
    p.memory
  end

  def run_two
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
end
