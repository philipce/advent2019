require_relative "../lib/day#{ARGV.first}"

solver = eval("Day#{ARGV.first}").new
puts "\npart one: #{solver.run_one}"
puts "part two: #{solver.run_two}\n\n"

