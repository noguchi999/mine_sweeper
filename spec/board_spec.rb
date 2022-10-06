# coding: utf-8
require 'rspec'
require File.expand_path('app/board')

describe Board, "難易度に応じたマスと地雷が設置されること. 初級：9×9のマスに10個の地雷, 中級：16×16のマスに40個の地雷, 上級：30×16のマスに99個の地雷".encode(Encoding::Windows_31J) do
  before do
  end
  
  it "levelが :lowの場合に、9×9のマスに10個の地雷が設置されること.".encode(Encoding::Windows_31J) do
    @board = Board.new(level: :low)
    cells  = @board.length * @board.first.last.length
    mines  = @board.values.map{|v| v.select{|vv| vv == -1}}.inject(:+).inject(:+)
    
    cells.should == 81 && mines.should == -10
  end
  
  after do
  end
end