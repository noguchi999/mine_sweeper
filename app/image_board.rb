# coding: utf-8
require 'opencv'
class ImageBoard
  include OpenCV 
  
  STATUS  = {left: 38, top: 79, size: 18}
  NUMBERS = {"0" => 0, "1" => 0, "2" => 0, "3" => 0, "4" => 0, "5" => 0, "19" => 1, "20" => 1, "21" => 1, "22" => 1, "23" => 1, "24" => 1, "40" => 2, "41" => 2, "42" => 2, "43" => 2, "60" => 3, "61" => 3, "62" => 3, "63" => 3, "64" => 3, "83" => 4, "84" => 4, "85" => 4, "86" => 4, "87" => 4, "102" => 5, "103" => 5, "104" => 5, "105" => 5, "106" => 5, "119" => 6, "120" => 6, "121" => 6, "122" => 6, "123" => 6, "124" => 6, "125" => 6, "126" => 6, "182" => 9, "183" => 9, "184" => 9, "185" => 9, "186" => 9}
  NUMBER_PLATE = CvMat.load("images/numbers.bmp")
    
  def initialize(options={})
    raise ArgumentError, "usage new(:column_size => 9, :row_size => 9)" unless ([:column_size, :row_size] - options.keys).empty?
    opts = options

    @mouse       = {left: opts[:mouse_left], top: opts[:mouse_top]}
    @row_size    = opts[:row_size]
    @column_size = opts[:column_size]
    @cache_board = []
  end
    
  def load(image)
    @@image = image
  end
  
  def refresh(options={})
    raise ArgumentError, "invalid options. ex.) :board => [0, 1, 3]" unless ([:board] - options.keys).empty?
    opts = options
    
    load opts[:board]
  end
  
  def get(options={})
    raise ArgumentError, "usage get(:column => 2, :row => 8)" unless ([:column, :row] - options.keys).empty?
    opts = options
    
    left     = opts[:column] * STATUS[:size] + STATUS[:left]
    top      = opts[:row] * STATUS[:size] + STATUS[:top]
    template = @@image.data.sub_rect(CvRect.new(left, top, STATUS[:size], STATUS[:size]))
    #template.save_image File.expand_path("temp/sub_#{left}_#{top}_#{opts[:row]}_#{opts[:column]}.bmp")
    
    result   = NUMBER_PLATE.match_template(template, :sqdiff)
    pointer  = result.min_max_loc[2]
    #puts "#{left}_#{top} : #{pointer.x} : #{NUMBERS[pointer.x.to_s]} : #{opts[:row]} : #{opts[:column]}"
    NUMBERS[pointer.x.to_s]
  end
  
  def coord(options={})
    raise(ArgumentError, "usage coord(:column => 2, :row => 8)") unless ([:column, :row] - options.keys).empty?
    opts = options
    
    {top: (opts[:row]*STATUS[:size] + @mouse[:top]), left: (opts[:column]*STATUS[:size] + @mouse[:left])}
  end
  
  def to_a
    _board = []
    @row_size.times do |x|
      @column_size.times do |y|
        if @cache_board.length == (@row_size * @column_size) && @cache_board[x*@column_size + y] != "#"
          #puts "cache: #{x} : #{y} : #{@cache_board[x*@column_size + y]}"
          _board << @cache_board[x*@column_size + y]
        else
          number = get(row: x, column: y)
          number = "#" if number == 9
          _board << number
        end
      end
    end
    @cache_board = _board
    _board
  end
end