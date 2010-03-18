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
    it "should not display trips older than today in the calendar" do unless Date.today.mday == 1
        #don't run on the first of the month because yesterday won't show up on the calendar
        Trip.delete_all
        test_date = Date.today - 1.day
        Factory(:trip, :date => test_date)
        yesterdays_class = day_class_for(test_date)
        render
        response.should have_selector('div', :id => 'three-calendars') do |three_cal|
          three_cal.should have_selector('table:nth-child(1)', :class => "calendar" ) do |month_cal|
            three_cal.should have_selector("td", :class => yesterdays_class, :content => test_date.mday.to_s )
          end
        end
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
    context "only current and future calendar days should have a link to create a new trip on that date" do
      it "should contain links to create a new trip on that date on current and future dates" do
        #pending()
        months_to_check = next_3_months_years(Date.today.strftime("%Y%m%d"))
        render
        response.should have_selector('div', :id => 'three-calendars') do |three_cal|
          (1..3).each do |current_month|
            three_cal.should have_selector("table:nth-child(#{current_month})", :class => "calendar" ) do |month_cal|
              today = Date.today
              start_day = current_month == 1 ? today.mday : 1
              days = days_in_month(*months_to_check[current_month - 1])
              (start_day..days).each do |day_num|
                day_class = day_class_for(Date.parse("#{today.year}-#{today.month}-#{day_num}"))
                month_cal.should have_selector('td', :id => "day_cell#{day_num}") do |day|
                  current_date = sprintf("%d%02d%02d",
                    *months_to_check[current_month - 1].reverse + [day_num])
                  day.should have_selector("a", :href => "/trips/new?date=#{current_date}",
                    :content => day_num.to_s)
                end
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
      it "should filter destination colors displayed when a destination filter is active" do
        pending()
        dest = Destination.create(:place => 'Rutledge', :letter => 'R', :color => '#FFC')
        Destination.create(:place => 'Quincy', :letter => 'Q', :color => '#FCC')
        Factory(:trip, :destination => 'Quincy')
        assigns[:params] = {:destination => 'Rutledge'}
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

  
end
