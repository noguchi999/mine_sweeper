# coding: utf-8
require 'rspec'
require File.expand_path('app/number')

describe Number, "write your project describe.".encode(Encoding::Windows_31J) do
  before do
    @number = Number.new
  end
  
  it "write your project test scenario.".encode(Encoding::Windows_31J) do
    @number.should be_true
  end
  
  after do
  end
end