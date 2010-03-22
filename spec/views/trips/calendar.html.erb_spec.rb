require 'spec_helper'

describe "trips/calendar.html.erb" do
before(:each) do
    assigns[:start_date] = Date.today.strftime("%Y%m") + "01"
    @trip = Factory.create(:trip)
    trips_by_date = Hash.new([])
    trips_by_date[Date.today.strftime("%Y%m%d")] = [@trip]
    assigns[:trips_by_date] = trips_by_date
    Factory(:destination, :place=>'Rutledge', :letter=>'R')
    @destinations = {"Rutledge(2)" => 'R', "Memphis(4)" => 'M', "La Plata(3)" => 'P',
      "Quincy(1)" => 'Q'}
    assigns[:destination_list] = @destinations
    assigns[:start_date] = Date.today.strftime("%Y%m%d")
  end

   it "should render the navbar template" do
    template.should_receive(:render).with( :partial => "navbar",
      :locals => {:start_date => Date.today.strftime("%Y%m%d")})
    render 
  end
  
  it "should render the calendar template" do
    template.should_receive(:render).with( :partial => "three_calendars")
    render
  end

   it "should render the destination_list template" do
    template.should_receive(:render).with( :partial => "destination_list")
    render
  end

   it "should render the trip_list template" do
    template.should_receive(:render).with( :partial => "trip_list")
    render
  end

end
