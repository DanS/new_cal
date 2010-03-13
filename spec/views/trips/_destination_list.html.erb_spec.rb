require 'spec_helper'

describe "trips/_destination_list.html.erb" do
  before(:each) do
    @destinations = {'Quincy' =>  [1, 'Q'], 'Rutledge' => [2, 'R'], 'La Plata' => [3, 'P'], 'Kirksville' => [4, 'K'],
        'Memphis' => [1, 'M'], 'Fairfield' => [1, 'F']}
    assigns[:destination_list] = @destinations
  end
  
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
        @destinations.each_pair do |place, values|
          table.should have_selector('tr td', :class => values[1])
        end
      end
    end
    it "should display destinations in alphabetical order as links" do
      names_only = @destinations.keys.map {|d| d.gsub(/\(\d*\)/, '').gsub(' ', '_')}
      render
      response.should have_selector('table', :id => "destination-list" ) do |table|
        names_only.sort.each_with_index do |dest, i|
          table.should have_selector("tr:nth-child(#{i + 2})") do |row|
            row.should have_selector("a", :href => "/?destination=#{dest}"  )
          end
        end
      end
    end

end
