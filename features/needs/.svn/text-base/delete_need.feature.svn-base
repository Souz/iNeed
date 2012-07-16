Feature: Automatically delete reported needs
In order to guarantee need"s quality
Reported needs that exceeds x number of reports should be deleted

	Scenario: Successfully delete need
  Given the following customers exists:
      | name    | email                | password | location |
      | marina  | marina@hotmail.com   | password | location |
      | dalia   | dalia@hotmail.com    | password | location |
      | nada    | nada@hotmail.com     | password | location |
      | sherry  | sherry@hotmail.com   | password | location |
    And I have the following categories:
      |   name    |
      | Apple     |

    And these needs with category "Apple" and customer "sherry":
      | name         | description| category_name | customer |          
      | iPhone456    | touch      | Apple         | sherry   | 


    When I go to the customers sign in page
    	Then I can fill the "customer[email]" with "marina@hotmail.com"
    	And I can fill the "customer[password]" with "password"
  		Then I press the "Log in" button
    	Then I visit the customer needs "iPhone456" page 
    	And I choose 'spam'
     	And I press the "Submit" button
      Then I click the "Sign out" link

    When I go to the customers sign in page
      Then I can fill the "customer[email]" with "dalia@hotmail.com "
      And I can fill the "customer[password]" with "password"
      Then I press the "Log in" button
      Then I visit the customer needs "iPhone456" page 
      And I choose 'spam'
      And I press the "Submit" button
      Then I click the "Sign out" link

    When I go to the customers sign in page
      Then I can fill the "customer[email]" with "nada@hotmail.com"
      And I can fill the "customer[password]" with "password"
      Then I press the "Log in" button
      Then I visit the customer needs "iPhone456" page 
      And I choose 'spam'
      And I press the "Submit" button
      Then I should see a flash message saying "This need has been deleted."
  
