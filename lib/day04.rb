require_relative 'solver'

class Day04 < Solver
  def get_data
  end

  def part_one
    (LOWER_BOUND..UPPER_BOUND).select { |x| possible_password?(x) }.count
  end

  def part_two
  end

  private

  UPPER_BOUND = 579381
  LOWER_BOUND = 125730

  def possible_password?(password)
    adjacent_duplicate_digits?(password) && non_decreasing_digits?(password)
  end

  def adjacent_duplicate_digits?(password)
    !!(password.to_s =~ /([0-9])\1/)
  end

  def non_decreasing_digits?(password)
    password.to_s.chars.sort.join('').to_i == password
  end
end