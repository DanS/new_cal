require 'spec_helper'
describe ApplicationController do
  context "param_session_default method" do
    before(:each) do
      class  ApplicationController
        #create a phony action so we can set params and session values with
        #get :foo, {:paramsValue=> "someValue}, {:sessionValue => "somevalue"}
        def foo; render :text => 'foobar'; end
      end
    end

    it "should return default value if arg not a key in params or session" do
      get :foo, {}, {} #empty params and session
      controller.param_session_default('x', 99).should == 99
    end
    it "should return session value if arg not in params" do
      get :foo, {}, {'x'=>"sessionValue"} #empty params and assign value to session
      controller.param_session_default('x', "defaultValue").should == "sessionValue"
    end
    it "should return param value if both session and param values present" do
      get :foo, {'x'=>"paramValue"}, {'x'=>"sessionValue"} #assign values to params and session
      controller.param_session_default('x', "defaultValue").should == "paramValue"
    end
    it "should set session to param value if param present" do
      get :foo, {'x'=>"paramValue"}, {'x'=>"sessionValue"} #assign values to params and session
      controller.param_session_default('x', "defaultValue")
      session['x'].should == "paramValue"
    end
    it "should set session value to nil and return nil if param value is 'clear' " do
      get :foo, {'x'=>"paramValue"}, {'x'=>"sessionValue"} #assign values to params and session
      get :foo, {'x'=>"clear"}, {'x'=>"sessionValue"} #see if "all" alls value
      controller.param_session_default('x', "defaultValue").should == nil
      session['x'].should == nil
    end
    it "should return a date object if value is a string that can parse as a date" do
      get :foo, {'x'=>"20101010"}, {} #assign value to params
      controller.param_session_default('x', "defaultValue").class.should == Date
    end
    it "should not return a date object for non-numeric strings like 'month' " do
      get :foo, {'x'=>'month'},{}
      controller.param_session_default('x', 'month').class.should_not == Date
    end
  end

  describe "dates_between" do
    it "should return a hash where the keys are strings describing all the dates between dates given" do
      controller.dates_between('20100101', '20100107').keys.sort.should == ["20100101", "20100102",
        "20100103", "20100104", "20100105", "20100106", "20100107"]
      controller.dates_between('20091229', '20100107').keys.sort.should == ["20091229", "20091230",
        "20091231", "20100101", "20100102", "20100103", "20100104", "20100105",
        "20100106", "20100107"]
    end
  end

  describe "end_of_week" do
    it "should return the day 6 days from given date" do
      controller.end_of_week(Date.parse('20100404')).should == '20100410'
      controller.end_of_week(Date.parse('20101226')).should == '20110101'
    end
  end

  describe "to_destination_list method" do
    it "should convert a trips_by_date to a destination_list" do
      trips_by_date = Hash.new {|hash, key| hash[key] = []}
      destinations = ['Quincy', 'Kirksville', 'Memphis', 'Columbia']
      Factory(:destination, :place => 'Other', :letter =>'O')
      destinations.each {|d| Factory(:destination, :place => d, :letter => d.first)}
      ['20100401', '20100408', '20100415', '20100422'].each_with_index do |date, i|
        (i + 1).times {trips_by_date[date] << Factory(:trip, :destination => destinations[i])}
      end
      result = controller.to_destination_list(trips_by_date)
      result.keys.sort.should == ['Columbia', 'Kirksville', 'Memphis', 'Quincy']
      result.values.sort.should == [[1, "Q"], [2, "K"], [3, "M"], [4, "C"]]
    end
  end

  describe "start_date_for_week method" do
    it "returns first day of current week if passed date is older than that" do
      controller.start_date_for_week(Date.parse('20000101')).should ==
            (Date.today - Date.today.wday.days).strftime("%Y%m%d")
    end
    it "returns first day of future week if passed date newer than current week" do
      controller.start_date_for_week(Date.parse('21000105')).should ==
            (Date.parse('21000103')).strftime("%Y%m%d")
    end
  end
end