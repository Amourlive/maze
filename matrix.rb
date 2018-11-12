# Implementation simple Matrix
# Real key with virtual
# 0 [0,0]  1 [0,1]    2 [0,2]  3 [0,3]  4 [0,4]
# 5 [1,0]  6 [1,1]    7 [1,2]  8 [1,2]  9 [1,3]
# 10[2,0]  11[2,1]    12[2,2]  13[2,2]  14[2,3]
#
class Matrix
  def initialize(row, column, obj = nil, &block)
    handle_exception_type(row, column)

    @row_count = row
    @column_count = column
    @store = create_store(row, column, obj, &block)
  end

  def [](row, column)
    handle_exception_type(row, column)
    handle_exception_argument(row, column)
    @store[convert_to_array_key(row, column)]
  end

  def []=(row, column, obj)
    handle_exception_type(row, column)
    handle_exception_argument(row, column)
    @store[convert_to_array_key(row, column)] = obj
  end

  def each(&block)
    @store.each(&block)
    self
  end

  def map(&block)
    Matrix.new(@row_count, @column_count, @store.map(&block))
  end

  def size
    { row: @row_count, column: @column_count }
  end

  def to_a
    @store
  end

  def empty?
    @store.empty?
  end

  def inspect
    return "#{self.class}.empty(0, 0)" if empty?

    store = @store.dup
    size = format_cell
    line = ''
    line << column_key_line(size)
    @row_count.times do |row|
      line << row_line(row, store, size)
    end
    print line
  end

  def first
    @store.first
  end

  def last
    @store.last
  end

  private

  def create_store(row, column, obj, &block)
    if obj.nil?
      Array.new(row * column, &block)
    elsif obj.is_a?(Array) && obj.size == (row * column)
      obj
    else
      Array.new(row * column, obj)
    end
  end

  def convert_to_array_key(row, column)
    @column_count * row + column
  end

  def handle_exception_type(row, column)
    return if row.is_a?(Integer) && column.is_a?(Integer)

    type = row.is_a?(Integer) ? column.class : row.class
    raise TypeError, "no implicit conversion of #{type} into Integer"
  end

  def handle_exception_argument(row, column)
    raise ArgumentError, 'Matrix index is out of range' if
      row >= @row_count && column >= @column_count
  end

  def format_cell(gap = 1)
    @store.max { |a, b| a.to_s.length <=> b.to_s.length }.to_s.length + gap
  end

  def column_key_line(size)
    "#{format("%#{size}s", '') +
    (0...@column_count).map { |key| format("%#{size}s", key) }.join}\n"
  end

  def row_line(row_key, row, size)
    "#{format("%#{size}s", row_key) +
    row.shift(@column_count).map { |cell| format("%#{size}s", cell) }.join}\n"
  end
end