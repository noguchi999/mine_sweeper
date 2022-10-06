require 'opencv'
require 'optparse'
require 'debugger'
include OpenCV
if __FILE__ == $0
  opt = OptionParser.new
  opts = {}
  opt.on('-i image') {|v| opts[:i] = v }
  opt.on('-x width') {|v| opts[:x] = v }
  opt.on('-y height') {|v| opts[:y] = v }
  opt.on('-s size') {|v| opts[:s] = v }
  opt.on('-r recursive') {|v| opts[:r] = v }
  opt.parse!(ARGV)
  # usage ruby square.rb -i images/board.bmp -x 0 -y 0 -s 18
  # usage ruby square.rb -i images/board.bmp -x 37 -y 80 -s 18 -r a
  
=begin
37*80*18
183*80*18
183*225*18
37*225*18
=end
  
  @width  = opts[:x].to_i
  @height = opts[:y].to_i
  @size   = opts[:s].to_i
  @image  = CvMat.load(opts[:i])
  @recursive = opts[:r]
  
  def recursive?
    !@recursive.nil?
  end
  
  def recursive_process(image_path)
    ((@image.width - @width) / @size).times do |x|
      ((@image.height - @height) / @size).times do |y|
        _image  = CvMat.load(image_path)
        left = (x*@size + @width)
        top  = (y*@size + @height)
        
        # 画像から指定した範囲を切り抜く
        _sub_rect = _image.sub_rect(CvRect.new(left, top, @size, @size))
        _sub_rect.save_image File.expand_path("temp/sub_#{left}_#{top}_#{@size}_#{File.basename(image_path)}")
        
        # 画像の指定した範囲を四角で囲む
        pt1 = CvPoint.new(left, top)
        pt2 = CvPoint.new(left + @size, top + @size)
        _image.rectangle!(pt1, pt2, :color => CvColor::Red, :thickness => 1)
        _image.save_image File.expand_path("temp/#{left}_#{top}_#{@size}_#{File.basename(image_path)}")
      end
    end
  end
  
  def single_process(image_path)
    # 画像から指定した範囲を切り抜く
    _sub_rect = @image.sub_rect(CvRect.new(@width, @height, @size, @size))
    _sub_rect.save_image File.expand_path("temp/sub_#{@width}_#{@height}_#{@size}_#{File.basename(image_path)}")
    
    # 切り抜いた画像と元画像をマッチングさせる。
    result = @image.match_template(_sub_rect, :sqdiff)
    pt1 = result.min_max_loc[2] # min_max_locが返却する配列の3つ目に最小値が、4つ目に最大値が入っている。 match_templateで:sqdiffを指定している場合は、最小値を指定する。:ccoeffを指定している場合は最大値を指定する。    
    pt2 = CvPoint.new(pt1.x + _sub_rect.width, pt1.y + _sub_rect.height)
    @image.rectangle!(pt1, pt2, :color => CvColor::Red, :thickness => 1)
    @image.save_image File.expand_path("temp/#{File.basename(image_path)}")
    
    # 画像の指定した範囲を四角で囲む
    pt1 = CvPoint.new(@width, @height)
    pt2 = CvPoint.new(@width + @size, @height + @size)
    @image.rectangle!(pt1, pt2, :color => CvColor::Red, :thickness => 1)
    @image.save_image File.expand_path("temp/#{@width}_#{@height}_#{@size}_#{File.basename(image_path)}")
  end
  
  if recursive?
    recursive_process opts[:i]
  else
    single_process opts[:i]
  end
end