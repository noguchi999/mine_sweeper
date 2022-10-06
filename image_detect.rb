require 'opencv'
require 'optparse'
require 'debugger'
include OpenCV
if __FILE__ == $0
  opt = OptionParser.new
  opts = {}
  opt.on('-b base_image') {|v| opts[:b] = v }
  opt.on('-t template_image') {|v| opts[:t] = v }
  opt.parse!(ARGV)
  # usage ruby image_detect.rb -b images/board.bmp -t images/1.bmp
  
  image    = CvMat.load(opts[:b])
  template = CvMat.load(opts[:t])
  
  result = image.match_template(template, :sqdiff)
  
  pt1 = result.min_max_loc[2] # min_max_locが返却する配列の3つ目に最小値が、4つ目に最大値が入っている。 match_templateで:sqdiffを指定している場合は、最小値を指定する。:ccoeffを指定している場合は最大値を指定する。
  puts "pt1: #{pt1.x} : #{pt1.y}"
  puts "template: #{template.width} : #{template.height}"
  
  pt2 = CvPoint.new(pt1.x + template.width, pt1.y + template.height)
  image.rectangle!(pt1, pt2, :color => CvColor::Red, :thickness => 1)
  
  image.save_image File.expand_path("temp/#{File.basename(opts[:b])}")
end