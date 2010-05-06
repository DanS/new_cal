require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper' )

describe "trips/wip.html.erb" do
  before(:each) do
    @vehicles = (1..7).collect {|i| "car#{i}"}
    assigns[:vehicles] = @vehicles
    @start_date = (Date.today - Date.today.wday.days).strftime("%Y%m%d")
    assigns[:start_date] = @start_date
    @days = (0..6).collect {|i| Date.parse(@start_date) + i.days}
    assigns[:days] = @days
    @trips_by_hour = mock('trips_by_hour_mock')
    @trips_by_hour.stub("has_hour?").and_return("car1-trip")
    assigns[:trips_by_hour] = @trips_by_hour
  end

  describe "WIP table" do
    it "should have a table of days of the week with dates" do
      render
      response.should have_selector('table', :id => 'wip') do |wip|
        wip.should have_selector('tr:nth-child(1)') do |header|
          (1..7).each do |i|
            header.should contain(@days[i - 1].strftime(
                "%b %d %a %Y"))
          end
        end
      end
    end
  
    it "should have a subheader for each vehicle under each day" do
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
      render
      response.should have_selector('table', :id => 'wip') do |wip|
        wip.should have_selector('tr:nth-child(2)') do |secondRow|
          @vehicles.each do |v|
            secondRow.should have_selector('th', :content => v, :count => 7)
          end
        end
      end
    end
  end

  it "should add a class to color hours with trips planned" do
    today = @start_date
    render
    response.should have_selector('table', :id => 'wip') do |wip|
      wip.should have_selector('tr:nth-child(10)') do |twelvethRow|
          twelvethRow.should have_selector('td', :id => today + "-10-car1", :class=>'car1-trip')
        end
    end
  end

  it "should have a title 'WIP for date' " do
    y, m, d = Date.parse(@start_date).strftime("%Y %B %d").split
    render
    response.should contain( "WIP for week beginning Sunday #{m} #{d.to_i.ordinalize} #{y}")
  end
  
end
