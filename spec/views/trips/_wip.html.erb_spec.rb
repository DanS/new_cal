require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper' )

describe "trips/_wip.html.erb" do
  before(:each) do
    @vehicles = (1..7).collect {|i| "car#{i}"}
    assigns[:vehicles] = @vehicles
    assigns[:days] = @days
  end

  it "should have a table of days of the week" do
    days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu',  'Fri', 'Sat']
    render
    response.should have_selector('table', :id => 'wip') do |wip|
      wip.should have_selector('tr:nth-child(1)') do |header|
        (1..7).each do |i|
          header.should contain days[i - 1] 
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
  
end