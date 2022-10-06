  def safe_point
    board_scan do |pos|
      if get(row: pos[:row], column: pos[:column]) != "#" && get(row: pos[:row], column: pos[:column]) >= 1 && get(row: pos[:row], column: pos[:column]) == mine_mark(row: pos[:row], column: pos[:column])
        nine_cells_search(row: pos[:row], column: pos[:column]) do |_pos|
          if get(row: _pos[:row], column: _pos[:column]) == "#"
            puts "safe: #{_pos[:row]}:#{_pos[:column]}"
            return _pos[:row], _pos[:column]
          end
        end
      end
    end
  
    max_rating = 0
    recommend_row_pos   = @row_size
    recommend_column_pos = @column_size
    board_scan do |pos|
      next if get(row: pos[:row], column: pos[:column]) == "#"
    
      rating = mask_count(row: pos[:row], column: pos[:column]) - get(row: pos[:row], column: pos[:column])
      if rating >= max_rating && @suspects[pos[:row]][pos[:column]] == 0
        max_rating = rating
        nine_cells_search(row: pos[:row], column: pos[:column]) do |_pos|
          if get(row: _pos[:row], column: _pos[:column]) == "#" && @suspects[_pos[:row]][_pos[:column]] == 0
            puts "recommend: #{_pos[:row]}:#{_pos[:column]}"
            recommend_row_pos    = _pos[:row]
            recommend_column_pos = _pos[:column]
          end
        end
      end
    end
    
    if recommend_row_pos == @row_size && recommend_column_pos == @column_size
      @virtual_board_on_memory ||= create_virtual_board || @board
      board_scan do |pos|
        if get(row: pos[:row], column: pos[:column]) == "#" && @virtual_board_on_memory[pos[:row]][pos[:column]] != -1
          puts "virtual_board: #{pos[:row]}:#{pos[:column]}"
          return pos[:row], pos[:column]
        end
      end
    end
    
    return recommend_row_pos, recommend_column_pos
  end