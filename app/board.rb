# coding: utf-8
require 'pp'
require 'active_support/core_ext'
require 'forwardable'
class Board
  extend Forwardable
  attr_reader :board

  LEVEL = {low: 9, middle: 16, high: 30}
  MINE  = {low: 10, middle: 40, high: 99}
  
  def initialize(options={})
    opts = {level: :low}.merge(options).symbolize_keys

    case opts[:level]
      when :low, :middle
        @board = LEVEL[opts[:level]].times.map{|v| (v+65).chr.to_sym}.inject(Hash.new){|h, key| h.store(key.to_sym, LEVEL[opts[:level]].times.map{|v| 0}); h}
      when :high
        @board = 16.times.map{|v| (v+65).chr.to_sym}.inject(Hash.new){|h, key| h.store(key.to_sym, LEVEL[opts[:level]].times.map{|v| 0}); h}
      else
        raise ArgumentError, "invalid option value #{options.values}. usage :low, :middle, :high"
    end
    
    @board.instance_eval do
      def create_board!(level)
        lower = self.keys[0].to_s.bytes.to_a.first
        upper = self.keys[-1].to_s.bytes.to_a.first
        MINE[level].times do
          row = rand(lower..upper).chr.to_sym
          col = rand(LEVEL[level])
          redo if self[row][col] == -1
          
          self[row][col] = -1
        end
      end
    end
    
    @board.create_board! opts[:level]
  end
  
  def_delegators :@board, :first, :length, :keys, :values
end