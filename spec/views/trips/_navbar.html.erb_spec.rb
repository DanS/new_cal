require 'spec_helper'

describe "trips/_navbar.html.erb" do
  before(:each) do
    assigns[:start_date] = '20100101'
  end
    it "should display >< links for moving to different month" do
      previous_month = '20101101'
      next_month = '20110101'
    assigns[:start_date] = '20101201'
      render
      response.should have_selector('div', :id=>'navbar')  do |navbar|
        navbar.should have_selector('a',:href => "/?start_date=#{previous_month}")
        navbar.should have_selector('a', :href => "/?start_date=#{next_month}")
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
      navbar.should have_selector('a', :href => "/?cal_type=wip")
    end
  end
end
