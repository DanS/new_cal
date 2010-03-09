require 'spec_helper'
require 'rake'
require File.expand_path(File.join(File.dirname(__FILE__),'../../..','lib','tasks',
    'gen_img_helpers'))
include GenImgHelpers

describe "dec2bin" do
  [[0, '0'], [7, '111'], [71, '1000111'], [101, '1100101'],
    [142, '10001110'], [191, '10111111'], [247, '11110111']].each do |d,b|
    it "should convert #{d.to_s} to #{b}" do
      dec2bin(d).should == b
    end
  end
end

describe "bin2dec" do
  [['0', 0], ['101', 5], ['110101', 53], ['1101101', 109], ['10100010', 162],
    ['11000101', 197], ['11100110', 230]].each do |b, d|
    it "should convert #{b} to #{d.to_s}" do
      bin2dec(b).should == d
    end
  end
end

describe "number2letters" do
  test_letters = %w(A B C D E F G H)
  Dest = Struct.new :letter
  dest_collection = test_letters.collect {|l| Dest.new l}
  before(:each) do
        Destination ||= double('destination_double').as_null_object 
        Destination.stub(:all).and_return(dest_collection)
    end
    context "should return a different letter for each bit in an eight bit binary number\n" do
      [1, 2, 4, 8, 16, 32, 64, 128].each_with_index do |n, i|
        it "should return #{test_letters[i]} for number2letters(#{n})" do
          number2letters(n).should == test_letters.reverse[i]
        end
      end
    end
    
    context "when multiple bits are set it should return a combination of letters" do
      it "should return 'ABCDEFGH' for 255" do
        number2letters(255).should == 'ABCDEFGH'
      end
      it "should return 'ABCD' for 240" do
        number2letters(240).should == 'ABCD'
      end
      it "should return 'ABCDEFGH' for 255" do
        number2letters(255).should == 'ABCDEFGH'
      end
      it "should return 'EFGH' for 15" do
        number2letters(15).should == 'EFGH'
      end
    end
  end
