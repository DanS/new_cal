require 'spec_helper'
describe TripsController do

  def mock_trip(stubs={})
    @mock_trip ||= mock_model(Trip, stubs).as_null_object
  end

  describe "GET calendar" do #replaces index action
    
    it "assigns start_date to be the first of the current month" do
      get :calendar
      assigns[:start_date].should == Date.today.strftime("%Y%m") + "01"
    end
    it "assigns destinations " do
      destinations = {'Quincy' => [1, 'Q'], 'Rutledge' => [2, 'R'], 'La Plata' => [3, 'P'], 'Kirksville' => [4, 'K'],
        'Memphis' => [1, 'M'], 'Fairfield' => [1, 'F']}
      destinations.each do |dest, value|
        value[0].times {Factory(:trip, :destination => dest)}
        Factory(:destination, :place => dest, :letter => value[1])
      end
      get :calendar
      assigns[:destination_list].keys.sort.should == destinations.keys.sort
      assigns[:destination_list].values.sort.should == destinations.values.sort
    end
    it "assigns destination_color_lookup" do
      look_hash = {"Kirksville"=>"K", "Rutledge"=>"R", "Fairfield"=>"F", "Other"=>"O",
        "Memphis"=>"M", "Ottumwa"=>"O", "Quincy"=>"Q"}
      look_hash.each_pair do |place, letter|
        Factory(:destination, :place => place, :letter => letter)
      end
      get :calendar
      assigns[:destination_color_lookup].keys.sort.should == look_hash.keys.sort
      assigns[:destination_color_lookup].values.sort.should == look_hash.values.sort
    end
    context "assigns trips_by_date" do
      before(:each) do
        (1..5).each do |i|
          date_str = Date.today + i.days
          i.times { Factory.create(:trip, :date => date_str)}
        end
      end
      it "should have 5 date keys" do
        get :calendar
        assigns[:trips_by_date].keys.length.should == 5
      end
      it "should have 1 trip in the earliest date" do
        get :calendar
        assigns[:trips_by_date][(Date.today + 1.days).strftime("%Y%m%d")].length.should == 1
      end
      it "should have 5 trips in the latest date " do
        get :calendar
        assigns[:trips_by_date][(Date.today + 5.days).strftime("%Y%m%d")].length.should == 5
      end
      it "should only contain trip objects" do
        get :calendar
        assigns[:trips_by_date][(Date.today + 5.days).strftime("%Y%m%d")].first.class.should == Trip
      end
    end
    context "Filtering trips" do
      it "should only include trips in @Trip that go to selected destination when filtering for that destination" do
        trip_destinations =  ["Rutledge", "Memphis", "Fairfield", "Quincy", "Kirksville"]
        trip_destinations.each  do |d|
          Factory(:trip, :destination => d, :date => Date.today + 1.day)
        end
        get :calendar, :destination => 'Rutledge'
        trip_results = assigns[:trips].collect {|d| d.destination}
        trip_results.should include("Rutledge")
        for other_dest in trip_destinations.reject {|d| d == "Rutledge"}
          trip_results.should_not include(other_dest)
        end
      end

    end
  end

  describe "GET show" do
    it "assigns the requested trip as @trip" do
      Trip.stub(:find).with("37").and_return(mock_trip)
      get :show, :id => "37"
      assigns[:trip].should equal(mock_trip)
    end
  end

  describe "GET new" do
    it "gets the trip date from params if present" do
      Trip.should_receive(:new).with(:date => '20100415')
      get :new, :date => '20100415'
    end
    it "assigns a new trip as @trip" do
      Trip.stub(:new).and_return(mock_trip)
      get :new
      assigns[:trip].should equal(mock_trip)
    end
    it "assigns a list of communities" do
      names = ['a', 'b', 'c']
      names.each {|n| Community.create :name => n}
      get :new
      assigns[:communities].should == names
    end
    it "assigns a list of vehicles" do
      names = ['bug', 'beetle', 'rabbit']
      names.each {|n| Vehicle.create(:name => n)}
      get :new
      assigns[:vehicles].should == names
    end
  end

  describe "GET edit" do
    before(:each) do
      Trip.stub(:find).with("37").and_return(mock_trip)
    end

    it "assigns the requested trip as @trip" do
      get :edit, :id => "37"
      assigns[:trip].should equal(mock_trip)
    end
    it "assigns @communities" do
      communities =  ['DR', 'SH', 'RE'].collect {|c| Community.create :name => c}
      Community.stub(:all).and_return(communities)
      get :edit, :id => "37"
      assigns[:communities].should == (['DR', 'SH', 'RE'])
    end
    it "assigns @communities" do
      vehicles =  ['truck', 'Vdub', 'Porsche'].collect {|v| Vehicle.create :name => v}
      Community.stub(:all).and_return(vehicles)
      get :edit, :id => "37"
      assigns[:vehicles].should == (['truck', 'Vdub', 'Porsche'])
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created trip as @trip" do
        Trip.stub(:new).with({'these' => 'params'}).and_return(mock_trip(:save => true))
        post :create, :trip => {:these => 'params'}
        assigns[:trip].should equal(mock_trip)
      end

      it "redirects to the home page on success" do
        Trip.stub(:new).and_return(mock_trip(:save => true))
        post :create, :trip => {}
        response.should redirect_to(root_path)
      end
    end


    describe "with invalid params" do
      it "assigns a newly created but unsaved trip as @trip" do
        Trip.stub(:new).with({'these' => 'params'}).and_return(mock_trip(:save => false))
        post :create, :trip => {:these => 'params'}
        assigns[:trip].should equal(mock_trip)
      end

      it "re-renders the 'new' template" do
        Trip.stub(:new).and_return(mock_trip(:save => false))
        post :create, :trip => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested trip" do
        Trip.should_receive(:find).with("37").and_return(mock_trip)
        mock_trip.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :trip => {:these => 'params'}
      end

      it "assigns the requested trip as @trip" do
        Trip.stub(:find).and_return(mock_trip(:update_attributes => true))
        put :update, :id => "1"
        assigns[:trip].should equal(mock_trip)
      end

      it "redirects to the homepage" do
        Trip.stub(:find).and_return(mock_trip(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      it "updates the requested trip" do
        Trip.should_receive(:find).with("37").and_return(mock_trip)
        mock_trip.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :trip => {:these => 'params'}
      end

      it "assigns the trip as @trip" do
        Trip.stub(:find).and_return(mock_trip(:update_attributes => false))
        put :update, :id => "1"
        assigns[:trip].should equal(mock_trip)
      end

      it "re-renders the 'edit' template" do
        Trip.stub(:find).and_return(mock_trip(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested trip" do
      Trip.should_receive(:find).with("37").and_return(mock_trip)
      mock_trip.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to home page" do
      Trip.stub(:find).and_return(mock_trip(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(root_url)
    end
  end

end


# describe TripsController, 'POST create' do
#   before(:each) do
#     @trip_params = Factory.attributes_for(:trip)
#     @trip_params.each do |k,v|
#       @trip_params.delete(k)
#       unless [:data, :depart, :return].include?(k)
#         @trip_params[k.to_s] = v
#       end
#     end
#     @trip = mock_model(Trip).as_null_object
#     Trip.stub(:new).and_return(@trip)
#   end
#   it "creates a new trip" do
#     Trip.should_receive(:new).with(@trip_params).and_return(@trip)
#     post :create, :trip => @trip_params
#   end
#   context "displays existing trips" do
#     it "does not show trips older than today" do
#       pending
#     end
#     it "groups trips by date" do
#       pending
#     end
#     it "orders trips on the same day by departure time" do
#       pending
#     end
#     it "assigns a class to a day based on the trip destinations for that day" do
#       pending
#     end
#
#   end
# end
