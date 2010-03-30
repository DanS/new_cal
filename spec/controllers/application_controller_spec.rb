require 'spec_helper'
describe ApplicationController do
  context "param_session_default method" do
    it "should return default value if arg not a key in params or session" do
      controller.assign_from_param_session_or_default('x', 99).should == 99
    end
    it "should return session value if arg not in params" do
      session['x'] = 88
      controller.assign_from_param_session_or_default('x', 99).should == 88
    end
    it "should return param value if present" do
      pending()
      #don't know how to set value of params for this test
      #get :assign_from_param_session_or_default('i', 0), {'x' => 77}, {'x' => 88}
      #      session['x'] = 88
      #      assigns(:params) = {'x' => 77}
      controller.assign_from_param_session_or_default('x', 99).should == 77
      session['x'].should == 77
    end
    it "should set session to param value if param present" do
      #don't know how to set value of params for this test
      pending()
      session['x'] = 88
      params = double('params-double')
      params['x'] = 77
      controller.assign_from_param_session_or_default(:x, 99)
      session['x'].should == 77
    end
  end
end