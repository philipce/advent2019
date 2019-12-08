require_relative 'solver'

class Day04 < Solver
  def get_data
  end

  def part_one
    (LOWER_BOUND..UPPER_BOUND).select do |x|
      adjacent_duplicate_digits?(x) && non_decreasing_digits?(x)
    end.count
  end

  def part_two
    (LOWER_BOUND..UPPER_BOUND).select do |x|
      exactly_two_adjacent_duplicate_digits?(x) && non_decreasing_digits?(x)
    end.count
  end

  private

  UPPER_BOUND = 579381
  LOWER_BOUND = 125730

  def adjacent_duplicate_digits?(password)
    !!(password.to_s =~ /([0-9])\1/)
  end

  def exactly_two_adjacent_duplicate_digits?(password)
    !!(password.to_s =~ /^([0-9])\1(?!\1)|([0-9])(?!\2)([0-9])\3(?!\3)/)
  end

  def non_decreasing_digits?(password)
    password.to_s.chars.sort.join('').to_i == password
  end
end