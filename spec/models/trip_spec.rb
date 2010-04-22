require 'spec_helper'
def d2str(date)
  date.strftime("%Y%m%d")
end
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
      :return => Time.parse('12:30PM'),
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

  context "Link trips to destination thru a virtural attribute" do
    before(:each) do
      %w(two four six Other).each {|p| Factory(:destination, :place => p, :letter => p[0,1])}
    end

    it "should have a virtual attribute destination_id" do
      trip = Factory(:trip, :destination => 'two')
      trip.destination_id.should == Destination.find_by_place('two').id
      trip = Factory(:trip, :destination => 'four')
      trip.destination_id.should == Destination.find_by_place('four').id
      trip = Factory(:trip, :destination => 'eight')
      trip.destination_id.should == Destination.find_by_place('Other').id
    end

    it "should return the letter for its destination" do
      Factory(:trip, :destination => 'two').letter.should == 't'
      Factory(:trip, :destination => 'non-standard').letter.should == 'O'
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

  context "to_destination method" do
    before(:each) do
      @test_dests = ["Rutledge", "Memphis", "Fairfield", "Quincy", "Kirksville"]
      @test_dests.each  do |d|
        Factory(:trip, :destination => d, :date => Date.today + 1.day)
      end
    end

    it "should return only trips going to the given destination" do
      for test_dest in @test_dests do
        trip_results = Trip.to_destination(test_dest).collect {|t| t.destination}
        trip_results.should include(test_dest)
        for other_dest in @test_dests.reject {|d| d == test_dest}
          trip_results.should_not include(other_dest)
        end
      end
    end
    it "should return all trips if no destination given" do
      Trip.to_destination().size.should == 5
    end
  end

  context "destination_list method" do
    it "should list number of trips to each destination in upcoming trips" do
      destinations = {'Quincy' =>  [1, 'Q'], 'Rutledge' => [2, 'R'], 'La Plata' => [3, 'P'], 'Kirksville' => [4, 'K'],
        'Memphis' => [1, 'M'], 'Fairfield' => [1, 'F']}
      destinations.each_pair do |dest, values|
        letter = values[1]
        count = values[0]
        count.times {Factory(:trip, :destination => dest)}
        Factory(:destination, :place =>dest, :letter => letter)
      end
      destination_list = Trip.list_destinations
      destination_list.keys.sort.should == destinations.keys.sort
    end
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
      @params = {}
    end
    it "should have 3 date keys" do
      Trip.by_date_string(@params).keys.length.should == 3
    end
    it "should have 1 trip in the lowest date" do
      Trip.by_date_string(@params)[@date_strings[0]].length.should == 1
    end
    it "should have 3 trips in the highest date" do
      Trip.by_date_string(@params)[@date_strings[2]].length.should == 3
    end
    it "should only contain trip objects as values" do
      Trip.by_date_string(@params).values.flatten.all? {|t| t.class == Trip}.should == true
    end
    it "should return an empty array for a date with no trips" do
      tbd = Trip.by_date_string(@params)
      tbd['22000101'].should == []
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

  context "destinations_for_date method" do
    before(:each) do
      @today = Date.today
      @tomorrow = @today + 1.day
      @yesterday = @today - 1.day
      Factory(:trip, :date => @today, :destination => "todays destination" )
      Factory(:trip, :date => @tomorrow, :destination => "destination two" )
      Factory(:trip, :date => @tomorrow, :destination => "destination three" )
    end
    it "should return the destinations for all trips on a date (1 trip for today)" do
      Trip.destinations_for_date(@today).should == ['todays destination']
    end
    it "should return the destinations for all trips on a date (2 trips for tomorrow)" do
      Trip.destinations_for_date(@tomorrow).should include('destination two')
      Trip.destinations_for_date(@tomorrow).should include('destination three')
    end
    it "should only return unique destinations (no duplicates)" do
      Factory(:trip, :date => @tomorrow, :destination => "destination two" ) #dup destination
      Trip.destinations_for_date(@tomorrow).should have_exactly(2).items
    end
    it "should return an empty array for dates with no trips" do
      Trip.destinations_for_date(@tomorrow + 3.days).should == []
    end
  end

  context "between_dates named scope" do
    before(:each) do
      (1..12).each {|n| Factory(:trip, :date => Date.today + n.months)}
    end
    it  "should return all trips if no dates given" do
      Trip.between_dates().should have_exactly(Trip.all.size).Trip
    end
    it "should return no trips if no trips in date range" do
      Trip.between_dates(Date.today + 2.years, Date.today + 3.years)
    end
    it "should only return trip between dates given" do
      trip_dates = Trip.find(:all).collect {|t| t.date}.sort
      result = Trip.between_dates(Date.today + 2.months, Date.today + 4.months)
      result.should have_exactly(3).Trips
      result.collect {|t| t.date}.sort.should == trip_dates[1,3]
    end
    it "should return trips on boundary dates" do
      result = Trip.between_dates(Date.today + 1.month, Date.today + 1.month)
      result.should have_exactly(1).Trips
    end
  end

  context "filtered trips method" do
    it "should only return trips to 'destination' if destination in params" do
      trip_destinations =  ["Rutledge", "Memphis", "Fairfield", "Quincy", "Kirksville"]
      trip_destinations.each  do |d|
        Factory(:trip, :destination => d, :date => Date.today + 1.day)
      end
      trip_results = Trip.filtered(:destination => 'Rutledge')
      trip_results.should have_exactly(1).Trip
      trip_results[0].destination.should == 'Rutledge'
    end
    it "should only return trips in date range if start_date and end_date are in the params" do
      today = Date.today
      (1..5).each do |i|
        Factory(:trip, :date => today + i.weeks , :notes => "#{i} trip")
      end
      result = Trip.filtered(:start_date => today + 2.weeks, :end_date => today + 4.weeks + 6.days)
      result.should have_exactly(3).Trip
      result_notes = result.collect {|t| t.notes}
      result_notes.should include('2 trip')
      result_notes.should include('3 trip')
      result_notes.should include('4 trip')
    end
    it "should filter by both date and destination if both are present" do
      today = Date.today
      trip_params =  [["Rutledge", today + 1.day], ["Memphis", today + 2.day], ["Memphis", today + 3.day],
        ["Kirksville", today + 3.day], ["Kirksville", today + 3.day]]
      trip_params.each  do |dest, date|
        Factory(:trip, :destination => dest, :date => date)
      end
      result = Trip.filtered(:destination => 'Kirksville', :start_date => today + 3.day, :end_date => today + 5.weeks)
      result.should have_exactly(2).Trip
      result = Trip.filtered(:destination => 'Memphis', :start_date => today + 3.day, :end_date => today + 5.weeks)
      result.should have_exactly(1).Trip
      result = Trip.filtered(:destination => 'Memphis', :start_date => today + 2.day, :end_date => today + 3.days)
      result.should have_exactly(2).Trip
    end
  end

  describe "to_dashed_date_string helper method" do
    it "should return nil when given a nil" do
      Trip.to_dashed_date_string(nil).should == nil
    end
    it "should return a dashed string when given an undashed string" do
      Trip.to_dashed_date_string('20100421').should == '2010-04-21'
    end
    it "should return a dashed date string when given a date object" do
      Trip.to_dashed_date_string(Date.parse('2010-04-21')).should == '2010-04-21'
    end
  end
end
