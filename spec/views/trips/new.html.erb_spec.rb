require 'spec_helper'

describe "trips/new.html.erb" do
  before(:each) do
    assigns[:trip] = Factory.build(:trip)
  end

  context "date selection" do
    it "should have a selector for year" do
      render
      response.should have_selector('select', :name => "trip[date(1i)]") do |year|
        year.should have_selector('option', :value => (Date.today.year).to_s, :selected => 'selected' )
        year.should have_selector('option', :value => (Date.today.year + 1).to_s )
      end
    end
    it "should have a selector for month" do
      render
      response.should have_selector('select', :name => "trip[date(2i)]") do |month|
        Date::MONTHNAMES[1,12].each_with_index do |name, i|
          unless i + 1 == Date.today.month
            month.should have_selector('option', :value => (i + 1).to_s, :content => name )
          else
            month.should have_selector('option', :value => (i + 1).to_s, :content => name,
              :selected => "selected")
          end
        end
      end
    end
    it "should have a selector for day of month" do
      render
      response.should have_selector('select', :name => "trip[date(3i)]") do |selector|
        (1..28).each do |day|
          selector.should have_selector('option', :value => day.to_s, :content => day.to_s  )
        end
      end
    end
  end
  context "time fields" do
    it "should have a selector for departure time" do
      render
      response.should have_selector('select', :name => "trip[depart]") do |select|
        for time in ['Unknown', '03:30PM', 'Midnight', '11:00AM']
          select.should have_selector('option', :value => time, :content => time )
        end
      end
    end
    it "should have a selector for return time" do
      render
      response.should have_selector('select', :name => 'trip[return]') do |select|
        for time in ['Unknown', '01:00AM', 'Noon', '02:30PM']
          select.should have_selector('option', :value => time, :content => time)
        end
      end
    end
  end

    context "plain text fields" do
      it "should have a text field for destination" do
        render
        response.should have_selector('input', :type => "text", :name=>'trip[destination]')
      end
      it "should have a text field for contact" do
        render
        response.should have_selector('input', :type => "text", :name => "trip[contact]" )
      end
      it "should have a textarea for notes" do
        render
        response.should have_selector('textarea', :name => "trip[notes]" )
      end
    end
    
    it "should have buttons for community" do
      render
      ['Dancing Rabbit', 'Red Earth Farms', 'Sandhill'].each do |cmty|
        response.should have_selector('input', :type => "radio", :value => cmty )
      end
    end
  end
