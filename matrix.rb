# middleware consist array of array for ease of use
class Matrix
  def initialize
    @store = [[]]
  end

  def [](row, column)
    return nil if @store[row].nil? || @store[column].nil?

    @store[row][column]
  end

  def []=(row, column, obj)
    @store[row] = [[]] if @store[row].nil?
    @store[row][column] = [] if @store[row][column].nil?
    @store[row][column] = obj
  end

  def to_a
    @store
  end
end