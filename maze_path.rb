require_relative 'matrix'

# Implementing a maze search
class MazePath
  WALL = Float::INFINITY
  START = 0
  VOID = nil
  TARGET = -Float::INFINITY

  def initialize(str)
    raise TypeError, 'Argument is not string' unless
        str.is_a? String

    @maze = create_matrix(str)
  end

  def path
    @maze.map { |value| replace(value) }
  end

  private

  def create_matrix(obj)
    n = obj[0] == "\n" ? 1 : 0
    row_count = obj.count("\n") - n
    column_count = (obj.size - row_count + n) / row_count
    array = obj.chars
    array.delete("\n")
    Matrix.new(row_count, column_count, array)
  end

  def replace(value)
    case value
    when @maze.first
      WALL
    when 'A'
      START
    when 'B'
      TARGET
    else
      VOID
    end
  end
end
