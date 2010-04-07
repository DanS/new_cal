require 'spec_helper'
describe TripsController do

  def mock_trip(stubs={})
    @mock_trip ||= mock_model(Trip, stubs).as_null_object
  end

  describe "GET calendar" do #replaces index action

    context "Calendar date range " do
      before(:all) do
        @date_string = (Date.today + 1.month).strftime("%Y%m") + '01'
        @date_obj = Date.parse(@date_string)
      end

      it "assigns start date to session value when present" do
        get :calendar, {}, {:start_date => @date_string }
        assigns[:start_date].should == @date_obj
      end
      it "assigns start date to params value if both param and session values present" do
        param_value = '10001010'
        session_value = '20001010'
        get :calendar, {:start_date => param_value}, {:start_date => session_value}
        assigns[:start_date].should == Date.parse(param_value)
      end
      it "assigns start date to default value if start_date not in params or session" do
        #default start date is first day of current month
        get :calendar, {}, {}
        assigns[:start_date].should == Date.parse(Date.today.strftime("%Y%m") + '01')
      end
      it "assigns start_date to the first of the week if cal_type = week" do
        (1..6).each do |n|
          start_date = (20100404 + n).to_s
          get :calendar, {:start_date => start_date, :cal_type => 'week'}
          assigns[:start_date].should == "20100404"
        end
      end
    end
    context "assigning cal-type" do
      it "should assign a cal-type of month if cal_type not in params or session" do
        get :calendar, {}
        assigns[:cal_type].should == "month"
      end
      it "should assign a cal_type to param value if present" do
        get :calendar, {:cal_type => "params"},{:cal_type => 'session'}
        assigns[:cal_type].should == 'params'
      end
      it "should assign a cal_type to session value if session present but not params" do
        get :calendar, {}, {:cal_type => 'session'}
        assigns[:cal_type].should == 'session'
      end
      it "should get only 1 week of trips when cal_type is week" do
        get :calendar, {:cal_type => 'week'}
        assigns[:trips_by_date].keys.length.should == 7
      end
      it "should have date keys for all days between start_date and end_date params with cal_type == week" do
        get :calendar, {:start_date=>'20100404', :end_date=>'20100410', :cal_type=>'week'}
        assigns[:trips_by_date].keys.sort.should == ["20100404", "20100405", "20100406", "20100407", "20100408",
          "20100409", "20100410"]
      end
      it "should not have date keys outside the date range" do
        10.times {|i| Factory(:trip, :date => Date.today + i.days)}
        get :calendar, {:start_date=>'20100404', :cal_type=>'week'}
        assigns[:trips_by_date].keys.sort.should == ["20100404", "20100405", "20100406", "20100407", "20100408",
          "20100409", "20100410"]
      end
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

