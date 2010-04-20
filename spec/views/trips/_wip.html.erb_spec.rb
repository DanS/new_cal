require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper' )

describe "trips/_wip.html.erb" do
  before(:each) do
    @vehicles = (1..7).collect {|i| "car#{i}"}
    assigns[:vehicles] = @vehicles
    @days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu',  'Fri', 'Sat']
    assigns[:days] = @days
    @start_date = (Date.today - Date.today.wday.days).strftime("%Y%m%d")
    assigns[:start_date] = @start_date
  end

  it "should have a table of days of the week" do
    render
    response.should have_selector('table', :id => 'wip') do |wip|
      wip.should have_selector('tr:nth-child(1)') do |header|
        (1..7).each do |i|
          header.should contain @days[i - 1]
        end
      end
    end
  end
  
  it "should divide each day into a grid one column for each vehicle, one row for each hour" do
    pending
    @vehicles = (1..7).collect {|i| "car#{i}"}
  end
  
  it "should display a vehicles legend" do
    assigns[:vehicles] = @vehicles
    render
    for vehicle in @vehicles
      response.should contain vehicle
    end
  end
  
  it "should have a title 'WIP for date' " do
    y, m, d = Date.parse(@start_date).strftime("%Y %B %d").split
    render
    response.should contain "WIP for week beginning Sunday #{m} #{d.to_i.ordinalize} #{y}"
  end

  it "should start on the Sunday of the current week" do

  end
  
end