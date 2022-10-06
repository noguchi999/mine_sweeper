# coding: utf-8
require 'active_support/concern'
module SimpleBoardSimulator
  extend ActiveSupport::Concern
  
  included do
    SimpleBoard.class_eval do
    
      def simulator
        unless @board
          @board = Array.new(@max_length, 0)
          @board = to_2d(set_mines(@board, @mine_count))
          @board = set_finder(@board)
          @suspects = create_suspect_mark_board
        end
        
        board_secret
        @board = to_2d(Array.new(@max_length, "#"))
        
        self
      end
    
      def board_secret
        @board_secret ||= Marshal.load(Marshal.dump(@board))
      end
      
      def show_secret
        board_secret.each do |line|
          puts line.join("").gsub(/-1/, "*")
        end
      end
      
      def show_sample
        puts board_secret.join(",")
      end
      
      def turn_up(options={})
        raise ArgumentError, "usage turn_up(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
        opts = options
        x = opts[:row].to_i
        y = opts[:column].to_i
        
        return nil unless @board[x]
        return unless @board[x][y] == "#" || @board[x][y] == 0
        @board[x][y] = board_secret[x][y].to_s.gsub(/9/, "0").to_i
        
        nine_cells_search(row: opts[:row], column: opts[:column]) do |pos|
          if board_secret[pos[:row]][pos[:column]] == 0
            board_secret[pos[:row]][pos[:column]] = 9
            nine_cells_search(row: pos[:row], column: pos[:column]) do |_pos|
              if board_secret[_pos[:row]][_pos[:column]] != -1
                @board[_pos[:row]][_pos[:column]] = board_secret[_pos[:row]][_pos[:column]].to_s.gsub(/9/, "0").to_i
              end
            end
            
            turn_up(row: pos[:row], column: pos[:column])
          end
        end
      end
      
      def complete?
        _bord = @board.flatten
        _bord.select{|v| v=="#" || v==-1}.length == @mine_count
      end
    end
  end
  
  private
    def set_mines(board, mine_count)
      mine_count.times do
        pos = rand(board.length)
        redo if board[pos] == -1
        
        board[pos] = -1
      end
      board
    end
end