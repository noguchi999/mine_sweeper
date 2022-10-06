# coding: utf-8
require 'rspec'
require File.expand_path('app/simple_board_simulator')

describe SimpleBoardSimulator, "難易度に応じたマスと地雷が設置されること。".encode(Encoding::Windows_31J) do
  before do
  end
  
  it "levelが :lowの場合に、9×9のマスに10個の地雷が設置されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :low)
    cells  = @simple_board.length
    mines  = @simple_board.select{|v| v == -1}.inject(:+)
    
    cells.should == 81 && mines.should == -10
  end
  
  it "levelが :middleの場合に、16×16のマスに40個の地雷が設置されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :middle)
    cells  = @simple_board.length
    mines  = @simple_board.select{|v| v == -1}.inject(:+)
    
    cells.should == 256 && mines.should == -40
  end
  
  it "levelが :highの場合に、16×30のマスに99個の地雷が設置されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :high)
    cells  = @simple_board.length
    mines  = @simple_board.select{|v| v == -1}.inject(:+)
    
    cells.should == 480 && mines.should == -99
  end
  
  it "levelが :lowの場合に、マスの周囲にある地雷の数を正しくカウント出来ていること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :low)
    
    puts ""
    @simple_board.show
  end
  
  it "levelが :middleの場合に、マスの周囲にある地雷の数を正しくカウント出来ていること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :middle)
    
    puts ""
    @simple_board.show
  end
  
  it "levelが :highの場合に、マスの周囲にある地雷の数を正しくカウント出来ていること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :high)
    
    puts ""
    @simple_board.show
  end
  
  it "levelが :lowの場合に、boardを2次元配列に変換できること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :high)
    
    _2d = @simple_board.to_2d
    _2d[0][0].nil?.should be_false
    _2d[0][8].nil?.should be_false
    _2d[0][0].nil?.should be_false
    _2d[8][8].nil?.should be_false
  end
  
  it "levelが :lowの場合に、8辺探索が行えること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :low)
    
    puts ""
    puts @simple_board.board2d[0].join("").gsub(/-1/, '*')
    puts @simple_board.board2d[1].join("").gsub(/-1/, '*')
    puts @simple_board.board2d[2].join("").gsub(/-1/, '*')
    
    _octa = @simple_board.octa_around(row: 1, column: 1)
    _octa.each do |key, value|
      puts "#{key} : #{value.to_s.gsub(/-1/, '*')}"
    end
  end
  
  it "levelが :lowの場合に、9x9の#で埋められたboard_maskedが作成されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :low)

    @simple_board.board_masked[0].should eql %w[# # # # # # # # #]
    @simple_board.board_masked[8].should eql %w[# # # # # # # # #]
    @simple_board.board_masked[9].should be_false
  end
  
  it "SimpleBoardの任意の場所をturn_upして、board_maskedを開くことが出来ること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :low)
    @simple_board.turn_up(row: 0, column: 0)
    
    puts ""
    @simple_board.show_secret
    puts ""
    @simple_board.show
  end
  
  it "SimpleBoardの任意の場所をgetで取得出来ること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoardSimulator.new(level: :low)
    @simple_board.turn_up(row: 4, column: 1)
    
    @simple_board.get(row: 4, column: 1).should eql @simple_board.board_masked[4][1]
  end
    
  it "newの引数にsymbol以外のkeyを持つHashを渡した場合に、ArgumentErrorになること。".encode(Encoding::Windows_31J) do
    -> {SimpleBoardSimulator.new("level" => :low)}.should raise_error(ArgumentError)
  end
  
  it "newの引数に:low, :middle, :high以外を渡した場合に、ArgumentErrorになること。".encode(Encoding::Windows_31J) do
    -> {SimpleBoardSimulator.new(level: "low")}.should raise_error(ArgumentError)
  end
  
  after do
  end
end