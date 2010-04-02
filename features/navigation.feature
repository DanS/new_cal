Feature: Navigation
  In order to view different calendar dates and views
  As a user
  I want a navigation bar

 Scenario: move to previous month
   Given I am viewing the calendar starting on "20100301"
   When I follow "prev-month"
   Then I should see "February"
 
  Scenario: move to next month
   Given I am viewing the calendar starting on "20100301"
   When I follow "next-month"
   Then I should see "June"

  Scenario: move to week view
    Given I am in month view
    When I follow week
    Then outcome



 
 
