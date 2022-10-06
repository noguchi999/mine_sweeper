# coding: utf-8
require 'win32ole'
require 'win32/screenshot'
require 'win32/clipboard'
require 'opencv'
module Screenshot
  include OpenCV 
  
  class Image
    attr_reader :data
    
    def initialize(file_path, format)
      case format
      when :cvmat
        @data = OpenCV::CvMat.load(file_path)
      else
        raise ArgumentError, "invalid format #{format}. usage :cvmat"
      end
    end
  end
  
  class Take
    class << self
    
      def of(autoit, window_title)
        autoit.WinActivate   window_title
        autoit.WinWaitActive window_title
        
        shot autoit
        conversion autoit
        
        image = Image.new("temp/screen.bmp", :cvmat)
        FileUtils.rm ["temp/screen.png"]
        image
      end
      
      def dummy
        Image.new("temp/screen.bmp", :cvmat)
      end
      
      private
        def shot(autoit)
          Win32::Clipboard.empty
          autoit.Send("!{PRINTSCREEN}")
          File.open("temp/screen.png", "wb") {|io| io.write Win32::Clipboard.data(Win32::Clipboard::DIB)}
          
          if FileTest.size("temp/screen.png") == 0
            shot(autoit)
          end
        end
        
        def conversion(autoit)
          begin
            # Win32::Clipboard.dataから作成したファイルのままではCvMatで読み込めなかったので、MiniMagickを利用してフォーマット変換したファイルをCvMatで読み込ませている.
            image = MiniMagick::Image.new "temp/screen.png"
            image.format "bmp"
            image.write "temp/screen.bmp"
          rescue => e
            #puts e
          end
          
          if FileTest.size("temp/screen.bmp") == 0
            shot autoit
            conversion autoit
          end
        end
    end
  end
end