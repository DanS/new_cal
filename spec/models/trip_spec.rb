require 'spec_helper'

describe Trip do
  before(:each) do
    @valid_attributes = {
      :date => Date.today,
      :contact => 'Joe',
      :community => 'Dancing Rabbit',
      :preferred_vehicle => 'Truck',
      :travelers => 2 ,
      :destination => 'Rutledge',
      :notes => "Zim's here we come",
      :depart => Time.parse('10:15AM'),
      :return => Time.parse('12:30PM')
    }
  end

  it "should create a new instance given valid attributes" do
    Trip.create!(@valid_attributes)
  end

  it "should not be valid without all required attributes" do
    [:date, :contact, :community, :destination].each do |attrib|
      @valid_attributes[attrib] = nil
      trip = Trip.create(@valid_attributes)
      trip.should_not be_valid
    end
  end

  it "should return upcoming trips" do
    (-5..5).each {|i| Factory(:trip, :date => Date.today + i.day)}
    Trip.upcoming.count.should == 6
  end

  it "should return upcoming trips in order by date/ departure time" do
    add_unordered_trips #defined in my_spec_helpers
    Trip.upcoming.collect {|t| t.notes}.should == ["trip-1", "trip-2", "trip-3",
      "trip-4", "trip-5", "trip-6", "trip-7", "trip-8", "trip-9"]
  end

  it "should list number of trips to each destination in upcoming trips" do
    destinations = {'Quincy' => 1, 'Rutledge' => 2, 'La Plata' => 3, 'Kirksville' => 4,
                    'Memphis' => 1, 'Fairfield' => 1}
    destinations.each {|dest, count| count.times {Factory(:trip, :destination => dest)}}
    destination_list = destinations.collect {|k,v| k + "(#{v})"}
    Trip.list_destinations.should == destination_list.sort
  end

  context "trips.by_date_string" do
    before(:each) do
      dates = (1..3).collect {|i| Date.today + i.days}
      trips = Hash.new([])
      dates.each_with_index do |d, j|
        date_str = d.strftime("%Y%m%d")
        (j + 1).times {trips[date_str] = trips[date_str] << Factory(:trip, :date => d)}
      end
      @date_strings = dates.collect {|d| d.strftime("%Y%m%d")}
    end
    it "should have 3 date keys" do
      Trip.by_date_string.keys.length.should == 3
    end
    it "should have 1 trip in the lowest date" do
      Trip.by_date_string[@date_strings[0]].length.should == 1
    end
    it "should have 3 trips in the highest date" do
      Trip.by_date_string[@date_strings[2]].length.should == 3
    end
    it "should only contain trip objects as values" do
      Trip.by_date_string.values.flatten.all? {|t| t.class == Trip}.should == true
    end
  end
  it "should return trips for the next 3 months" do
    4.times {|i| Factory(:trip, :date => Date.today + i.months)}
    Trip.next_3_months.count.should == 3
    Trip.next_3_months[0].class.should == Trip
  end

  context "for_week_year method" do
    before(:each) do
      days_to_start_of_next_week = 7 - Date.today.wday
      @current_week_num = Date.today.cweek
      days_of_week_to_test = [0, 2, 3, 6]
      dates_in_next_4_weeks = [1,2,3,4].map do |week|
        Date.today + ((week * 7) + days_of_week_to_test[week - 1] + days_to_start_of_next_week).days
      end
      @wk_yr_to_test = []
      dates_in_next_4_weeks.each do |d|
        Factory(:trip, :date => d)
        @wk_yr_to_test << [d.cweek, d.year]
      end
    end
    it "should not have any trips in the current week" do
      Trip.for_week_year(@current_week_num, Date.today.year).count.should == 0
    end
    it "should have one trip in each of the next 4 weeks" do
      @wk_yr_to_test.each do |wk_yr|
        puts "Testing one trip in week #{wk_yr[0]} year #{wk_yr[1]}"
        Trip.for_week_year(*wk_yr).count.should == 1
      end
    end
  end

  context "on_date method" do
    before(:each) do
      Factory(:trip, :date => Date.today - 1.day, :notes => 'incorrect')
      @ans = Factory(:trip, :date => Date.today, :notes => 'correct')
      Factory(:trip, :date => Date.today + 1.day, :notes => 'incorrect')
    end
    it "should return all trips on date" do
      Trip.on_date(Date.today).should == [@ans]
    end
    it "should return an empty array for dates with no trips" do
      Trip.on_date(Date.today + 2.days).should == []
    end
  end

  context "destinations_for method" do
    before(:each) do
      @today = Date.today
      @tomorrow = @today + 1.day
      @yesterday = @today - 1.day
      Factory(:trip, :date => @today, :destination => "todays destination" )
      Factory(:trip, :date => @tomorrow, :destination => "destination two" )
      Factory(:trip, :date => @tomorrow, :destination => "destination three" )
    end
    it "should return the destinations for all trips on a date (1 trip for today)" do
      Trip.destinations_for(@today).should == ['todays destination']
    end
    it "should return the destinations for all trips on a date (2 trips for tomorrow)" do
      Trip.destinations_for(@tomorrow).should include('destination two')
      Trip.destinations_for(@tomorrow).should include('destination three')
    end
    it "should only return unique destinations (no duplicates)" do
      Factory(:trip, :date => @tomorrow, :destination => "destination two" ) #dup destination
      Trip.destinations_for(@tomorrow).should have_exactly(2).items
    end
    it "should return an empty array for dates with no trips" do
      Trip.destinations_for(@tomorrow + 3.days).should == []
    end
  end
end
