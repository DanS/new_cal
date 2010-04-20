require 'spec_helper' 

describe Vehicle do
  describe "find method (overwritten)" do
    it "should return vehicles in alpha order with 'needs_assignment' first and non-DR vehicles last" do
      Factory(:vehicle, :name=>'DR_a', :not_dr_vehicle => '0' )
      Factory(:vehicle, :name => "DR_b")
      Factory(:vehicle, :name => "either Jetta", :needs_assignment => '0' )
      Factory(:vehicle, :name => "Any", :needs_assignment => '0' )
      Factory(:vehicle, :name => "Sandhill", :not_dr_vehicle => '0')
      Factory(:vehicle, :name => "Other", :not_dr_vehicle => '0')
      Vehicle.ordered.collect {|v| v.name}.should ==
        ['Any', 'either Jetta', 'DR_a', 'DR_b', 'Other', 'Sandhill']
    end
  end
end