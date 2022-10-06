# coding: utf-8
if __FILE__ == $0
  
  boards = []
  open("data/simple_board.txt") do |f|
    f.each_with_index do |line, index|
      boards << line
      
      puts index if (index%10000 == 0)
    end
  end
  boards.sort!
  
  _bords = []
  boards.each_with_index do |line, index|
    _bords << line
    
    if (_bords.length == 100000)
      open("data/simple_board_sorted.txt", "a") do |fw|
        fw.puts _bords.join("")
      end
      _bords = []
      puts (index + 1)
    end
  end
  open("data/simple_board_sorted.txt", "a") do |fw|
    fw.puts _bords.join("")
  end
  
  puts boards.length == boards.uniq.length
end