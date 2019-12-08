require_relative 'solver'

class Day03 < Solver
  def initialize(data=nil)
    super(data)

    raise "Unexpected input" if self.data.count != 2
    @moves1 = self.data.first.split(',')
    @moves2 = self.data.last.split(',')
  end

  def get_data
    input = super
    
  end

  def part_one
    coordinates1 = translate_moves_to_coordinates(origin, @moves1)
    coordinates2 = translate_moves_to_coordinates(origin, @moves2)
    intersections = (coordinates1 & coordinates2) - [origin]
    intersections.map { |coordinate| distance(coordinate, origin) }.min
  end

  def part_two
    coordinates1 = translate_moves_to_coordinates(origin, @moves1)
    coordinates2 = translate_moves_to_coordinates(origin, @moves2)
    intersections = (coordinates1 & coordinates2) - [origin]
    intersections.map do |coordinate|
        dist1 = coordinates1.index(coordinate)
        dist2 = coordinates2.index(coordinate)
        dist1 + dist2
    end.min
  end

  private

  def origin
    [0,0]
  end

  def distance(coordinate1, coordinate2)
    return (coordinate1[0]-coordinate2[0]).abs + (coordinate1[1]-coordinate2[1]).abs
  end

  def translate_moves_to_coordinates(start_coordinate, moves)
    coordinates = [start_coordinate]

    moves.each do |move|
      cur = coordinates.pop

      direction, distance = move.match(/^([RLUD])(\d+)$/)&.captures
      distance = distance.to_i
      raise "Invalid move: #{move}" unless direction && distance

      case direction
      when "R"
        x_vals = (cur[0]..cur[0]+distance).to_a
        y_vals = [cur[1]]*x_vals.length
      when "L"
        x_vals = cur[0].downto(cur[0]-distance).to_a
        y_vals = [cur[1]]*x_vals.length
      when "U"
        y_vals = (cur[1]..cur[1]+distance).to_a
        x_vals = [cur[0]]*y_vals.length
      when "D"
        y_vals = cur[1].downto(cur[1]-distance).to_a
        x_vals = [cur[0]]*y_vals.length
      else
        raise "Invalid direction: #{direction}"
      end

      coordinates.concat(x_vals.zip(y_vals))
    end

    return coordinates
  end
end