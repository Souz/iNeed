Feature: Needers Locations 
	In order to know more about the Need
	As a user
	I want to see the number of needeers in different loctions on a certain need

Scenario: No Needers
	Given the following customers exists:
		| name   | email           | password | location |
		| tester | tester@test.com | password | egypt    |
    And a category "Electronics" with a need "Radio" with description "am fm"
	When I go to the customers sign in page
	Then I can fill the "customer[email]" with "tester@test.com"
	And I can fill the "customer[password]" with "password"
	Then I press the "Log in" button
	Then I visit the customer needs "Radio" page
	And I should not see "needers in" written on the page
	And I should see "iNeed" in a button

Scenario: Me needing
	Given the following customers exists:
		| name   | email           | password | location |
		| tester | tester@test.com | password | egypt    |
    And a category "Electronics" with a need "Radio" with description "am fm"
	When I go to the customers sign in page
	Then I can fill the "customer[email]" with "tester@test.com"
	And I can fill the "customer[password]" with "password"
	Then I press the "Log in" button
	And I visit the customer needs "Radio" page
    When I click a button named "iNeed"
    Then I should see "needers in egypt" written on the page
