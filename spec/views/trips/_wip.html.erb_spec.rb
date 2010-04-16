require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper' )

describe "trips/_wip.html.erb" do
  before(:each) do
    
  end

  it "should display a list of vehicles" do
    vehicles = (1..7).collect {|i| "car#{i}"}
    assigns[:vehicles] = vehicles
    render
    for vehicle in vehicles
      response.should contain vehicle
    end
  end
  
end