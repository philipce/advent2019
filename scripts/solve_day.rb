require_relative "../lib/day#{ARGV.first}"

solver = eval("Day#{ARGV.first}").new
puts "\npart one: #{solver.part_one}"
puts "part two: #{solver.part_two}\n\n"

