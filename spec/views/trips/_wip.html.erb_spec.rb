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

  describe "WIP table" do
    it "should have a table of days of the week" do
      render
      response.should have_selector('table', :id => 'wip') do |wip|
        wip.should have_selector('tr:nth-child(1)') do |header|
          (1..7).each do |i|
            header.should contain(@days[i - 1])
          end
        end
      end
    end
  
    it "should have a subheader for each vehicle under each day" do
      assigns[:vehicles] = @vehicles
      render
      response.should have_selector('table', :id => 'wip') do |wip|
        wip.should have_selector('tr:nth-child(2)') do |secondRow|
          @vehicles.each do |v|
            secondRow.should have_selector('th', :content => v)
          end
        end
      end
    end

    it "should show hours along left side" do
      hours = ["1:AM", "2:AM", "3:AM", "4:AM", "5:AM", "6:AM", "7:AM", "8:AM", "9:AM", "10:AM", "11:AM", "12:PM",
        "1:PM", "2:PM", "3:PM", "4:PM", "5:PM", "6:PM", "7:PM", "8:PM", "9:PM", "10:PM", "11:PM", "12:AM"]
      render
      response.should have_selector('table', :id=>'wip') do |wip|
        (1..24).each do |row_num|
          wip.should have_selector("tr:nth-child(#{row_num})") do |row|
            row.should have_selector('td:nth-child(1)') do |first_cell|
              first_cell.should contain(hours[row_num - 1])
            end
          end
        end
      end
    end

    it "should divide each day into a grid one column for each vehicle" do
      pending()
      assigns[:vehicles] = @vehicles
      render
      response.should have_selector('table', :id => 'wip') do |wip|
        wip.should have_selector('tr:nth-child(2)') do |secondRow|
          @vehicles.each do |v|
            secondRow.should have_selector('td', :contents => v)
          end
        end
      end
    end
  end
  
  it "should display a vehicles legend" do
    assigns[:vehicles] = @vehicles
    render
    for vehicle in @vehicles
      response.should contain(vehicle)
    end
  end
  
  it "should have a title 'WIP for date' " do
    y, m, d = Date.parse(@start_date).strftime("%Y %B %d").split
    render
    response.should contain( "WIP for week beginning Sunday #{m} #{d.to_i.ordinalize} #{y}")
  end

  it "should start on the Sunday of the current week" do

  end
  
end