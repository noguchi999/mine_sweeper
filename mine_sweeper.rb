# coding: utf-8
require 'debugger'
require 'win32ole'
require File.expand_path('lib/ruby_prof')
require File.expand_path('app/screenshot')
require File.expand_path('app/simple_board')
require File.expand_path('app/image_board')
require File.expand_path('app/simple_board_simulator')

#result = RubyProf.profiler {
if __FILE__ == $0
  include SimpleBoardSimulator
  
  WINDOW      = "マインスイーパ"
  SAVED_GAME  = "保存されたゲームが見つかりました"
  LOSE        = "負けました"
  I_WIN       = "勝ちました"
  MOUSE_SPEED = 1
  CLICK_LIMIT = 256
  
  INIT_ROW    = 8
  INIT_COLUMN = 8
  
  @click_count = 0
  @game_id     = nil
  
  def turn_up(options={})
    raise ArgumentError, "usage turn_up(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
    opts = options
    
    @simple_board.show
    coord = @image_board.coord(opts)
    @autoit.MouseMove(coord[:left], coord[:top], MOUSE_SPEED)
    @autoit.MouseClick
    puts "turn_up #{opts[:row]} : #{opts[:column]} : #{coord[:top]} : #{coord[:left]} : #{opts[:accuracy]}"
    @click_count += 1
  end
  
  def log
    FileUtils.mkdir "C:/work/mine_sweeper/log/#{@game_id}"
    FileUtils.mv Dir.glob("temp/*.*"), "C:/work/mine_sweeper/log/#{@game_id}"
  end
  
  def game_over?
    @autoit.WinExists(I_WIN) == 1 || @autoit.WinExists(LOSE) == 1 || @click_count > CLICK_LIMIT
  end
  
  def build_board
    @image_board.load Screenshot::Take.of(@autoit, WINDOW)
    @simple_board.refresh(board: @image_board.to_a)
    
    # Test用
    #@image_board.load Screenshot::Take.dummy
    #@simple_board.refresh(board: @image_board.to_a)
  end
  
  def play
    @game_id = Time.now.tv_sec.to_s
    @autoit.WinActivate WINDOW    
    #@autoit.Sleep(1000)
    
    @simple_board = SimpleBoard.new(level: :middle)
    @image_board  = ImageBoard.new(row_size: @simple_board.row_size, column_size: @simple_board.column_size, mouse_left: @mouse_left, mouse_top: @mouse_top)
    
    @autoit.MouseMove(349, 338, MOUSE_SPEED)
    @autoit.MouseClick
    build_board
    until(game_over?)
      break if game_over?
      
      safe_point = @simple_board.safe_point([:safety])
      if safe_point
        break if game_over?
        @simple_board.turn_up safe_point
      else
        build_board
        
        if @simple_board.mask_remains > 15 || @simple_board.mine_remains > 4
          safe_point = @simple_board.safe_point(%w(safety almost_safe recommend normal risky gamble))
        else
          safe_point = @simple_board.safe_point(%w(safety almost_safe recommend virtual normal risky gamble))
        end
      end
      
      break if game_over?
      turn_up(safe_point) if safe_point
    end
    
    if @autoit.WinExists(I_WIN) == 1
      puts @autoit.WinGetText(I_WIN)
      #@autoit.controlClick(I_WIN, "", "[CLASS:Button; INSTANCE:1]", "left", 2)
      #@click_count = 0
      #play
    end
    
    if @autoit.WinExists(LOSE) == 1
      #puts @autoit.WinGetText(LOSE)
      #puts "game_id: #{@game_id}"
      #@simple_board.show
      #@autoit.controlClick(LOSE, "", "[CLASS:Button; INSTANCE:1]", "left", 2)
      #@click_count = 0
      #log
      #play
    end
  end
  
  @autoit = WIN32OLE.new('AutoItX3.Control')
  @autoit.Run("C:/Program Files/Microsoft Games/Minesweeper/Minesweeper.exe")
  @autoit.WinWaitActive WINDOW
  if @autoit.WinExists(SAVED_GAME) == 1
    @autoit.controlClick(SAVED_GAME, "", "[CLASS:Button; INSTANCE:2]", "left", 2)
  end
  @mouse_left = @autoit.WinGetPosX(WINDOW) + 45
  @mouse_top  = @autoit.WinGetPosY(WINDOW) + 88
  
  play
end
#}
#puts result