require 'spec_helper'

describe "trips/_navbar.html.erb" do
  before(:each) do
    assigns[:start_date] = '20100101'
  end
  describe "< > links should move calendar forward and backward" do
    it "should have links for changing month when cal_type == month" do
      previous_month = '20101101'
      next_month = '20110101'
      assigns[:start_date] = '20101201'
      assigns[:cal_type] = 'month'
      render
      response.should have_selector('div', :id=>'navbar')  do |navbar|
        navbar.should have_selector('a',:href => "/?start_date=#{previous_month}")
        navbar.should have_selector('a', :href => "/?start_date=#{next_month}")
      end
    end
    it "should have links for changing week when cal_type is week" do
      previous_week = '20100328'
      next_week = '20100411'
      assigns[:start_date] = '20100404'
      assigns[:cal_type] = 'week'
      render
      response.should have_selector('div', :id=>'navbar') do |navbar|
        navbar.should have_selector('a', :href => "/?start_date=#{previous_week}")
        navbar.should have_selector('a', :href => "/?start_date=#{next_week}")
      end
    end
  end
  
  it "should display a link for month view" do
    render
    response.should have_selector('div', :id=>'navbar')  do |navbar|
      navbar.should have_selector('a', :href => "/?cal_type=month")
    end
  end
  it "should display a link for week view" do
    render
    response.should have_selector('div', :id=>'navbar')  do |navbar|
      navbar.should have_selector('a', :href => "/?cal_type=week")
    end
  end
  it "should display a link for WIP view" do
    render
    response.should have_selector('div', :id=>'navbar')  do |navbar|
      navbar.should have_selector('a', :href => "/wip")
    end
  end
end
