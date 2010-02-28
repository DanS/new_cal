# To change this template, choose Tools | Templates
# and open the template in the editor
require File.dirname(__FILE__) + '/spec_helper'

describe "days_in_month" do
  it "should return 31 for january 2010" do
    days_in_month(01, 2010).should == 31
  end
  it "should return 28 for Febuary 2010" do
    days_in_month(02, 2010).should == 28
  end
  it "should  return 29 for Feburary 2012" do
    days_in_month(02, 2012).should == 29
  end
end

describe "weekend_days_in_month" do
  it "should return a hash where weekend day numbers return true" do
    feb_weekends = {27=>true, 16=>false, 5=>false, 22=>false, 11=>false, 28=>true, 17=>false, 6=>true,
      23=>false, 12=>false, 1=>false, 18=>false, 7=>true, 24=>false, 13=>true, 2=>false, 19=>false,
      8=>false, 25=>false, 14=>true, 3=>false, 20=>true, 9=>false, 26=>false, 15=>false, 4=>false,
      21=>true, 10=>false}
    weekend_days_in_month(2, 2010).sort.should == feb_weekends.sort
  end
end

describe "day_class_for" do
  it "should return 'day' for a weekday day in the future" do
    day_class_for(Date.parse('2015-02-02')).should == 'day'
  end
  it "should return 'day past' for a weekday day in the past" do
    day_class_for(Date.parse('2010-02-02')).should == 'day past'
  end
  it "should return 'day weekend for a weekend day in the future" do
    day_class_for(Date.parse('2015-02-01'))
  end
  it "should return 'day past weekend' for a weekend day in the past" do
    day_class_for(Date.parse('2010-02-06')).should == 'day past weekendDay'
  end
end