require "uri"
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am viewing the calendar starting on "(\d{8})"$/ do |date|
  visit path_to("/?start_date=#{date}")
end
