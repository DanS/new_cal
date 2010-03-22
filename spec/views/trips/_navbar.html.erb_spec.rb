require 'spec_helper'

describe "trips/_navbar.html.erb" do

  it "should display >< links for moving to different month" do
    previous_month = (Date.today - 1.month).strftime("%Y%m") +'01'
    next_month = (Date.today + 1.month).strftime("%Y%m") +'01'
    render
    response.should have_selector('div', :id=>'navbar')  do |navbar|
      navbar.should have_selector('a',:href => "/?date=#{previous_month}")
      navbar.should have_selector('a', :href => "/?date=#{next_month}")
    end
  end

  it "should display a link for month view" do
    render
    response.should have_selector('div', :id=>'navbar')  do |navbar|
      navbar.should have_selector('a', :href => "/?type=month")
    end
  end
  it "should display a link for week view" do
    render
    response.should have_selector('div', :id=>'navbar')  do |navbar|
      navbar.should have_selector('a', :href => "/?type=week")
    end
  end
  it "should display a link for WIP view" do
    render
    response.should have_selector('div', :id=>'navbar')  do |navbar|
      navbar.should have_selector('a', :href => "/?type=wip")
    end
  end
end
