class Solver
  def initialize(data=nil)
    @data = data
  end

  def data
    @data || get_data
  end

  def file_name
    "data/day#{self.class.to_s[3..4]}.txt"
  end

  def open_file
    File.open(file_name)
  end

  def get_data
    open_file.readlines
  end

  def run_one
    raise NotImplementedError
  end

  def run_two
    raise NotImplementedError
  end
end
