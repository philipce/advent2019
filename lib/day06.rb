require_relative 'solver'
require 'set'

class Day06 < Solver
  def direct_orbits
    @direct_orbits ||= begin
      direct_orbits = Hash.new { |h, k| h[k] = [] }
      data.each do |line|
        orbitee, orbiter = line.strip.split(')')
        direct_orbits[orbiter] << orbitee
      end
      direct_orbits
    end
  end

  def all_orbits
    @all_orbits ||= begin
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
      all_orbits
    end
  end

  def adjacent_objects
    @adjacent_objects ||= begin
      adjacent_objects = Hash.new { |h, k| h[k] = Set.new }
      data.each do |line|
        obj1, obj2 = line.strip.split(')')
        adjacent_objects[obj1] << obj2
        adjacent_objects[obj2] << obj1
      end
      adjacent_objects
    end
  end

  def part_one
    all_orbits.values.reduce(0) { |sum, arr| sum + arr.count }
  end

  def part_two
    raise "Couldn't find start node" if direct_orbits["YOU"].count != 1
    start_node = direct_orbits["YOU"].first

    raise "Couldn't find goal node" if direct_orbits["SAN"].count != 1
    goal_node = direct_orbits["SAN"].first

    frontier = direct_orbits[start_node].dup.map { |n| [start_node, n] }
    visited = ["YOU", start_node]

    while !frontier.empty? do
      cur_node = frontier.shift
      next if visited.include?(cur_node.last)

      visited << cur_node.last

      neighbors = adjacent_objects[cur_node.last]
      if neighbors.include?(goal_node)
        return cur_node.count
      end

      neighbors.each do |n|
        next if visited.include?(n)
        frontier << cur_node.dup.concat(Array(n))
      end
    end
  end
end