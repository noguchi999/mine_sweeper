# coding: utf-8
require 'win32/screenshot' # mini_magick(3.2.1)を利用するために使う。 mogrify.exeなどが同梱されているので便利。
require 'debugger'
require 'win32ole'
require 'opencv'
require 'win32/clipboard'
include OpenCV

#WINDOW     = "マインスイーパ"
#WINDOW     = "無題 - ペイント"
#WINDOW     = "電卓"
WINDOW     = "Microsoft Excel - Book1"
#SAVED_GAME = "保存されたゲームが見つかりました"

autoit = WIN32OLE.new('AutoItX3.Control')
#autoit.Run("C:/Program Files/Microsoft Games/Minesweeper/Minesweeper.exe")
#autoit.Run("calc")
autoit.Run("C:/Program Files/Microsoft Office/Office14/EXCEL.EXE")
autoit.WinWaitActive WINDOW
#hwnd = autoit.WinGetHandle(WINDOW).hex

#if autoit.WinExists(SAVED_GAME) == 1
#  autoit.controlClick(SAVED_GAME, "", "[CLASS:Button; INSTANCE:2]", "left", 2)
#end

def shot(autoit)
  return if Win32::Clipboard.num_formats == 3
  
  Win32::Clipboard.empty
  autoit.Send("!{PRINTSCREEN}")
  shot autoit
end

autoit.WinActivate WINDOW
autoit.WinWaitActive WINDOW
Win32::Clipboard.empty
shot autoit
File.open("temp/hoge.png", "wb") {|io| io.write Win32::Clipboard.data(Win32::Clipboard::DIB)}
begin
  # Win32::Clipboard.dataから作成したファイルのままではCvMatで読み込めなかったので、MiniMagickを利用してフォーマット変換したファイルをCvMatで読み込ませている.
  image = MiniMagick::Image.new('temp/hoge.png')
  image.format "bmp"
  image.write "temp/hoge.bmp"
rescue => e
  puts e
end
image = CvMat.load("temp/hoge.bmp")
image.save_image File.expand_path("temp/board.bmp")
FileUtils.rm ["temp/hoge.bmp", "temp/hoge.png"]
autoit.WinClose(WINDOW)