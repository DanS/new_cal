require 'spec_helper'

describe "trips/wip.html.erb" do
  before(:each) do
    @vehicles = (1..7).collect { |i| "car#{i}" }
    assigns[:vehicles] = @vehicles
    @start_date = (Date.today - Date.today.wday.days).strftime("%Y%m%d")
    assigns[:start_date] = @start_date
    @days = (0..6).collect { |i| Date.parse(@start_date) + i.days }
    assigns[:days] = @days
    @trips_by_hour = mock('trips_by_hour_mock')
    @trips_by_hour.stub("has_hour?").and_return("class=\"car1-trip\"")
    assigns[:trips_by_hour] = @trips_by_hour
  end

  describe "WIP table" do

    it "should render the navbar template" do
      template.should_receive(:render).with(:partial => "navbar",
                                            :locals => {:start_date => @start_date, :cal_type => 'wip'})
      render
    end

    it "should have two header rows with days of the week and dates" do
      render
      response.should have_selector("tr", :id => 'wip-header', :count => 2) do |header|
        week_start = Date.today - Date.today.wday.days
        week_days = (0..6).collect { |n| week_start + n.days }
        week_days.each do |day|
          formatted_date = day.strftime("%b %d")
          header.should have_tag('span', :text=>formatted_date)
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
      hours = ["12:00AM", "12:30AM", "1:00AM", "1:30AM", "2:00AM", "2:30AM", "3:00AM", "3:30AM",
               "4:00AM", "4:30AM", "5:00AM", "5:30AM", "6:00AM", "6:30AM", "7:00AM", "7:30AM", "8:00AM",
               "8:30AM", "9:00AM", "9:30AM", "10:00AM", "10:30AM", "11:00AM", "11:30AM", "12:00PM",
               "12:30PM", "1:00PM", "1:30PM", "2:00PM", "2:30PM", "3:00PM", "3:30PM", "4:00PM", "4:30PM",
               "5:00PM", "5:30PM", "6:00PM", "6:30PM", "7:00PM", "7:30PM", "8:00PM", "8:30PM", "9:00PM",
               "9:30PM", "10:00PM", "10:30PM", "11:00PM", "11:30PM"]
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
            secondRow.should have_selector("th.vehicle-header", :content => v, :count => 14)
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
        twelvethRow.should have_selector('td', :id => today + "-10-car1", :class=>"car1-trip")
      end
    end
  end

  it "should have a title 'WIP for date' " do
    y, m, d = Date.parse(@start_date).strftime("%Y %B %d").split
    render
    response.should contain("Vehicle use for week beginning Sunday #{m} #{d.to_i.ordinalize} #{y}")
  end

end
