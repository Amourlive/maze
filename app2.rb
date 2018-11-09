require_relative 'task'

class SymbolPath

  ROUTE = %i[down left up right].freeze
  OPTION = { down: [1, 0], left: [0, -1], up: [-1, 0], right: [0, 1] }.freeze

  def initialize(maze_map)
    @maze = parse_maze(maze_map)
    @sample_path = []
  end

  def find_path
    filling_maze
    write_path
  end

  private

  # record the path from the zero point to the target
  def write_path
    current = find_target('B')[0]
    target = find_target(0)[0]
    sequent = nil
    key = nil
    sample_path = []
    loop do
      ROUTE.each_with_index do |direction, index|
        cell = value_at(current, direction)
        next if cell.class == String || cell.nil?
        if (sequent || (cell + 1)) > cell
          sequent = cell
          key = index
        end
      end
      current = [current[0] + OPTION[ROUTE[key]][0],
                 current[1] + OPTION[ROUTE[key]][1]]
      sample_path << ROUTE[(key + 2) % 4]
      break if current == target
    end
    sample_path.reverse
  end

  # fills the labyrinth the distance from the zero point
  def filling_maze
    distance = 0
    stop = nil
    loop do
      find_target(distance).each do |index|
        ROUTE.each do |direction|
          stop = true unless move(index, direction, distance + 1)
        end
      end
      break if stop
      distance += 1
    end
  end

  # return content of cell in the double array
  def value_at(index, direction)
    @maze[index[0] + OPTION[direction][0]][index[1] + OPTION[direction][1]]
  end

  # write to cell in the double array
  def write_to_cell(index, direction, content)
    @maze[index[0] + OPTION[direction][0]][index[1] + OPTION[direction][1]] = content
  end

  # checks the content of neighbor cell and records the distance there
  # return nil if the moves ended
  def move(index, direction, distance)
    cell = value_at(index, direction)
    write_to_cell(index, direction, distance) if cell.nil?
    return nil if cell == 'B'
    distance
  end

  def find_target(target)
    array = []
    @maze.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        array << [row_index, cell_index] if target == cell
      end
    end
    array
  end

  def parse_maze(maze_map)
    maze_map.strip.split("\n").map do |row|
      row.split(//).map do |value|
        if value == 'A'
          0
        elsif value == ' '
          nil
        else
          value
        end
      end
    end
  end
end

path = SymbolPath.new(MAZE_MAP)

maze = Maze.new(MAZE_MAP)
solution = path.find_path
maze.verify_path!(solution)
puts "Congratulations! Looks like you've found your way out!"