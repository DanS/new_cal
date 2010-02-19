require 'spec_helper'
describe TripsController do

  def mock_trip(stubs={})
    @mock_trip ||= mock_model(Trip, stubs).as_null_object
  end

  describe "GET calendar" do #replaces index action
    before(:each) do
    end
    it "assigns all trips as @trips" do
      Trip.stub(:find).with(:all).and_return([mock_trip])
      get :calendar
      assigns[:trips].should == [mock_trip]
    end
    it "assigns start_date to be the first of the current month" do
      get :calendar
      assigns[:start_date].should == Date.today.strftime("%Y%m") + "01"
    end
    it "assigns destinations " do
      destinations = {'Quincy' => 1, 'Rutledge' => 2, 'La Plata' => 3, 'Kirksville' => 4,
                      'Memphis' => 1, 'Fairfield' => 1}
      destinations.each {|dest, count| count.times {Factory(:trip, :destination => dest)}}
      get :calendar
      destination_list = destinations.collect {|k,v| k + "(#{v})"}
      assigns[:destination_list].should == destination_list.sort
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
  end


  describe "GET show" do
    it "assigns the requested trip as @trip" do
      Trip.stub(:find).with("37").and_return(mock_trip)
      get :show, :id => "37"
      assigns[:trip].should equal(mock_trip)
    end
  end

  describe "GET new" do
    it "assigns a new trip as @trip" do
      Trip.stub(:new).and_return(mock_trip)
      get :new
      assigns[:trip].should equal(mock_trip)
    end
  end

  describe "GET edit" do
    it "assigns the requested trip as @trip" do
      Trip.stub(:find).with("37").and_return(mock_trip)
      get :edit, :id => "37"
      assigns[:trip].should equal(mock_trip)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created trip as @trip" do
        Trip.stub(:new).with({'these' => 'params'}).and_return(mock_trip(:save => true))
        post :create, :trip => {:these => 'params'}
        assigns[:trip].should equal(mock_trip)
      end

      it "redirects to the created trip" do
        Trip.stub(:new).and_return(mock_trip(:save => true))
        post :create, :trip => {}
        response.should redirect_to(trip_url(mock_trip))
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

      it "redirects to the trip" do
        Trip.stub(:find).and_return(mock_trip(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(trip_url(mock_trip))
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

    it "redirects to the trips list" do
      Trip.stub(:find).and_return(mock_trip(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(trips_url)
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
