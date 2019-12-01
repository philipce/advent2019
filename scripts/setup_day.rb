#!/usr/bin/ruby

def create_data_file(day)
  File.open("data/day#{day}.txt", 'w+')
end

def create_day_file(day)
  File.open("lib/day#{day}.rb", 'w+') do |file|
    file.write(day_class(day))
  end
end

def create_test_files(day, num_examples)
  ('a'..'z').to_a[0...num_examples].each do |letter|
    File.open("test/day#{day}#{letter}_test.rb", 'w+') do |file|
      file.write(test_class(day, letter))
    end
  end
end

def day_class(day)
  <<~DAY
    require_relative 'solver'

    class Day#{day} < Solver
      def get_data
      end

      def run_one
      end

      def run_two
      end
    end
  DAY
end

def test_class(day, letter)
  <<~TEST
    require 'test_helper'
    require_relative "../lib/day#{day}"

    class TestDay#{day}#{letter} < MiniTest::Test
      def setup
        @test_data = nil
        @result_one = nil
        @result_two = nil
        @solver = Day#{day}.new(@test_data)
      end

      def test_result_one
        assert_equal @solver.run_one, @result_one
      end

      def test_result_two
        assert_equal @solver.run_two, @result_two
      end
    end
  TEST
end

if ARGV.count > 1
  DAY_NUMBER, NUM_EXAMPLES, *REST = ARGV
else
  DAY_NUMBER = ARGV.first
  NUM_EXAMPLES = '1'
end

create_data_file(DAY_NUMBER)
create_day_file(DAY_NUMBER)
create_test_files(DAY_NUMBER, NUM_EXAMPLES.to_i)

