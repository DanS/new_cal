require 'spec_helper'

describe "trips/_trip_list.html.erb" do
  before(:each) do
    assigns[:start_date] = Date.today.strftime("%Y%m") + "01"
    @trip = Factory.create(:trip)
    assigns[:trips_by_date] = {Date.today.strftime("%Y%m%d") => [@trip]}
    @destinations = {"Rutledge(2)" => 'R', "Memphis(4)" => 'M', "La Plata(3)" => 'P',
      "Quincy(1)" => 'Q'}
    assigns[:destination_list] = @destinations
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
      assigns[:trips_by_date] = Trip.by_date_string(params)
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
  end

  it "should accept trips that do not have a return time" do
    trip  = Factory(:trip, :return => nil, :notes => 'No return time for this trip')
    assigns[:trips_by_date] = {Date.today.strftime("%Y%m%d") => [trip]}
    render
    response.should have_selector("table", :id => "trip-list" ) do |table|
      table.should contain('No return time for this trip')
    end
  end
end
