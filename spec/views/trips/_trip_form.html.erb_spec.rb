require 'spec_helper'

describe "trips/_trip_form.html.erb" do
  before(:each) do
    @trip = Factory.build(:trip)
    assigns[:trip] = @trip
    @communities = ['Dancing Rabbit', 'foo', 'Sandhill'].each {|c| Factory(:community, :name => c)}
    assigns[:communities] = @communities
    @vehicles = ['Truck', 'Black Jetta', 'Silver Jetta', 'Any', 'Sandhill', 'SSVC', 'Either Jetta']
    assigns[:vehicles] = @vehicles
    render :locals => {:communities => @communities,
          :vehicles => @vehicles, :trip => @trip }
  end

  context "date selection" do
    it "should have a selector for year" do
      response.should have_selector('select', :name => "trip[date(1i)]") do |year|
        year.should have_selector('option', :value => (Date.today.year).to_s, :selected => 'selected' )
        year.should have_selector('option', :value => (Date.today.year + 1).to_s )
      end
    end
    it "should have a selector for month" do
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
      response.should have_selector('select', :name => "trip[date(3i)]") do |selector|
        (1..28).each do |day|
          selector.should have_selector('option', :value => day.to_s, :content => day.to_s  )
        end
      end
    end
  end
  context "time fields" do
    it "should have a selector for departure time" do
      response.should have_selector('select', :name => "trip[depart]") do |select|
        for time in ['Unknown', '03:30PM', 'Midnight', '11:00AM']
          select.should have_selector('option', :value => time, :content => time )
        end
      end
    end
    it "should have a selector for return time" do
      response.should have_selector('select', :name => 'trip[return]') do |select|
        for time in ['Unknown', '01:00AM', 'Noon', '02:30PM']
          select.should have_selector('option', :value => time, :content => time)
        end
      end
    end
  end

    context "plain text fields" do
      it "should have a text field for destination" do
        response.should have_selector('input', :type => "text", :name=>'trip[destination]')
      end
      it "should have a text field for contact" do
        response.should have_selector('input', :type => "text", :name => "trip[contact]" )
      end
      it "should have a textarea for notes" do
        response.should have_selector('textarea', :name => "trip[notes]" )
      end
    end
    
    it "should have buttons for community" do  
      @communities.each do |cmty|
        response.should have_selector('input', :type => "radio", :value => cmty )
      end
    end

    it "should have buttons for vehicles" do
      @vehicles.each do |vehicle|
        response.should have_selector('input', :type => "radio", :value => vehicle )
      end
    end
    
  end
