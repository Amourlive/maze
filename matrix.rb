# Implementation simple Matrix
# represents middleware consists of an array of array for ease of use
class Matrix
  def initialize(array_of_arrays = [[]])
    raise ArgumentError, 'Argument is not array' unless
        array_of_arrays.is_a? Array

    array_of_arrays.each do |array|
      raise ArgumentError, 'Argument array elements is not array' unless
          array.is_a? Array
    end
    @store = array_of_arrays
  end

  def [](row, column)
    return nil if @store[row].nil?

    @store[row][column]
  end

  def []=(row, column, obj)
    @store[row] = [] if @store[row].nil?
    @store[row][column] = obj
  end

  def each(&block)
    @store.each do |row|
      row.each(&block)
    end
    self
  end

  def map(&block)
    Matrix.new(@store.map do |row|
      row.map(&block)
    end)
  end

  def to_a
    @store
  end
end