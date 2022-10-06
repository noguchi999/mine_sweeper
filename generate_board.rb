# coding: utf-8
require File.expand_path('app/simple_board')

if __FILE__ == $0
  
  boards = []
  total  = 0
  while(true)
    board = SimpleBoard.new(level: :low)
    boards << board.join("").gsub(/-1/, "*")
    
    if boards.length == 100000
      open("data/simple_board.txt", "a") do |fw|
        fw.puts boards.join("\n")
      end
      boards = []
      total += 100000
    end
    
    break if total >= 13000000
  end
end