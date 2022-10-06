# coding: utf-8
require 'opencv'
require 'win32ole'
require File.expand_path('lib/ruby_prof')
require File.expand_path('app/screenshot')
require File.expand_path('app/simple_board')
require File.expand_path('app/image_board')

if __FILE__ == $0
  include Screenshot

  WINDOW     = "マインスイーパ"
  SAVED_GAME = "保存されたゲームが見つかりました"
  LOSE       = "負けました"
  I_WIN      = "勝ちました"
  MOUSE_SPEED = 0
  
  autoit = WIN32OLE.new('AutoItX3.Control')
  autoit.Run("C:/Program Files/Microsoft Games/Minesweeper/Minesweeper.exe")
  autoit.WinWaitActive WINDOW
  hwnd = autoit.WinGetHandle(WINDOW).hex
  
  if autoit.WinExists(SAVED_GAME) == 1
    autoit.controlClick(SAVED_GAME, "", "[CLASS:Button; INSTANCE:2]", "left", 2)
  end
  
  autoit.Sleep(1000)
  @mouse_left = autoit.WinGetPosX(WINDOW) + 45
  @mouse_top  = autoit.WinGetPosY(WINDOW) + 88
  puts "left: #{@mouse_left}, top: #{@mouse_top}"
  autoit.MouseMove(@mouse_left, @mouse_top, MOUSE_SPEED)
  
  [0,1,2,3,4,5,6,7,8,10,11,13,14,15].each do |x|
    y = 0
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end

  [0,1,2,5,6,7,8,9,10,11,12,13,14,15].each do |x|
    y = 1
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end

  [0,1,2,3,4,5,8,9,10,11,12,13,14,15].each do |x|
    y = 2
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,2,3,5,6,7,8,9,11,12,13,15].each do |x|
    y = 3
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end

  [0,1,2,3,4,6,7,9,10,11,12,13,14,15].each do |x|
    y = 4
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,2,3,4,5,7,8,9,10,11,12,13,14,15].each do |x|
    y = 5
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15].each do |x|
    y = 6
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,2,3,4,5,7,8,9,10,12,13,15].each do |x|
    y = 7
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [1,2,4,5,7,8,9,10,11,12,13,14,15].each do |x|
    y = 8
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,2,3,4,5,6,7,8,9,10,11,12,13,15].each do |x|
    y = 9
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,3,4,5,6,7,8,9,11,12,15].each do |x|
    y = 10
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [1,2,3,6,7,8,10,13,14,15].each do |x|
    y = 11
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,3,4,6,7,8,9,10,11,12,13,14,15].each do |x|
    y = 12
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,2,3,4,5,6,8,9,10,11,12,13,14,15].each do |x|
    y = 13
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [0,1,3,4,7,8,9,10,11,13].each do |x|
    y = 14
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  [1,2,3,4,6,7,8,9,10,12,13,15].each do |x|
    y = 15
    autoit.MouseMove(@mouse_left + (x*18), @mouse_top + (y*18), MOUSE_SPEED)
    autoit.MouseClick
  end
  
  @board = ImageBoard.new(:column_size => 9, :row_size => 9)
  screenshot = take(autoit, WINDOW)
  @board.load screenshot
  puts @board.get(column: 15, row: 14)
  
=begin
  autoit.Sleep(5000)
  if autoit.WinExists(LOSE) == 1
    puts autoit.WinGetText(LOSE)
    autoit.controlClick(LOSE, "", "[CLASS:Button; INSTANCE:1]", "left", 2)
  end
  
  if autoit.WinExists(I_WIN) == 1
    puts autoit.WinGetText(I_WIN)
    autoit.controlClick(I_WIN, "", "[CLASS:Button; INSTANCE:2]", "left", 2)
  end
=end
end