require 'spec_helper'

describe "trips/calendar.html.erb" do
  before(:each) do
    assigns[:start_date] = Date.today.strftime("%Y%m") + "01"
    @trip = Factory.create(:trip)
    assigns[:trips_by_date] = [[@trip]]
    @destinations = ["Rutledge(2)", "Memphis(4)", "La Plata(3)", "Quincy(1)"]
    assigns[:destination_list] = @destinations
  end
  it "displays the header" do
    render
    response.should contain("Rutledge Travel Calendar Version 5")
  end
  it "should display the current month and following 2 months" do
    render
    for month in Date::MONTHNAMES[Date.today.month, 3]
      response.should contain(month)
    end
  end
  it "should display destinations in destination-list table" do
    render
    response.should have_selector('table', :id => "destination-list" ) do |table|
      @destinations.each do |dest|
        table.should have_selector('tr td', :content => dest)
      end
    end
  end
  it "should display number of trips to a destination next to the destination" do
    pending
    render
    response.should have_selector('table', :id => "destination-list" ) do |table|
      table.should have_selector('tr td')
    end
  end
  it "first row of trip-list table should display column headers" do
    render
    response.should have_selector('table', :id => 'trip-list') do |table|
      table.should have_selector('tr:nth-child(1)') do |tr|
        ['Date', 'Time', 'Destination', 'Contact', 'Community', 'Preferred Vehicle',
        'Travelers', 'Notes', 'Actions'].each do |header|
          tr.should contain(header)
        end
      end
    end
  end
  it "should display the details of a pending trip" do
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
  it "should have the date cell span all the rows with the same date" do
    tbd = [[]]
    3.times { tbd[0] << Factory.create(:trip, :date => Date.today)}
    assigns[:trips_by_date] = tbd
    render
    response.should have_selector("table", :id => "trip-list") do |table|
      table.should have_selector("tr:nth-child(2)") do |row|
        row.should have_selector("td",  :rowspan => "3")
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
    it "should not display trips older than today in the calendar" do
      render
      response.should have_selector("table", :id => "three-calendars" ) do |table|
        table.should have_selector("table", :class => "calendar" ) do |table2|
          table2.should have_selector("td", :class => 'day-past') do |td|
            td.should contain(@yesterday.day.to_s)
          end
        end
      end
    end
  end
  it "should display trips in order by date then time" do
    pending
  end
end
