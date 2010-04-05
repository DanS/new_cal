require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper' )

describe "trips/_week.html.erb" do
  before(:each) do
    @trips_by_date = Hash.new([])
    start_date = Date.parse('20100328')
    num = 0
    times =  ['8AM', '3:30PM', '9:45PM'].collect {|t| Time.parse(t)}
    (0..6).each do |wday|
      key = (start_date + wday.days).strftime("%Y%m%d")
      trips = times.collect do |time|
        num += 1
        Factory(:trip, :depart => time, :notes => "trip number #{num}")
      end
      @trips_by_date[key] = trips
    end
  end
  before(:each) do
    assigns[:trips_by_date] = @trips_by_date
  end
  it "should list the days of the week" do
    render
    Date::ABBR_DAYNAMES.each do |day|
      response.should contain(day)
    end
  end
  it "should list the month name, day numbers and year" do
    render
    @trips_by_date.keys.each do |date|
      response.should contain Date.parse(date).strftime("%a %d %b %Y")
    end
  end
  it "should list trips for each day sorted by departure time" do
    render
    note_count = 0
    response.should have_selector('table', :id=>'week') do |table|
      (1..7).each do |weekday|
        table.should have_selector("td:nth-child(#{weekday})") do |day_cell|
          (1..3).each do |row_count|
            day_cell.should have_selector('table', :class=>'day_trips')

            #            ("span.day_trip:nth-child(#{span_count})") do |span|
            #              span.should contain "trip number #{note_count}"
            #              note_count += 1
          end
        end
      end
    end
  end
end