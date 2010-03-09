require File.dirname(__FILE__) + '/../spec_helper'


describe TripsHelper do
  # #  before(:each) do
  # #    @trips_helper = TripsHelper.new
  # #  end
  #
  #  describe "next_3_months_years" do
  #    it "should return the same 3 month/ years when sent different days in the same month" do
  #      helper.next_3_months_years("20100201").should == [[2, 2010], [3, 2010], [4, 2010]]
  #      helper.next_3_months_years("20100215").should == [[2, 2010], [3, 2010], [4, 2010]]
  #      helper.next_3_months_years("20100201").should == [[2, 2010], [3, 2010], [4, 2010]]
  #    end
  #    it "should cross into the next year when given dates in November and December" do
  #      helper.next_3_months_years("20101101").should == [[11, 2010], [12, 2010], [1, 2011]]
  #      helper.next_3_months_years("20101215").should == [[12, 2010], [1, 2011], [2, 2011]]
  #    end
  #  end

  describe "time_selectors" do
    it "should create a list of time selection values" do
      helper.time_selectors.should == ["Unknown", "Midnight", "01:00AM", "01:30AM",
        "02:00AM", "02:30AM", "03:00AM", "03:30AM", "04:00AM", "04:30AM", "05:00AM",
        "05:30AM", "06:00AM", "06:30AM", "07:00AM", "07:30AM", "08:00AM", "08:30AM",
        "09:00AM", "09:30AM", "10:00AM", "10:30AM", "11:00AM", "11:30AM", "Noon",
        "12:30PM", "01:00PM", "01:30PM", "02:00PM", "02:30PM", "03:00PM", "03:30PM",
        "04:00PM", "04:30PM", "05:00PM", "05:30PM", "06:00PM", "06:30PM", "07:00PM",
        "07:30PM", "08:00PM", "08:30PM", "09:00PM", "09:30PM", "10:00PM", "10:30PM",
        "11:00PM", "11:30PM", "12:00AM"]
    end
  end

  # describe "trips_in_week" do
  #    it "should return trips for the given week" do
  #      week_start = Date.parse("2010-02-07")
  #      (1..6).to_a.each {|i| Factory.create(:trip, :date => week_start + i.days)}
  #      trips = helper.trips_in_week(6, 2010)
  #      trips.length.should == 7
  #      trips.values.select {|t| t[0].class == Trip}.length.should == 6
  #    end
  #  end
  #
  #  describe "ymd_to_date" do
  #    it "should return a date from a year-month-day string" do
  #      helper.ymd_to_date("20100101").should == Date.parse('20100101')
  #    end
  #  end
  #
  #  describe "dates_between" do
  #    it "should return a array of strings describing all the dates between dates given" do
  #      helper.dates_between('20100101', '20100107').should == ["20100101", "20100102",
  #        "20100103", "20100104", "20100105", "20100106", "20100107"]
  #      helper.dates_between('20091229', '20100107').should == ["20091229", "20091230",
  #        "20091231", "20100101", "20100102", "20100103", "20100104", "20100105",
  #        "20100106", "20100107"]
  #    end
  #  end
  #
  describe "class_for_day" do
    before(:each) do
      @today = Date.today
      Factory(:destination, :place => "Beta",  :letter => 'B')
      Factory(:destination, :place => "Gamma", :letter => 'C')
      Factory(:destination, :place => "Alpha", :letter => 'A')
    end
    
    it "should produce a class name containing all the letters for the days destinations" do
      Factory(:trip, :date => @today, :destination => 'Alpha')
      helper.class_for_day(@today.year, @today.month, @today.day).should == 'day A'
    end
    it "should produce multiple letters if there are multiple destiantions" do
      #letters should be sorted alphabetically
      Factory(:trip, :date => @today, :destination => 'Beta')
      Factory(:trip, :date => @today, :destination => 'Gamma')
      Factory(:trip, :date => @today, :destination => 'Alpha')
      helper.class_for_day(@today.year, @today.month, @today.day).should == 'day ABC'
    end
    it "should not produce multiple letters if destinations are duplicated" do
      Factory(:trip, :date => @today, :destination => 'Alpha')
      Factory(:trip, :date => @today, :destination => 'Alpha')
      Factory(:trip, :date => @today, :destination => 'Alpha')
      helper.class_for_day(@today.year, @today.month, @today.day).should == 'day A'
    end
    it "should produce an empty string if there are no trips on that day" do
      helper.class_for_day(@today.year, @today.month, @today.day).should == 'day'
    end
  end
end
