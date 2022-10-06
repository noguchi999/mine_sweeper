# coding: utf-8
require 'forwardable'
class SimpleBoard
  extend Forwardable
  
  attr_reader :board, :max_length, :row_size, :column_size, :mine_count

  LEVEL    = {low: 9,  middle: 16, high: 30}
  MINE     = {low: 10, middle: 40, high: 99}
  ACCURACY = {safety: 0, almost_safe: 1, recommend: 2, virtual: 3, normal: 4, risky: 5, gamble: 6}
  
  def initialize(options={})
    raise ArgumentError, "invalid options. ex.) :level => :low" unless options[:level] # 読込みに時間が掛かるので、 active_supportは使わない(require 'active_support/core_ext/hash/keys'だけでも一瞬、溜めが入る)。
    opts = {level: :low}.merge(options)
    
    case opts[:level]
    when :low, :middle
      @max_length  = LEVEL[opts[:level]] ** 2
      @row_size    = LEVEL[opts[:level]]
      @column_size = LEVEL[opts[:level]]
    
    when :high
      @max_length  = LEVEL[opts[:level]] * 16
      @row_size    = LEVEL[opts[:level]]
      @column_size = 16
    
    else
      raise ArgumentError, "invalid option value #{options.values}. usage :low, :middle, :high"
    end
    
    if opts[:board]
      raise ArgumentError, "invalid board length #{opts[:board].length}. usage #{@max_length}" unless opts[:board].length == @max_length
      
      @board = to_2d(opts[:board])
      @suspects   = create_suspect_mark_board
    end
    
    @mine_count = MINE[opts[:level]]
  end
  def_delegators :@board, :each, :first, :last, :select, :inject, :join
  
  def refresh(options={})
    raise ArgumentError, "invalid options. ex.) :board => [0, 1, 3]" unless ([:board] - options.keys).empty?
    raise ArgumentError, ":board must be #{@row_size * @column_size} size Array." if options[:board].empty?
    opts = options
    
    if opts[:board][@row_size-1].is_a? Array
      @board = opts[:board]
    else
      @board = to_2d(opts[:board])
    end
    @board    = write_mine_mark(@board)
    @suspects = create_suspect_mark_board
  end
  
  def show
    @board.each do |line|
      puts line.join("").gsub(/-1/, "*")
    end
  end
  
  def get(options={})
    raise ArgumentError, "usage get(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
    opts = options
    x = opts[:row]
    y = opts[:column]
    
    return nil unless @board[x]
    @board[x][y]
  end
  
  def octa_around(options={})
    raise ArgumentError, "usage octa_around(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
    opts = options
    
    _octa_arounds = {cell: {}}
    nine_cells_search(row: opts[:row], column: opts[:column]) do |pos|
      _octa_arounds[:cell].store("#{pos[:distance_top]}:#{pos[:distance_left]}", @board[pos[:row]][pos[:column]])
    end
    _octa_arounds
  end
  
  def nine_cells_search(options={})
    raise ArgumentError, "usage nine_cells_search(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
    opts = options
    
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        row_pos    = opts[:row]    + dx
        column_pos = opts[:column] + dy
        
        if row_pos >= 0 && row_pos < @row_size && column_pos >= 0 && column_pos < @column_size
          yield row: row_pos, column: column_pos, distance_top: dx, distance_left: dy
        end
      end
    end
  end
  
  def nine_cells_search_zoning(center={}, search_point={})
    raise ArgumentError, "usage nine_cells_search_zoning({:column => 2, :row => 8}, {:column => 3, :row => 8})" unless ([:column, :row] - center.keys).empty?
    raise ArgumentError, "usage nine_cells_search_zoning({:column => 2, :row => 8}, {:column => 3, :row => 8})" unless ([:column, :row] - search_point.keys).empty?
    
    rows    = []
    columns = []
    nine_cells_search(center) do |pos|
      rows    << pos[:row]
      columns << pos[:column]
    end
    effective_area = {min_row: rows.min, max_row: rows.max, min_column: columns.min, max_column: columns.max}
    
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        row_pos    = search_point[:row]    + dx
        column_pos = search_point[:column] + dy
        
        if row_pos >= effective_area[:min_row] && row_pos <= effective_area[:max_row] && column_pos >= effective_area[:min_column] && column_pos <= effective_area[:max_column]
          yield row: row_pos, column: column_pos
        end
      end
    end
  end
  
  def twenty_five_cells_search(options={})
    raise ArgumentError, "usage twenty_five_cells_search(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
    opts = options
    
    (-2..2).each do |dx|
      (-2..2).each do |dy|
        row_pos    = opts[:row]    + dx
        column_pos = opts[:column] + dy
        
        if row_pos >= 0 && row_pos < @row_size && column_pos >= 0 && column_pos < @column_size
          yield row: row_pos, column: column_pos, distance_top: dx, distance_left: dy
        end
      end
    end
  end
  
  def board_scan
    @row_size.times do |x|
      @column_size.times do |y|
        if y >= 0 && y < @column_size && x >= 0 && x < @row_size
          yield row: x, column: y
        end
      end
    end
  end
  
  def safety
    board_scan do |pos|
      if get(pos) != "#" && get(pos) >= 1 && get(pos) == mine_mark(pos)
        nine_cells_search(pos) do |_pos|
          if get(_pos) == "#"
            return {row: _pos[:row], column: _pos[:column], accuracy: ACCURACY[:safety]}
          end
        end
      end
    end
    
    nil
  end
  
  def almost_safe
    board_scan do |pos|
      if get(pos) != "#" && get(pos) == 1 && mask_count(pos) == 3 && suspect_mark(pos) > 1
        neighboring_mask = {}
        nine_cells_search(pos) do |_pos|
          if get(_pos) == "#"
            neighboring_mask_count = 0
            nine_cells_search_zoning(pos, _pos) do |search_point|
              neighboring_mask_count += 1 if get(search_point) == "#"
            end
            neighboring_mask.store(neighboring_mask_count, {row: _pos[:row], column: _pos[:column]})
          end
        end
        
        if neighboring_mask[2] && neighboring_mask[1]
          return {row: neighboring_mask[1][:row], column: neighboring_mask[1][:column], accuracy: ACCURACY[:almost_safe]}
          
        elsif neighboring_mask[3]
          if @board[pos[:row]][pos[:column]-1] == "#"
            if @board[pos[:row]-1][pos[:column]] == 1 && @board[pos[:row]+1][pos[:column]] == 2
              return {row: pos[:row]+1, column: pos[:column]-1, accuracy: ACCURACY[:almost_safe]}
            elsif @board[pos[:row]-1][pos[:column]] == 2 && @board[pos[:row]+1][pos[:column]] == 1
              return {row: pos[:row]-1, column: pos[:column]-1, accuracy: ACCURACY[:almost_safe]}
            end
          elsif @board[pos[:row]][pos[:column]+1] == "#"
            if @board[pos[:row]-1][pos[:column]] == 1 && @board[pos[:row]+1][pos[:column]] == 2
              return {row: pos[:row]+1, column: pos[:column]+1, accuracy: ACCURACY[:almost_safe]}
            elsif @board[pos[:row]-1][pos[:column]] == 2 && @board[pos[:row]+1][pos[:column]] == 1
              return {row: pos[:row]-1, column: pos[:column]+1, accuracy: ACCURACY[:almost_safe]}
            end
          elsif @board[pos[:row]-1][pos[:column]] == "#"
            if @board[pos[:row]][pos[:column]-1] == 2 && @board[pos[:row]][pos[:column]+1] == 1
              return {row: pos[:row]-1, column: pos[:column]-1, accuracy: ACCURACY[:almost_safe]}
            elsif @board[pos[:row]][pos[:column]-1] == 1 && @board[pos[:row]][pos[:column]+1] == 2
              return {row: pos[:row]-1, column: pos[:column]+1, accuracy: ACCURACY[:almost_safe]}
            end
          elsif @board[pos[:row]+1][pos[:column]] == "#"
            if @board[pos[:row]][pos[:column]-1] == 2 && @board[pos[:row]][pos[:column]+1] == 1
              return {row: pos[:row]+1, column: pos[:column]-1, accuracy: ACCURACY[:almost_safe]}
            elsif @board[pos[:row]][pos[:column]-1] == 1 && @board[pos[:row]][pos[:column]+1] == 2
              return {row: pos[:row]+1, column: pos[:column]+1, accuracy: ACCURACY[:almost_safe]}
            end
          end
        end
      end
    end
    
    nil
  end
  
  def recommend
    board_scan do |pos|
      if get(pos) != "#" && get(pos) >= 0
        _recommend = recommend_point(pos)
        if _recommend
          return {row: _recommend[:row], column: _recommend[:column], accuracy: ACCURACY[:recommend]}
        end
      end
    end
    
    nil
  end
  
  def virtual
    #virtual_board = nil
    #result = RubyProf.profiler {
    virtual_board = create_virtual_board
    #}
    #puts result
    if virtual_board
      board_scan do |pos|
        if get(row: pos[:row], column: pos[:column]) == "#" && virtual_board[pos[:row]][pos[:column]] != -1
          return {row: pos[:row], column: pos[:column], accuracy: ACCURACY[:recommend]}
        end
      end
    end
    
    nil
  end
  
  def normal
    max_rating = 0
    board_scan do |pos|
      next if get(row: pos[:row], column: pos[:column]) == "#"
    
      rating = mask_count(row: pos[:row], column: pos[:column]) - get(row: pos[:row], column: pos[:column])
      if rating >= max_rating && @suspects[pos[:row]][pos[:column]] == 0
        max_rating = rating
        nine_cells_search(row: pos[:row], column: pos[:column]) do |_pos|
          if get(row: _pos[:row], column: _pos[:column]) == "#" && @suspects[_pos[:row]][_pos[:column]] == 0
            return {row: _pos[:row], column: _pos[:column], accuracy: ACCURACY[:normal]}
          end
        end
      end
    end
    
    nil
  end
  
  def risky
    board_scan do |pos|
      if get(pos) == "#" && @suspects[pos[:row]][pos[:column]] == 0
        return {row: pos[:row], column: pos[:column], accuracy: ACCURACY[:risky]}
      end
    end
    
    nil
  end
  
  def gamble
    board_scan do |pos|
      if get(pos) == "#"
        return {row: pos[:row], column: pos[:column], accuracy: ACCURACY[:gamble]}
      end
    end
    
    nil
  end
  
  def safe_point(acceptable_levels=ACCURACY.keys)
    
    acceptable_levels.each do |level|
      result = self.__send__ level
      
      return result if result
    end
    
    nil
  end
  
  def mask_remains
    mask = 0
    board_scan do |pos|
      mask += 1 if @board[pos[:row]][pos[:column]] == "#"
    end
    
    mask
  end
  
  def mine_remains
    mine = 0
    board_scan do |pos|
      mine += 1 if @board[pos[:row]][pos[:column]] == -1
    end
    
    @mine_count - mine
  end
  
  private
    def recommend_point(options={})
      raise ArgumentError, "usage recommend_point(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
      opts = options
      
      recommend_board = @row_size.times.inject([]) {|dd| dd << Array.new(@column_size, nil)}
      twenty_five_cells_search(opts) do |pos|
        recommend_board[pos[:row]][pos[:column]] = @board[pos[:row]][pos[:column]]
      end
      
      nine_cells_search(opts) do |pos|
        if recommend_board[pos[:row]][pos[:column]] == "#"
          recommend_board[pos[:row]][pos[:column]] = -1
          recommend_board = set_finder(recommend_board)
          
          return pos if equivalence?(recommend_board)
        end
      end
      
      nil
    end
    
    def create_virtual_board
      #virtual_board = @row_size.times.inject([]) {|dd| dd << Array.new(@column_size, nil)}
      virtual_board = Marshal.load(Marshal.dump(@board))
      masked_locations = []
      board_scan do |pos|
        if @board[pos[:row]][pos[:column]] == "#"
          masked_locations << {row: pos[:row], column: pos[:column]}
        end
      end
      
      verification_of_hypotheses(virtual_board, masked_locations)
    end
    
    def verification_of_hypotheses(virtual_board, masked_locations)
      _mine_remains  = mine_remains 
      mine_locations = mine_locator(masked_locations, _mine_remains)
      mine_locations.each do |line|
        #next if _mine_remains.times.find{|index| (line - [line[index]]).length < (line.length - 1)} # パフォーマンス上の理由により、ここでmine_locatorから返却された配列内の重複を排除する.
        
        virtual_board = rebuild_board(virtual_board, masked_locations, line)
        return virtual_board if equivalence? virtual_board
      end
      
      nil
    end
    
    def mine_locator(masked_locations, _mine_remains)
      args = (_mine_remains - 1).times.inject([]){|v| v << "masked_locations"}.join(",")
      #eval(%Q|masked_locations.product(#{args})|) # パフォーマンス上の理由により、重複したままの配列を返却する.
      eval(%Q|masked_locations.product(#{args})|).inject({}){|h, element| h.store(element, 0); h}.keys.select{|v| v.length == _mine_remains} # 重複を排除するために、Hashのkeyとして登録する. uniqより遥かに高速.
    end
    
    def equivalence?(board)
      board.each_with_index do |line, row|
        line.each_with_index do |cell, column|
          next if cell.nil?
          next if @board[row][column] == "#"
          
          return false unless @board[row][column] == cell
        end
      end

      true
    end

    def rebuild_board(virtual_board, masked_locations, mine_locations)
      masked_locations.each do |pos|
        virtual_board[pos[:row]][pos[:column]] = "#"
      end
      
      mine_locations.each do |pos|
        virtual_board[pos[:row]][pos[:column]] = -1
      end
      
      set_finder(virtual_board)
    end
    
    def init_2d_array
      @row_size.times.inject([]) {|dd| dd << Array.new(@column_size, 0)}
    end
    
    def to_2d(_board)
      _2d = []
      @row_size.times do |pos|
        _2d << _board[(pos * @column_size), @column_size]
      end
      _2d
    end
    
    def mask_count(options={})
      raise ArgumentError, "usage mask_count(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
      opts = options
    
      octa_around(row: opts[:row], column: opts[:column])[:cell].values.select{|v| v=="#"}.length
    end
    
    def write_mine_mark(_board)
      board_scan do |pos|
        if get(row: pos[:row], column: pos[:column]) != "#" && get(row: pos[:row], column: pos[:column]) == (mask_count(row: pos[:row], column: pos[:column]) + mine_mark(row: pos[:row], column: pos[:column]))
          nine_cells_search(row: pos[:row], column: pos[:column]) do |_pos|
            if get(row: _pos[:row], column: _pos[:column]) == "#"
              _board[_pos[:row]][_pos[:column]] = -1
            end
          end
        end
      end
      _board
    end
    
    def create_suspect_mark_board
      _suspects = init_2d_array
      board_scan do |pos|
        if get(pos) != "#" && get(pos) == (mask_count(pos) + mine_mark(pos) - 1)
          nine_cells_search(pos) do |_pos|
            if get(_pos) == "#"
              _suspects[_pos[:row]][_pos[:column]] = 1
            end
          end
        end
      end
      _suspects
    end
    
    def mine_mark(options={})
      raise ArgumentError, "usage mine_mark(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
      opts = options
      
      _mine_mark = 0
      nine_cells_search(opts) do |pos|
        _mine_mark += 1 if @board[pos[:row]][pos[:column]] == -1
      end
      _mine_mark
    end
    
    def suspect_mark(options={})
      raise ArgumentError, "usage suspect_mark(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
      opts = options
      
      _suspect_mark = 0
      nine_cells_search(opts) do |pos|
        _suspect_mark += @suspects[pos[:row]][pos[:column]]
      end
      _suspect_mark
    end
    
    def set_finder(board)
      board.each_with_index do |line, row|
        line.each_with_index do |cell, column|
          next if cell.nil? || cell == -1
        
          finder = 0
          nine_cells_search(row: row, column: column) do |pos|
            finder += 1 if board[pos[:row]][pos[:column]] == -1
          end
          board[row][column] = finder
        end
      end
      
      board
    end
end