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
      get :foo, {'x'=>"clear"}, {'x'=>"sessionValue"} #assign values to params and session
      controller.param_session_default('x', "defaultValue").should == nil
    end
    it "should return a date object if value is a string that can parse as a date" do
      get :foo, {'x'=>"20101010"}, {} #assign value to params
      controller.param_session_default('x', "defaultValue").class.should == Date
    end
  end
end