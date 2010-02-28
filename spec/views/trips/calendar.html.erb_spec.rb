require 'spec_helper'

describe "trips/calendar.html.erb" do
  before(:each) do
    assigns[:start_date] = Date.today.strftime("%Y%m") + "01"
    @trip = Factory.create(:trip)
    assigns[:trips_by_date] = {Date.today.strftime("%Y%m%d") => [@trip]}
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
      response.should have_selector("div", :id => "three-calendars" ) do |div|
        div.should have_selector("table", :class => "calendar" ) do |table2|
          table2.should have_selector("td", :class => 'day past') do |td|
            td.should contain(@yesterday.day.to_s)
          end
        end
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
  context "calendar days should be assigned class based on date and destinations" do
    it "should give days in the past a class of past" do
      day_count = days_in_month(Date.today.month, Date.today.year)
      render
      response.should have_selector('div', :id => 'three-calendars') do |three_cal|
        three_cal.should have_selector('table:nth-child(1)', :class => "calendar" ) do |month_cal|
          today = Date.today
          (1..day_count).each do |day_number|
             day_class = day_class_for(Date.parse("#{today.year}-#{today.month}-#{day_number}"))
             month_cal.should have_selector('td', :class => day_class, :content => day_number.to_s)
          end
        end
      end
    end
  end
end
