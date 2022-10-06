# coding: utf-8
require 'rspec'
require File.expand_path('app/mine')

describe Mine, "write your project describe.".encode(Encoding::Windows_31J) do
  before do
    @mine = Mine.new
  end
  
  it "write your project test scenario.".encode(Encoding::Windows_31J) do
    @mine.should be_true
  end
  
  after do
  end
end