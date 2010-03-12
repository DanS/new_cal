require 'spec_helper'

describe "trips/_destination_list.html.erb" do
  before(:each) do
    @destinations = {"Rutledge(2)" => 'R', "Memphis(4)" => 'M', "La Plata(3)" => 'P',
      "Quincy(1)" => 'Q'}
    assigns[:destination_list] = @destinations
  end
  
  context "destination list partial" do
    it "should display destinations in destination-list table in alphabetical order" do
      render
      response.should have_selector('table', :id => "destination-list" ) do |table|
        @destinations.keys.sort.each_with_index do |dest, i|
          table.should have_selector("tr:nth-child(#{i + 2})") do |row|
            row.should have_selector("td", :content => dest)
          end
        end
      end
    end
    it "should have color styles for destination in the destination list" do
      render
      response.should have_selector('table', :id => "destination-list" ) do |table|
        @destinations.each_pair do |place, style_letter|
          table.should have_selector('tr td', :class => style_letter, :content => place)
        end
      end
    end
  end

end
