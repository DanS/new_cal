require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper' )

describe "trips/_week.html.erb" do
  before(:each) do
    @trips_by_date = Hash.new([])
    start_date = Date.parse('20100328')
    num = 0
    @times =  ['8AM', '3:30PM', '9:45PM'].collect {|t| Time.parse(t)}
    (0..6).each do |wday|
      key = (start_date + wday.days).strftime("%Y%m%d")
      trips = @times.collect do |time|
        num += 1
        Factory(:trip, :depart => time, :notes => "trip number #{num}")
      end
      @trips_by_date[key] = trips
    end
    @destinations = ['Rutledge', 'Quincy', 'Kirksville']
    @destinations.each {|d| Factory(:destination, :place => d, :letter => d.first)}
    assigns[:trips_by_date] = @trips_by_date
    assigns[:destination_list] = {}
  end
  it "should list the days of the week" do
    render
    Date::ABBR_DAYNAMES.each do |day|
      response.should contain(day)
    end
  end
  it "should have the destination list after the seventh day" do
    render
    response.should have_selector('table', :id=>'week_calendar') do |table|
      table.should have_selector("td:nth-child(8)") do |dest_list|
        dest_list.should have_selector('table', :id =>'destination-list')
      end
    end
  end
  it "should list the month name, day numbers and year" do
    render
    @trips_by_date.keys.each do |date|
      response.should contain Date.parse(date).strftime("%a %d %b%Y")
    end
  end
  it "should list trips for each day sorted by departure time" do
    render
    response.should have_selector('table', :id=>'week_calendar') do |table|
      (1..7).each do |weekday|
        table.should have_selector("td:nth-child(#{weekday})") do |day_cell|
          (2..4).each do |row_count|
            contents = 'Rutledge ' + @times[row_count - 2].strftime("%I:%M%p")
            day_cell.should have_selector("tr:nth-child(#{row_count})") do |tr|
              tr.should contain(contents)
            end
          end
        end
      end
    end
  end
  it "should trips have a class to color them according to destination" do
    @trips_by_date.each do |day, trips|
      trips.each do |trip|
        dest = @destinations[@times.index(trip.depart)]
        trip.update_attribute(:destination, dest)
      end
    end
    assigns[:trips_by_date] = @trips_by_date
    render
    response.should have_selector('table', :id=>'week_calendar') do |table|
      (1..7).each do |weekday|
        table.should have_selector("td:nth-child(#{weekday})") do |day_cell|
          (2..4).each do |row_count|
            xclass = ['R', 'Q', 'K'][row_count - 2]
            day_cell.should have_selector("tr:nth-child(#{row_count})", :class => xclass)
          end
        end
      end
    end
  end
end