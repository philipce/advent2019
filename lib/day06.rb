require_relative 'solver'
require_relative 'intcode_program'

class Day06 < Solver
  def part_one
    direct_orbits = Hash.new { |h, k| h[k] = [] }
    data.each do |line|
      orbitee, orbiter = line.strip.split(')')
      direct_orbits[orbiter] << orbitee
    end

    # pp direct_orbits

    all_orbits = Hash.new { |h, k| h[k] = [] }
    direct_orbits.each do |orbiter, direct_orbitees|
      frontier = direct_orbitees.dup
      visited = [orbiter]

      while !frontier.empty? do
        cur_node = frontier.pop
        next if visited.include?(cur_node)

        all_orbits[orbiter] << cur_node
        visited << cur_node

        if all_orbits.has_key?(cur_node)
          all_orbits[orbiter].concat(all_orbits[cur_node])
        else
          frontier.concat(direct_orbits[cur_node]) if direct_orbits.has_key?(cur_node)
        end
      end
    end

    # pp all_orbits

    all_orbits.values.reduce(0) { |sum, arr| sum + arr.count }
  end

  def part_two

  end
end