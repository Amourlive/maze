require_relative 'task'

class SamplePath
  ROUTE = %i[down left up right].freeze
  OPTION = { down: [1, 0], left: [0, -1], up: [-1, 0], right: [0, 1] }.freeze
  OK = 0
  WALL = 1
  START = 2
  TARGET = 3

  def initialize(maze, start_row, start_column)
    @maze = maze
    @current_row = start_row
    @current_column = start_column
    @sample_path = []
  end

  def find_path
    find_targets
    loop do
      if @current_row < @target_row
        cell = move(:down)
        break if cell == TARGET
        get_round_wall(3) if cell == WALL
      elsif @current_row > @target_row
        cell = move(:up)
        break if cell == TARGET
        get_round_wall(1) if cell == WALL
      end
      if @current_column < @target_column
        cell = move(:right)
        break if cell == TARGET
        get_round_wall(2) if cell == WALL
      elsif @current_column > @target_column
        cell = move(:left)
        break if cell == TARGET
        get_round_wall(0) if cell == WALL
      end
    end
    sort_direction
  end

  private

  def move(direction)
    next_row = @current_row + OPTION[direction][0]
    next_column = @current_column + OPTION[direction][1]
    cell = @maze[next_row][next_column]
    return cell if cell == WALL
    @sample_path << direction
    @current_row = next_row
    @current_column = next_column
    cell
  end

  def find_targets
    @maze.each_with_index do |row, row_index|
      cell_index = row.find_index { |value| value == TARGET }
      unless cell_index.nil?
        @target_row = row_index.freeze
        @target_column = cell_index.freeze
      end
    end
  end

  def get_round_wall(index)
    wall_row = @current_row + OPTION[ROUTE[(index + 1) % 4]][0]
    wall_column = @current_column + OPTION[ROUTE[(index + 1) % 4]][1]
    loop do
      cell = move(ROUTE[(index + 2) % 4])
      # move(ROUTE[index])
      if cell == WALL
        inside_wall_row = @current_row + OPTION[ROUTE[(index + 2) % 4]][0]
        inside_wall_column = @current_column + OPTION[ROUTE[(index + 2) % 4]][1]
        loop do
          inside_cell = move(ROUTE[(index + 3) % 4])
          # move(ROUTE[(index + 1) % 4])
          if inside_cell == WALL
            double_inside_wall_row = @current_row + OPTION[ROUTE[(index + 3) % 4]][0]
            double_inside_wall_column = @current_column + OPTION[ROUTE[(index + 3) % 4]][1]
            loop do
              double_inside_cell = move(ROUTE[(index + 4) % 4])
              # move(ROUTE[(index + 2) % 4])
              if double_inside_cell == WALL
                thrice_inside_wall_row = @current_row + OPTION[ROUTE[(index + 4) % 4]][0]
                thrice_inside_wall_column = @current_column + OPTION[ROUTE[(index + 4) % 4]][1]
                loop do
                  thrice_inside_cell = move(ROUTE[(index + 5) % 4])
                  if thrice_inside_cell == OK
                    double_inside_wall_row += OPTION[ROUTE[(index + 5) % 4]][0]
                    double_inside_wall_column += OPTION[ROUTE[(index + 5) % 4]][1]
                  end
                  move(ROUTE[(index + 4) % 4])
                  break if @current_row == thrice_inside_wall_row || @current_column == thrice_inside_wall_column
                end
              elsif double_inside_cell == OK
                inside_wall_row += OPTION[ROUTE[(index + 4) % 4]][0]
                inside_wall_column += OPTION[ROUTE[(index + 4) % 4]][1]
              end
              move(ROUTE[(index + 3) % 4])
              break if @current_row == double_inside_wall_row || @current_column == double_inside_wall_column
            end
          elsif inside_cell == OK
            wall_row += OPTION[ROUTE[(index + 3) % 4]][0]
            wall_column += OPTION[ROUTE[(index + 3) % 4]][1]
          end
          move(ROUTE[(index + 2) % 4])
          break if @current_row == inside_wall_row || @current_column == inside_wall_column
        end
      end
      move(ROUTE[(index + 1) % 4])
      break if @current_row == wall_row || @current_column == wall_column
    end
  end

  def sort_direction(arr = @sample_path)
    i = 0
    loop do
      if ROUTE.find_index { |d| d == arr[i] } == ((ROUTE.find_index { |d| d == arr[i + 1] } + 2) % 4 )
        arr.delete_at(i)
        arr.delete_at(i)
        i = 0
      else
        i += 1
      end
      break if i == (arr.length - 1)
    end
    arr
  end
end


maze = Maze.new(MAZE_MAP)

path = SamplePath.new(
    maze.instance_variable_get(:@maze),
    maze.instance_variable_get(:@start_row),
    maze.instance_variable_get(:@start_column)
)


solution = path.find_path

maze.verify_path!(solution)
puts "Congratulations! Looks like you've found your way out!"