# coding: utf-8
#require 'win32ole'
require File.expand_path('app/simple_board')
require File.expand_path('app/simple_board_simulator')
require File.expand_path('lib/ruby_prof')
require 'benchmark'
if __FILE__ == $0
  include SimpleBoardSimulator

  def turn_up(row, column)
    puts "turn_up #{row} : #{column}"
    @board.turn_up(row: row, column: column)
    @board.get(row: row, column: column)
  end
  
  puts Benchmark::CAPTION
  puts Benchmark.measure {
    #@board = SimpleBoard.new(level: :low, board: [0,0,0,1,1,2,2,-1,-1,1,1,0,1,-1,2,-1,3,2,-1,2,1,1,1,2,2,2,1,2,-1,1,0,0,1,2,-1,1,1,1,1,1,1,2,-1,2,1,0,0,0,1,-1,2,1,1,0,0,0,0,1,1,1,0,1,1,0,0,0,0,0,0,0,1,-1,0,0,0,0,0,0,0,1,1]).simulator
    #@board = SimpleBoard.new(level: :low, board: [0,1,-1,2,-1,-1,1,0,0,0,1,2,4,4,3,1,0,0,1,1,1,-1,-1,1,0,0,0,-1,1,1,2,2,1,0,0,0,1,1,1,2,2,1,0,0,0,0,1,2,-1,-1,1,0,0,0,0,1,-1,3,2,1,0,0,0,0,1,2,2,1,0,0,0,0,0,0,1,-1,1,0,0,0,0]).simulator
    #@board = SimpleBoard.new(level: :low, board: [0,1,-1,1,1,1,2,2,-1,0,1,1,1,1,-1,2,-1,2,0,1,1,1,1,1,2,1,1,0,1,-1,1,0,0,0,0,0,1,2,1,1,0,0,0,0,0,-1,1,0,0,0,1,1,1,0,1,1,0,0,0,1,-1,2,1,1,1,0,1,1,2,1,2,-1,-1,1,0,1,-1,1,0,1,1]).simulator
    #@board = SimpleBoard.new(level: :low, board: [0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,0,0,1,-1,2,1,2,-1,2,0,0,2,3,-1,1,2,-1,2,0,1,3,-1,3,1,1,1,1,0,-1,3,-1,2,1,1,1,0,0,2,3,2,2,2,-1,1,0,0,1,-1,1,1,-1,2,1,0,0,1,1,1,1,1,1,0,0,0]).simulator
    #@board = SimpleBoard.new(level: :high, board: [1,1,1,-1,1,0,1,-1,1,1,1,1,0,0,1,-1,-1,2,3,2,2,0,1,1,2,2,-1,1,0,0,1,1,3,-1,2,-1,1,0,0,0,1,-1,3,2,1,0,0,0,-1,2,3,2,2,0,0,0,1,1,3,-1,2,0,0,0,1,2,2,-1,1,0,0,0,0,0,3,-1,4,1,0,0,0,1,-1,2,1,0,0,0,1,1,3,-1,-1,1,1,1,0,1,1,1,0,1,1,2,2,-1,2,2,2,2,2,-1,1,2,1,1,0,1,-1,2,-1,2,1,0,0,2,-1,4,-1,2,-1,1,0,1,2,4,3,3,1,1,1,3,-1,-1,2,3,3,2,1,1,2,-1,-1,2,-1,1,1,-1,3,2,2,-1,3,-1,1,2,-1,5,3,3,1,1,1,2,2,1,2,-1,3,1,1,2,-1,3,-1,1,1,1,1,1,-1,1,2,2,1,1,1,3,2,3,2,3,3,-1,1,2,2,2,-1,2,1,2,-1,2,-1,1,1,-1,-1,2,1,1,-1,1,1,3,-1,3,2,3,2,2,2,3,3,2,1,1,1,1,1,3,-1,2,1,-1,3,3,-1,3,4,-1,2,0,0,0,2,-1,2,2,3,5,-1,-1,4,-1,-1,-1,3,1,0,0,-1,2,2,3,-1,-1,-1,-1,3,2,3,3,-1,1,0,0,2,2,2,-1,-1,4,3,2,1,1,1,2,1,1,0,0,1,-1,3,3,3,1,0,1,2,3,-1,2,2,1,1,0,1,1,2,-1,1,0,0,1,-1,-1,4,-1,3,-1,1,0,0,0,1,1,1,1,1,3,3,3,3,-1,3,2,3,2,0,0,0,0,0,1,-1,3,-1,1,2,2,2,1,-1,-1,0,0,0,1,1,2,2,-1,2,1,1,-1,1,1,3,-1,0,0,0,1,-1,3,3,2,2,1,2,1,2,1,2,1,1,1,0,1,3,-1,-1,1,1,-1,1,0,2,-1,3,1,-1,2,1,1,4,-1,4,1,1,1,1,0,3,-1,4,-1,2,-1,2,2,-1,-1,3,2,3,2,1,0,2,-1,4,2,1,2,3,-1,3,3,4,-1,-1,-1,2,1,2,1,2,-1,0,1,-1,2,1,1,-1,-1,-1,3,2,-1,1,0,1,1]).simulator
    #@board = SimpleBoard.new(level: :high, board: [2,2,1,0,1,-1,2,1,1,1,2,3,-1,2,1,1,-1,-1,2,1,2,1,2,-1,2,2,-1,-1,2,2,-1,2,3,3,2,-1,1,1,2,3,-1,2,3,3,2,1,2,-1,-1,1,2,2,2,1,-1,2,1,1,1,-1,1,1,2,2,2,2,2,-1,1,1,1,1,0,0,2,3,3,2,-1,1,1,-1,2,1,1,0,1,1,1,0,2,-1,-1,2,1,1,2,2,3,1,1,0,2,-1,2,0,3,-1,4,1,0,0,1,-1,3,-1,2,1,3,-1,2,1,3,-1,3,1,1,1,2,3,-1,3,3,-1,3,2,2,1,-1,3,-1,1,1,-1,2,-1,2,2,-1,4,4,-1,2,2,1,2,1,1,2,2,-1,2,1,1,2,-1,-1,3,-1,1,0,0,1,2,4,-1,1,1,0,1,3,4,4,3,3,3,2,2,2,-1,-1,-1,0,1,1,2,-1,-1,3,-1,3,-1,-1,3,-1,7,-1,4,0,1,-1,2,2,2,3,-1,3,3,3,5,-1,-1,-1,2,0,1,2,2,1,0,1,1,1,1,-1,4,-1,6,3,2,2,2,2,-1,1,0,0,0,0,1,1,3,-1,3,-1,1,-1,-1,2,1,1,1,1,1,0,0,0,1,1,3,2,2,2,2,1,0,0,2,-1,3,1,1,0,0,0,1,-1,1,1,2,3,2,1,3,-1,5,-1,2,0,0,0,1,1,1,2,-1,-1,-1,2,2,-1,5,-1,2,0,1,1,1,0,0,3,-1,7,-1,2,1,2,-1,2,1,0,1,-1,1,0,0,2,-1,-1,2,1,0,2,3,3,1,0,2,2,2,0,0,2,3,3,1,1,2,3,-1,-1,1,0,1,-1,2,1,1,3,-1,3,1,1,-1,-1,3,2,1,1,2,2,3,-1,2,-1,-1,-1,1,1,2,2,1,0,0,2,-1,3,3,-1,2,-1,-1,3,1,0,0,0,0,1,1,3,-1,-1,2,1,1,2,3,3,3,2,1,0,1,2,-1,2,2,2,1,0,0,1,2,-1,-1,-1,1,0,1,-1,2,1,0,0,0,0,0,-1,2,2,3,2,1,0,1,1,1,0,1,2,2,1,0,1,1,0,0,0,0,0,0,0,0,0,1,-1,-1,1,0]).simulator
    #@board = SimpleBoard.new(level: :high, board: [-1,3,2,1,1,-1,1,0,0,1,-1,1,1,-1,1,0,4,-1,-1,1,1,2,2,1,0,1,2,2,2,1,1,0,-1,-1,3,2,1,2,-1,1,1,2,3,-1,2,1,1,1,2,2,1,1,-1,3,2,2,2,-1,-1,4,-1,2,2,-1,0,0,0,1,1,2,-1,2,3,-1,-1,4,3,-1,2,1,0,0,0,1,2,3,2,2,-1,4,3,3,-1,2,2,1,1,1,0,1,-1,-1,2,1,1,2,-1,2,1,1,1,-1,-1,1,0,1,3,-1,2,0,1,3,4,3,1,0,1,1,1,1,0,0,1,1,1,0,1,-1,-1,-1,1,1,2,2,0,0,0,0,0,0,0,0,1,2,3,2,2,3,-1,-1,0,0,0,0,0,0,1,1,2,1,1,0,1,-1,-1,3,0,0,0,0,0,0,1,-1,2,-1,1,0,2,3,3,1,2,3,3,2,1,0,1,1,2,2,3,2,2,-1,1,0,-1,-1,-1,-1,3,1,1,1,1,2,-1,-1,4,2,1,0,4,-1,7,-1,-1,1,1,-1,1,3,-1,-1,-1,1,1,1,3,-1,-1,3,2,1,1,1,1,3,-1,5,2,2,3,-1,2,-1,3,1,0,0,0,0,0,3,-1,4,1,1,-1,-1,1,1,1,0,0,0,0,0,0,2,-1,-1,2,2,3,-1,0,0,0,1,2,2,1,1,2,3,3,3,-1,1,2,2,0,0,0,1,-1,-1,1,1,-1,-1,3,2,1,1,2,-1,1,1,0,1,2,2,2,3,5,-1,-1,1,0,0,2,-1,-1,1,1,1,1,0,2,-1,-1,3,2,1,0,0,1,1,2,2,1,-1,1,0,2,-1,3,1,0,0,0,0,0,0,-1,3,2,2,2,1,2,1,1,0,1,1,2,1,1,0,-1,4,-1,2,2,-1,1,0,1,1,2,-1,2,-1,1,0,2,-1,2,2,-1,2,1,0,1,-1,3,2,3,2,2,0,1,1,1,1,1,1,0,1,2,3,-1,2,2,-1,2,1,1,1,1,1,1,0,0,1,-1,2,1,2,-1,3,-1,1,-1,2,2,-1,2,1,1,2,3,4,3,4,3,4,2,2,1,2,-1,2,2,-1,1,1,-1,-1,-1,-1,-1,2,-1,1]).simulator
    #@board = SimpleBoard.new(level: :high, board: [1,1,0,1,-1,2,3,-1,2,0,1,-1,1,0,0,0,-1,1,0,1,2,-1,3,-1,4,2,2,1,1,0,0,0,1,1,0,0,1,1,2,2,-1,-1,4,2,1,0,1,1,0,0,1,1,1,0,0,1,3,-1,-1,-1,1,1,2,-1,1,2,3,-1,1,0,0,0,1,3,5,4,2,1,-1,2,1,-1,-1,3,3,2,2,1,1,1,-1,-1,1,1,1,1,1,2,3,3,-1,-1,3,-1,2,2,2,2,1,1,1,1,0,1,2,-1,4,-1,3,3,-1,2,0,0,0,2,-1,2,2,3,-1,2,2,1,2,3,-1,2,0,1,1,3,-1,2,-1,-1,3,3,1,2,2,-1,3,3,2,3,-1,2,1,1,2,3,-1,2,-1,2,-1,4,-1,2,-1,-1,4,3,1,0,0,1,1,2,1,2,2,-1,2,2,2,3,-1,-1,2,1,1,1,0,0,1,1,2,1,1,0,0,2,3,3,3,-1,-1,2,0,0,2,-1,2,0,1,1,1,1,-1,1,3,-1,-1,3,0,0,2,-1,2,1,2,-1,1,1,1,1,2,-1,-1,2,0,0,2,3,4,3,-1,2,1,1,1,1,1,1,2,2,0,0,1,-1,-1,-1,2,1,1,2,-1,1,0,0,-1,1,0,0,1,2,3,3,2,1,1,-1,4,3,2,1,1,2,1,2,2,2,1,1,-1,1,1,2,-1,-1,2,-1,0,2,-1,5,-1,-1,1,1,2,3,2,2,2,2,2,1,0,3,-1,-1,-1,3,1,0,1,-1,-1,1,0,0,0,0,0,2,-1,5,3,2,1,1,3,3,3,1,1,1,2,1,0,1,1,2,-1,1,1,-1,3,-1,2,1,1,-1,3,-1,1,1,1,1,1,1,1,2,-1,4,-1,3,3,3,-1,2,1,-1,2,1,1,0,0,1,3,-1,4,-1,-1,4,2,1,1,1,2,-1,2,1,0,0,2,-1,3,3,-1,-1,1,0,1,2,3,3,-1,2,1,0,1,1,1,2,3,3,1,0,2,-1,-1,2,2,-1,1,0,1,1,1,1,-1,2,1,1,-1,4,3,2,1,1,2,2,4,-1,2,1,1,2,-1,1,1,2,-1,1,0,0,1,-1,-1,-1,2,0,0,1,1,1]).simulator
    #@board = SimpleBoard.new(level: :middle, board: [-1,-1,1,1,2,3,4,-1,2,1,1,1,0,0,0,0,-1,3,1,2,-1,-1,-1,-1,2,1,-1,1,0,0,0,0,1,1,0,3,-1,5,3,2,1,1,1,1,0,1,1,1,0,0,0,2,-1,2,1,1,1,0,0,0,0,1,-1,2,0,0,0,1,1,1,1,-1,2,1,1,0,0,1,2,-1,0,0,0,0,0,0,1,2,3,-1,1,0,0,0,1,1,0,1,1,2,1,1,0,1,-1,2,1,0,0,0,0,0,1,2,-1,2,-1,1,0,1,1,1,0,0,1,1,2,1,2,-1,3,2,1,1,0,0,0,0,0,1,2,-1,2,-1,2,-1,2,0,0,0,0,0,0,0,0,2,-1,4,3,1,1,2,2,2,1,1,0,0,0,0,0,3,-1,-1,1,0,1,2,-1,4,-1,2,0,0,0,0,0,2,-1,3,1,0,1,-1,3,-1,-1,2,0,0,0,0,0,2,2,2,0,0,1,1,2,2,3,2,1,0,0,0,0,1,-1,3,3,2,0,0,0,1,3,-1,3,1,0,1,1,2,2,-1,-1,-1,0,0,0,1,-1,-1,-1,1,0,1,-1,1,1,2,3,2]).simulator
    @board = SimpleBoard.new(level: :middle).simulator
    @board.show
    @board.show_secret
    
    i_win = true
    _result = turn_up(4, 4)   
    until(@board.complete?)
      puts ""
      safe_point = @board.safe_point
      puts safe_point[:accuracy]
      _result = turn_up(safe_point[:row], safe_point[:column])    
      if _result == -1
        i_win = false
        break
      end
      
      @board.refresh(board: @board.board)
      @board.show
    end
    
    puts ""
    @board.show_secret
    puts ""
    @board.show
    puts ""
    @board.show_sample
    
    puts ""
    if i_win
      puts "you win."
    else
      puts "you lose."
    end
  }
end
