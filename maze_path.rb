require_relative 'matrix'

# Implementing a maze search
class MazePath
  WALL = Float::INFINITY
  START = 0
  VOID = nil
  TARGET = -Float::INFINITY
  RELATIVE_DIRECTION = %i[left up right down].freeze

  def initialize(str)
    raise TypeError, 'Argument is not string' unless
        str.is_a? String

    @maze = create_matrix(str)
  end

  def path
    map = @maze.map { |value| replace(value) }
    start_index = [map.find_index(START)]
    target_index = [map.find_index(TARGET)]
    fill_maze(map, start_index)
    reconstruction_the_path(map, target_index)
  end

  private

  def reconstruction_the_path(map, index)
    path = []
    distance = (map[*index[0]] - 1)
    distance.downto(0) do |integer|
      index = expand(index)
      path << find_next!(map, index, integer)
      p path
    end
    path.reverse
  end

  # fill the maze with the distance from the start
  def fill_maze(map, index)
    distance = 1
    stop = '0'
    loop do
      index = expand(index)
      mark!(map, index, distance, stop)
      distance += 1
      break if stop == '1'
    end
  end

  # get the index of neighboring cells
  def expand(index)
    tmp = []
    index.each do |key|
      RELATIVE_DIRECTION.each { |dir| tmp << send(dir, key.dup) }
    end
    tmp
  end

  # deletes keys if there is a wall in their place
  # and fills the map with a distance from the start
  def mark!(map, index, distance, stop)
    index.delete_if do |key|
      case map[*key]
      when VOID
        map[*key] = distance
        false
      when TARGET
        map[*key] = distance
        stop.next!
        false
      else
        true
      end
    end
  end

  # finds the cell with distance per one less
  # overwrites the index
  # and returns the relative direction
  def find_next!(map, index, integer, path = nil, number = 0, catch = nil)
    index.delete_if do |key|
      if map[*key].equal?(integer) && catch.nil?
        path = (RELATIVE_DIRECTION[number - 2])
        catch = true
        false
      else
        number += 1
        true
      end
    end
    path
  end

  def left(obj)
    obj[1] = obj[1] - 1
    obj
  end

  def right(obj)
    obj[1] = obj[1] + 1
    obj
  end

  def up(obj)
    obj[0] = obj[0] - 1
    obj
  end

  def down(obj)
    obj[0] = obj[0] + 1
    obj
  end

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