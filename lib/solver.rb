class Solver
  def initialize(data)
    @data = data
  end

  def parse_data
    raise NotImplementedError
  end

  def solution
    raise NotImplementedError
  end

  def run
    solution
  end
end
