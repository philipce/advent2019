#!/usr/bin/ruby

def create_data_file(day)
  File.open("data/day#{day}.json", 'w+')
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
    require 'solver'

    class Day#{day} < Solver
      def parse_data
        raise NotImplementedError
      end

      def solution
        raise NotImplementedError
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
        @data = "!!update this!!"
        @expected_result = "!!update this!!"
        @solver = Day#{day}.new(@data)
      end

      def test_parse_data_is_defined
        assert @solver.parse_data
      end

      def test_result
        assert_equal @solver.run, @expected_result
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

