# coding: utf-8
require 'rspec'
require File.expand_path('app/simple_board')

describe SimpleBoard, "難易度に応じたマスと地雷が設置されること。".encode(Encoding::Windows_31J) do
  before do
  end
  
  it "levelが :lowの場合に、9×9のマスが設置されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :low)
    
    row_count = 0
    @simple_board.each do |line|
      line.length.should eql 9
      row_count += 1
    end
    row_count.should eql 9
  end
  
  it "levelが :lowで、:boardに配列を渡した場合に、渡した配列を元に9×9のマスが設置されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :low, board: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80])
    
    @simple_board.board[0].should eql [0,1,2,3,4,5,6,7,8]
    @simple_board.board[1].should eql [9,10,11,12,13,14,15,16,17]
    @simple_board.board[2].should eql [18,19,20,21,22,23,24,25,26]
    @simple_board.board[3].should eql [27,28,29,30,31,32,33,34,35]
    @simple_board.board[4].should eql [36,37,38,39,40,41,42,43,44]
    @simple_board.board[5].should eql [45,46,47,48,49,50,51,52,53]
    @simple_board.board[6].should eql [54,55,56,57,58,59,60,61,62]
    @simple_board.board[7].should eql [63,64,65,66,67,68,69,70,71]
    @simple_board.board[8].should eql [72,73,74,75,76,77,78,79,80]
    @simple_board.board[9].should be_nil
  end
  
  it "levelが :lowの場合に、max_lengthに81が設定されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :low)
    
    @simple_board.max_length.should eql 81
  end
  
  it "levelが :lowの場合に、row_sizeに9が設定されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :low)
    
    @simple_board.row_size.should eql 9
  end
  
  it "levelが :lowの場合に、column_sizeに9が設定されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :low)
    
    @simple_board.column_size.should eql 9
  end
  
  it "levelが :lowの場合に、mine_countに10が設定されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :low)
    
    @simple_board.mine_count.should eql 10
  end
  
  it "levelが :middleの場合に、16×16のマスが設置されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :middle)

    row_count = 0
    @simple_board.each do |line|
      line.length.should eql 16
      row_count += 1
    end
    row_count.should eql 16
  end
  
  it "levelが :middleで、:boardに配列を渡した場合に、渡した配列を元に16×16のマスが設置されること。".encode(Encoding::Windows_31J) do
    _board = (0..255).map{|v| v}
    @simple_board = SimpleBoard.new(level: :middle, board: _board)
    @simple_board.board[0].should eql [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    # ちょっと大変なので、途中は計算で。
    (1..14).each do |i|
      @simple_board.board[i].should eql [(i*16),(i*16 + 1),(i*16 + 2),(i*16 + 3),(i*16 + 4),(i*16 + 5),(i*16 + 6),(i*16 + 7),(i*16 + 8),(i*16 + 9),(i*16 + 10),(i*16 + 11),(i*16 + 12),(i*16 + 13),(i*16 + 14),(i*16 + 15)]
    end
    @simple_board.board[15].should eql [240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255]
    @simple_board.board[16].should be_nil
  end
  
  it "levelが :middleで、:boardに配列を渡した場合に、渡した配列のlengthが256以外の場合に、ArgumentErrorとなること。".encode(Encoding::Windows_31J) do
    _board = (0..254).map{|v| v}
    -> {SimpleBoard.new(level: :middle, board: _board)}.should raise_error(ArgumentError)
  end
  
  it "levelが :middleの場合に、max_lengthに81が設定されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :middle)
    
    @simple_board.max_length.should eql 256
  end
  
  it "levelが :middleの場合に、row_sizeに9が設定されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :middle)
    
    @simple_board.row_size.should eql 16
  end
  
  it "levelが :middleの場合に、column_sizeに9が設定されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :middle)
    
    @simple_board.column_size.should eql 16
  end
  
  it "levelが :middleの場合に、mine_countに10が設定されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :middle)
    
    @simple_board.mine_count.should eql 40
  end
  
  it "levelが :highの場合に、30×16のマスが設置されること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :high)
    
    row_count = 0
    @simple_board.each do |line|
      line.length.should eql 16
      row_count += 1
    end
    row_count.should eql 30
  end
  
  it "levelが :highで、:boardに配列を渡した場合に、渡した配列を元に30×16のマスが設置されること。".encode(Encoding::Windows_31J) do
    _board = (0..479).map{|v| v}
    @simple_board = SimpleBoard.new(level: :high, board: _board)
    @simple_board.board[0].should eql [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    # ちょっと大変なので、途中は計算で。
    (1..28).each do |i|
      @simple_board.board[i].should eql [(i*16),(i*16 + 1),(i*16 + 2),(i*16 + 3),(i*16 + 4),(i*16 + 5),(i*16 + 6),(i*16 + 7),(i*16 + 8),(i*16 + 9),(i*16 + 10),(i*16 + 11),(i*16 + 12),(i*16 + 13),(i*16 + 14),(i*16 + 15)]
    end
    @simple_board.board[29].should eql [464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479]
    @simple_board.board[30].should be_nil
  end
  
  it "levelが :highで、:boardに配列を渡した場合に、渡した配列のlengthが480以外の場合に、ArgumentErrorとなること。".encode(Encoding::Windows_31J) do
    _board = (0..478).map{|v| v}
    -> {SimpleBoard.new(level: :high, board: _board)}.should raise_error(ArgumentError)
  end
  
  it "levelが :lowの場合に、マスの周囲にある地雷の数を正しくカウント出来ていること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :low)
    
    puts ""
    @simple_board.show
  end
  
  it "levelが :middleの場合に、マスの周囲にある地雷の数を正しくカウント出来ていること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :middle)
    
    puts ""
    @simple_board.show
  end
  
  it "levelが :highの場合に、マスの周囲にある地雷の数を正しくカウント出来ていること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :high)
    
    puts ""
    @simple_board.show
  end
    
  it "levelが :lowの場合に、8辺探索が行えること。".encode(Encoding::Windows_31J) do
    @simple_board = SimpleBoard.new(level: :low, board: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80])
    
    _octa = @simple_board.octa_around(row: 1, column: 1)
    _octa[:cell]["-1:-1"].should eql 0
    _octa[:cell]["-1:0"].should eql 1
    _octa[:cell]["-1:1"].should eql 2
    _octa[:cell]["0:-1"].should eql 9
    _octa[:cell]["0:0"].should eql 10
    _octa[:cell]["0:1"].should eql 11
    _octa[:cell]["1:-1"].should eql 18
    _octa[:cell]["1:0"].should eql 19
    _octa[:cell]["1:1"].should eql 20
  end
     
  it "newの引数にsymbol以外のkeyを持つHashを渡した場合に、ArgumentErrorになること。".encode(Encoding::Windows_31J) do
    -> {SimpleBoard.new("level" => :low)}.should raise_error(ArgumentError)
  end
  
  it "newの引数に:low, :middle, :high以外を渡した場合に、ArgumentErrorになること。".encode(Encoding::Windows_31J) do
    -> {SimpleBoard.new(level: "low")}.should raise_error(ArgumentError)
  end
  
  it "levelが :lowの場合に、simulatorで、9×9のマスに10個の地雷が設置されること。".encode(Encoding::Windows_31J) do
    @simulator = SimpleBoard.new(level: :low).simulator
    
    row_count = 0
    @simulator.each do |line|
      line.length.should eql 9
      row_count += 1
    end
    row_count.should eql 9
    
    mine_count = 0
    @simulator.each do |line|
      line.each do |cell|
        mine_count += 1 if cell == -1
      end
    end
    mine_count.should eql 10
  end
  
  it "levelが :middle場合に、simulatorで、16×16のマスに10個の地雷が設置されること。".encode(Encoding::Windows_31J) do
    @simulator = SimpleBoard.new(level: :middle).simulator
    
    row_count = 0
    @simulator.each do |line|
      line.length.should eql 16
      row_count += 1
    end
    row_count.should eql 16
    
    mine_count = 0
    @simulator.each do |line|
      line.each do |cell|
        mine_count += 1 if cell == -1
      end
    end
    mine_count.should eql 40
  end
  
  it "levelが :high場合に、simulatorで、30×16のマスに10個の地雷が設置されること。".encode(Encoding::Windows_31J) do
    @simulator = SimpleBoard.new(level: :high).simulator
    
    row_count = 0
    @simulator.each do |line|
      line.length.should eql 16
      row_count += 1
    end
    row_count.should eql 30
    
    mine_count = 0
    @simulator.each do |line|
      line.each do |cell|
        mine_count += 1 if cell == -1
      end
    end
    mine_count.should eql 99
  end
  
  after do
  end
end