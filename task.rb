MAZE_MAP = %Q(
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
▓              ▓   ▓
▓  ▓▓▓▓▓▓▓  ▓  ▓ ▓ ▓
▓  ▓   ▓   ▓▓▓ ▓ ▓ ▓
▓  ▓ A ▓   ▓ ▓ ▓ ▓ ▓
▓  ▓   ▓   ▓   ▓ ▓B▓
▓▓ ▓   ▓▓▓▓▓ ▓▓▓ ▓▓▓
▓                  ▓
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
)

sample_path = %i(down   down   down  right
                 right  right  right right
                 right  right  up
                 up     right  right  up
                 up     up     up    left
                 left   left   left  down
                 down   down   down  left
                 left)

class Maze
  OK = 0
  WALL = 1
  START = 2
  TARGET = 3

  def initialize(maze_map)
    @maze = parse_maze(maze_map)
    @start_row, @start_column = *find_value(@maze, START)
    restart
  end

  # Restart the maze travel by bringing you back to the starting point.
  def restart
    @current_row, @current_column = @start_row, @start_column
    true
  end

  # Move up the maze. Returns OK if you've made a move, WALL if you
  # hit the wall and TARGET if you've reached your destination.
  def up
    move(-1, 0)
  end

  # Move down the maze. Returns OK if you've made a move, WALL if you
  # hit the wall and TARGET if you've reached your destination.
  def down
    move(1, 0)
  end

  # Move left in the maze. Returns OK if you've made a move, WALL if you
  # hit the wall and TARGET if you've reached your destination.
  def left
    move(0, -1)
  end

  # Move right in the maze. Returns OK if you've made a move, WALL if you
  # hit the wall and TARGET if you've reached your destination.
  def right
    move(0, 1)
  end

  # Print the maze to the console.
  def print(clear_screen=false)
    cls if clear_screen
    @maze.each_with_index do |row, index|
      line = row.
          join('').
          gsub(OK.to_s, ' ').
          gsub(START.to_s, 'A').
          gsub(TARGET.to_s, 'B').
          gsub(WALL.to_s, '▓')
      if index == @current_row
        line[@current_column] = '*'
      end
      puts line
    end
    nil
  end

  # Current point of the maze. Either START, or OK, or TARGET.
  def current_point
    @maze[@current_row][@current_column]
  end

  # Inspect the maze object without revealing its actual contents.
  def inspect
    "#<Maze:#{object_id}>"
  end

  # Verifies the path in the form of a directions array. If the
  # directions lead to the target, exits without exceptions. If not
  # the corresponding exception gets raised.
  def verify_path!(path)
    maze = self.dup
    maze.restart
    maze.print(true)
    path.each do |step|
      sleep(0.15)
      if maze.send(step) == WALL
        raise "You've hit a wall. Sorry."
      end
      maze.print(true)
    end
    unless maze.current_point == TARGET
      raise "You have never found your target. Sorry."
    end
  end

  private

  def move(d_row, d_column)
    return TARGET if current_point == TARGET

    target_value = @maze[@current_row + d_row][@current_column + d_column]
    if target_value != WALL
      @current_row += d_row
      @current_column += d_column
      if target_value != TARGET
        target_value = OK
      end
    end

    target_value
  end

  def find_value(array, value)
    y = array.index { |row| row.include?(value) }
    [ y, array[y].index(value) ]
  end

  def parse_maze(maze_map)
    maze_map.
        strip.
        split("\n").
        map { |row|
          row.
              gsub(/▓/, WALL.to_s).
              gsub(' ', OK.to_s).
              gsub('A', START.to_s).
              gsub('B', TARGET.to_s).
              split(//).
              map(&:to_i).
              freeze
        }.freeze
  end

  def cls
    puts "\e[H\e[2J"
  end
end