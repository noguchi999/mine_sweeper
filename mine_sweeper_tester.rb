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
  @mouse_left += 342
  @mouse_top  += 185
  puts "left: #{@mouse_left}, top: #{@mouse_top}"
  autoit.MouseMove(@mouse_left, @mouse_top, MOUSE_SPEED)
end