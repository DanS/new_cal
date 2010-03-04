require 'spec_helper'

describe Destination do
  before(:each) do
     @valid_attributes = {
       :place => "Rutledge",
       :letter => 'R'
     }
   end

   it "should create a new instance given valid attributes" do
     Destination.create!(@valid_attributes)
   end

   it "should not be valid without all required attributes" do
     [:place, :letter].each do |attrib|
       @valid_attributes[attrib] = nil
       dest = Destination.create(@valid_attributes)
       dest.should_not be_valid
     end
   end
end