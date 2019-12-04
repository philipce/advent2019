require_relative 'solver'

class Day01 < Solver
  def get_data
    super.map(&:to_i)
  end

  def part_one
    data.map { |mass| simple_fuel_for_mass(mass) }.sum
  end

  def part_two
    data.map { |mass| complex_fuel_for_mass(mass) }.sum
  end

  private

  def simple_fuel_for_mass(mass)
    (mass / 3).floor - 2
  end

  NEGLIGIBLE_MASS_CUTOFF = 6 # at or below this mass, assume additional fuel needed is zero

  def complex_fuel_for_mass(mass)
    return 0 unless mass && mass > NEGLIGIBLE_MASS_CUTOFF

    fm = simple_fuel_for_mass(mass)
    fm + complex_fuel_for_mass(fm)
  end
end