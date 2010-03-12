require 'spec_helper'

describe "trips/calendar.html.erb" do
  before(:each) do
    assigns[:start_date] = Date.today.strftime("%Y%m") + "01"
    @trip = Factory.create(:trip)
    assigns[:trips_by_date] = {Date.today.strftime("%Y%m%d") => [@trip]}
    @destinations = {"Rutledge(2)" => 'R', "Memphis(4)" => 'M', "La Plata(3)" => 'P',
      "Quincy(1)" => 'Q'}
    assigns[:destination_list] = @destinations
  end
  it "displays the header" do
    render
    response.should contain("Rutledge Travel Calendar Version 5")
  end
  
  context "calendar partial" do
    it "should display the current month and following 2 months" do
      render
      for month in Date::MONTHNAMES[Date.today.month, 3]
        response.should contain(month)
      end
    end
    context "calendar days should be assigned class based on date and destinations\n" do
      it "should give days in the past a class of past" do
        render
        response.should have_selector('div', :id => 'three-calendars') do |three_cal|
          three_cal.should have_selector('table:nth-child(1)', :class => "calendar" ) do |month_cal|
            today = Date.today
            (1..today.mday - 1).each do |day_number|
              day_class = day_class_for(Date.parse("#{today.year}-#{today.month}-#{day_number}"))
              month_cal.should have_selector('td', :class => day_class, :content => day_number.to_s)
            end
          end
        end
      end
    end
    context "only current and future calendar days all should have a link to create a new trip" do
      it "should contain a link to create a new trip" do
        render
        response.should have_selector('div', :id => 'three-calendars') do |three_cal|
          three_cal.should have_selector('table:nth-child(1)', :class => "calendar" ) do |month_cal|
            today = Date.today
            days = days_in_month(today.month, today.year)
            (today.day..days).each do |day_num|
              day_class = day_class_for(Date.parse("#{today.year}-#{today.month}-#{day_num}"))
              month_cal.should have_selector('td', :id => "day_cell#{day_num}") do |day|
                day.should have_selector('a', :href => '/trips/new')
              end
            end
          end
        end
      end
      it "should NOT contain a link to create a new trip if its in the past" do
        render
        response.should have_selector('div', :id => 'three-calendars') do |three_cal|
          three_cal.should have_selector('table:nth-child(1)', :class => "calendar" ) do |month_cal|
            today = Date.today
            days = days_in_month(today.month, today.year)
            (1..today.day-1).each do |day_num|
              day_class = day_class_for(Date.parse("#{today.year}-#{today.month}-#{day_num}"))
              month_cal.should_not have_selector('td', :id => "day_cell#{day_num}") do |day|
                day.should_not have_selector('a', :href => '/trips/new')
              end
            end
          end
        end
      end
    end

    context "calendar days should have colors representing trip designations on that day" do
      it "should have a class representing the destination of a trip on today" do
        dest = Destination.create(:place => 'Rutledge', :letter => 'R', :color => '#FFC')
        render
        response.should have_selector('div', :id => 'three-calendars') do |three_cal|
          three_cal.should have_selector('table:nth-child(1)', :class => "calendar" ) do |month_cal|
            today = Date.today
            days = days_in_month(today.month, today.year)
            day_num = today.day
            day_class = day_class_for(Date.parse("#{today.year}-#{today.month}-#{day_num}"))
            month_cal.should have_selector('td', :id => "day_cell#{day_num}", :class => day_class)
          end
        end

      end
    end
  end

  context "destination list partial" do
    it "should display destinations in destination-list table" do
      render
      response.should have_selector('table', :id => "destination-list" ) do |table|
        @destinations.keys.each do |dest|
          table.should have_selector('tr td', :content => dest)
        end
      end
    end
    it "should have color styles for destination in the destination list" do
      render
      response.should have_selector('table', :id => "destination-list" ) do |table|
        @destinations.each_pair do |place, style_letter|
          table.should have_selector('tr td', :class => style_letter, :content => place)
        end
      end
    end
  end

  context "trip list partial" do
    it "should display column headers in the first row of the trip-list table" do
      render
      response.should have_selector('table', :id => 'trip-list') do |table|
        table.should have_selector('tr:nth-child(1)') do |tr|
          ['Date', 'Time', 'Destination', 'Contact', 'Community', 'Preferred Vehicle',
            'Travelers', 'Notes', 'Actions'].each do |header|
            tr.should have_selector('th', :content => header)
          end
        end
      end
    end
    it "should display the details of an upcoming trip" do
      render
      response.should have_selector('table', :id => 'trip-list') do |table|
        todays_date_str = Date.today.strftime("%b %d %a")
        table.should have_selector('td', :content => todays_date_str)
        table.should have_selector('td', :content => "Joe")
        table.should have_selector('td', :content => "Lorium Ipsum et cetera")
        table.should have_selector('td', :content => "Truck")
        table.should have_selector('td', :content => "12:15PM")
        table.should have_selector('td', :content => "Dancing Rabbit")
        table.should have_selector('td', :content => "1")
      end
    end
    it "should style the destination cell so that it gets the destination color" do
      Destination.create :place => 'Rutledge', :letter => 'R', :color => '#CFF'
      render
      response.should have_selector('table', :id => 'trip-list') do |table|
        table.should have_selector('tr:nth-child(2)') do |second_row|
          second_row.should have_selector('td:nth-child(3)', :class => "R")
        end
      end
    end
    it "should have the date cell span all the rows with the same date" do
      tbd = {Date.today.strftime("%Y%m%d") => []}
      3.times { tbd[Date.today.strftime("%Y%m%d")] << Factory.create(:trip, :date => Date.today)}
      assigns[:trips_by_date] = tbd
      render
      response.should have_selector("table", :id => "trip-list") do |table|
        table.should have_selector("tr:nth-child(2)") do |row|
          row.should have_selector("td",  :rowspan => "3")
        end
      end
    end
    it "should display trips in order by date then time" do
      add_unordered_trips #defined in my_spec_helpers
      assigns[:trips_by_date] = Trip.by_date_string
      render
      response.should have_selector("table", :id => "trip-list" ) do |table|
        (1..9).each do |i|
          table.should have_selector("tr:nth-child(#{i + 2})") do |tr|
            tr.should have_selector('td', :content => "trip-#{i}")
          end
        end
      end
    end
  end

  context "trips older than today should not display" do
    before(:each) do
      @yesterday = Date.today - 1.day
      Factory.create(:trip, :date => @yesterday, :notes => 'yesterdays trip')
    end
    it "should not display trips older than today in the list" do
      render
      response.should_not contain('yesterdays trip')
    end
    it "should not display trips older than today in the calendar" do unless Date.today.mday == 1
        #don't run on the first of the month because yesterday won't show up on the calendar
        Trip.delete_all
        test_date = Date.today - 1.day
        Factory(:trip, :date => test_date)
        render
        response.should have_selector('div', :id => 'three-calendars') do |three_cal|
          three_cal.should have_selector('table:nth-child(1)', :class => "calendar" ) do |month_cal|
            three_cal.should have_selector("td", :class => 'day past', :content => test_date.mday.to_s )
          end
        end
      end
    end
  end

end
